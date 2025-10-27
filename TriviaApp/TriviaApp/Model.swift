//
//  Model.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI
import Combine

// MARK: - Models

struct TriviaResponse: Codable {
    let response_code: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id: UUID
    let category: String
    let type: String           // "multiple" or "boolean"
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    // Cached shuffled answers to prevent re-shuffling on every render
    private let _shuffledAnswers: [String]
    
    init(id: UUID = UUID(), category: String, type: String, difficulty: String, question: String, correct_answer: String, incorrect_answers: [String], shuffledAnswers: [String]) {
        self.id = id
        self.category = category
        self.type = type
        self.difficulty = difficulty
        self.question = question
        self.correct_answer = correct_answer
        self.incorrect_answers = incorrect_answers
        self._shuffledAnswers = shuffledAnswers
    }
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question, correct_answer, incorrect_answers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.category = try container.decode(String.self, forKey: .category)
        self.type = try container.decode(String.self, forKey: .type)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.question = try container.decode(String.self, forKey: .question)
        self.correct_answer = try container.decode(String.self, forKey: .correct_answer)
        self.incorrect_answers = try container.decode([String].self, forKey: .incorrect_answers)
        
        // Shuffle once during initialization
        var all = incorrect_answers
        all.append(correct_answer)
        self._shuffledAnswers = all.shuffled()
    }
    
    // Cached shuffled answers
    func shuffledAnswers() -> [String] {
        return _shuffledAnswers
    }
    
    // Decode HTML entities (API returns HTML encoded strings)
    func decodedQuestion() -> String {
        question.htmlDecoded()
    }
    func decodedCorrect() -> String { correct_answer.htmlDecoded() }
    func decodedIncorrects() -> [String] { incorrect_answers.map { $0.htmlDecoded() } }
}

// MARK: - Helpers (HTML decode)

extension String {
    // Simple HTML entities decode - thread-safe and reliable
    func htmlDecoded() -> String {
        var result = self
        
        // First handle &amp; to avoid double-decoding
        result = result.replacingOccurrences(of: "&amp;", with: "&")
        
        // Common HTML entities
        let entities: [(String, String)] = [
            ("&#039;", "'"),
            ("&apos;", "'"),
            ("&quot;", "\""),
            ("&lt;", "<"),
            ("&gt;", ">"),
            ("&nbsp;", " "),
            ("&ldquo;", "\""),
            ("&rdquo;", "\""),
            ("&lsquo;", "'"),
            ("&rsquo;", "'"),
            ("&hellip;", "..."),
            ("&mdash;", "—"),
            ("&ndash;", "–"),
            ("&eacute;", "é")
        ]
        
        // Replace entities
        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement, options: .literal)
        }
        
        // Handle numeric entities like &#39; &#44; etc
        do {
            let regex = try NSRegularExpression(pattern: #"&#(\d+);"#, options: [])
            let range = NSRange(location: 0, length: result.utf16.count)
            let matches = regex.matches(in: result, options: [], range: range)
            
            var mutableResult = NSMutableString(string: result)
            for match in matches.reversed() {
                if match.numberOfRanges >= 2,
                   let numRange = Range(match.range(at: 1), in: result),
                   let num = Int(result[numRange]),
                   let char = UnicodeScalar(num).map({ Character($0) }) {
                    mutableResult.replaceCharacters(in: match.range, with: String(char))
                }
            }
            result = mutableResult as String
        } catch {
            // If regex fails, just return what we have
        }
        
        return result
    }
}

// MARK: - API Client

enum TriviaError: Error, LocalizedError {
    case badURL
    case serverError(String)
    case decodingError(Error)
    case noResults
    case unknown
    var errorDescription: String? {
        switch self {
        case .badURL: return "Bad URL."
        case .serverError(let m): return m
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        case .noResults: return "No questions available for your criteria. Try different options."
        case .unknown: return "Unknown error."
        }
    }
}

struct TriviaAPI {
    // Build URL for Open Trivia DB
    // Example: https://opentdb.com/api.php?amount=10&category=11&difficulty=medium&type=multiple&encode=url3986
    static func makeURL(amount: Int, category: Int?, difficulty: String?, type: String?, encoding: String?) throws -> URL {
        var components = URLComponents(string: "https://opentdb.com/api.php")
        var queryItems = [URLQueryItem(name: "amount", value: "\(amount)")]
        if let cat = category { queryItems.append(URLQueryItem(name: "category", value: "\(cat)")) }
        if let diff = difficulty, diff.lowercased() != "any" { queryItems.append(URLQueryItem(name: "difficulty", value: diff.lowercased())) }
        if let t = type, t.lowercased() != "any" { queryItems.append(URLQueryItem(name: "type", value: t.lowercased())) }
        if let enc = encoding, enc.lowercased() != "default" { queryItems.append(URLQueryItem(name: "encode", value: enc)) }
        components?.queryItems = queryItems
        guard let url = components?.url else { throw TriviaError.badURL }
        return url
    }
    
    static func fetchQuestions(amount: Int, category: Int?, difficulty: String?, type: String?, encoding: String?) async throws -> [TriviaQuestion] {
        let url = try makeURL(amount: amount, category: category, difficulty: difficulty, type: type, encoding: encoding)
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw TriviaError.serverError("HTTP \(http.statusCode)")
        }
        do {
            let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
            
            // Check response code
            switch decoded.response_code {
            case 0: // Success
                return decoded.results
            case 1: // No Results - not enough questions for query
                throw TriviaError.noResults
            case 2: // Invalid Parameter
                throw TriviaError.serverError("Invalid parameters")
            case 3: // Token Not Found
                throw TriviaError.serverError("Session token not found")
            case 4: // Token Empty
                throw TriviaError.serverError("Session token exhausted")
            default:
                throw TriviaError.serverError("Unknown response code: \(decoded.response_code)")
            }
        } catch {
            if error is TriviaError {
                throw error
            }
            throw TriviaError.decodingError(error)
        }
    }
}
