//
//  TranslationService.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import Foundation

// Models for MyMemory response
struct MyMemoryResponse: Codable {
    let responseData: MyMemoryData
    let quotaFinished: Bool?
    let responseStatus: Int?
    let matches: [TranslationMatch]?
}

struct MyMemoryData: Codable {
    let translatedText: String
    let match: Double? // Match quality (0-1), where 1 is perfect match
}

struct TranslationMatch: Codable {
    // ID can be either a String or Int in the API response
    let id: String?
    let segment: String?
    let translation: String?
    let source: String?
    let target: String?
    let quality: Int? // Quality score (0-100)
    let match: Double? // Match quality (0-1)
    
    // Custom decoding to handle ID as either String or Int
    enum CodingKeys: String, CodingKey {
        case id, segment, translation, source, target, quality, match
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode ID as String first, then as Int if that fails
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = idString
        } else if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            id = nil
        }
        
        segment = try? container.decode(String.self, forKey: .segment)
        translation = try? container.decode(String.self, forKey: .translation)
        source = try? container.decode(String.self, forKey: .source)
        target = try? container.decode(String.self, forKey: .target)
        
        // Quality can be either Int or String in the API response
        if let qualityInt = try? container.decode(Int.self, forKey: .quality) {
            quality = qualityInt
        } else if let qualityString = try? container.decode(String.self, forKey: .quality),
                  let qualityInt = Int(qualityString) {
            quality = qualityInt
        } else {
            quality = nil
        }
        
        match = try? container.decode(Double.self, forKey: .match)
    }
}

enum TranslationError: Error {
    case badURL
    case decodingError
    case networkError(Error)
    case noData
}

final class TranslationService {
    /// Translate `text` from `source` to `target` using MyMemory public API.
    /// Note: MyMemory has rate limits; consider adding key for heavy usage.
    func translate(text: String, from source: String, to target: String) async throws -> String {
        print("🌐 [TranslationService] Starting translation")
        print("📝 [TranslationService] Input text: '\(text)'")
        print("🌍 [TranslationService] Language pair: \(source) → \(target)")
        
        // Use URLComponents for proper URL encoding
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(source)|\(target)"),
            URLQueryItem(name: "mt", value: "1")
        ]
        
        guard let url = components.url else {
            print("❌ [TranslationService] ERROR: Failed to create URL")
            throw TranslationError.badURL
        }
        
        print("🔗 [TranslationService] API URL: \(url.absoluteString)")
        
        do {
            print("📡 [TranslationService] Making network request...")
            let startTime = Date()
            let (data, response) = try await URLSession.shared.data(from: url)
            let duration = Date().timeIntervalSince(startTime)
            print("✅ [TranslationService] Network request completed in \(String(format: "%.2f", duration))s")
            print("📦 [TranslationService] Received \(data.count) bytes of data")
            
            // Optional: check response code
            if let http = response as? HTTPURLResponse {
                print("📊 [TranslationService] HTTP Status Code: \(http.statusCode)")
                if !(200...299).contains(http.statusCode) {
                    print("❌ [TranslationService] ERROR: HTTP error status \(http.statusCode)")
                    throw TranslationError.networkError(NSError(domain: "", code: http.statusCode, userInfo: nil))
                }
            }
            
            print("🔍 [TranslationService] Decoding JSON response...")
            
            // Log raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 [TranslationService] Raw JSON response:")
                print("   \(jsonString.prefix(500))...") // Print first 500 chars
            }
            
            let decoder = JSONDecoder()
            let mm = try decoder.decode(MyMemoryResponse.self, from: data)
            
            // Log match quality and translation matches
            if let match = mm.responseData.match {
                print("📊 [TranslationService] Match quality: \(String(format: "%.0f", match * 100))% (match: \(match))")
                if match < 1.0 {
                    print("⚠️ [TranslationService] Partial match detected - translation may be incomplete")
                }
            }
            
            if let matches = mm.matches, !matches.isEmpty {
                print("📋 [TranslationService] Found \(matches.count) translation match(es)")
                for (index, match) in matches.enumerated() {
                    if let quality = match.quality, let segment = match.segment, let translation = match.translation {
                        print("   Match \(index + 1): Quality \(quality)%, '\(segment)' → '\(translation)'")
                    }
                }
            }
            
            // Check response status
            if let status = mm.responseStatus {
                print("📊 [TranslationService] Response status: \(status)")
            }
            
            // Check quota
            if let quotaFinished = mm.quotaFinished, quotaFinished {
                print("⚠️ [TranslationService] WARNING: API quota finished")
            }
            
            // MyMemory API returns URL-encoded text, so we need to decode it
            let rawText = mm.responseData.translatedText
            print("📥 [TranslationService] Raw translation from API: '\(rawText)'")
            
            // Check if translation seems incomplete
            let words = text.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            let translatedWords = rawText.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            print("📊 [TranslationService] Original word count: \(words.count), Translated word count: \(translatedWords.count)")
            
            if translatedWords.count < words.count {
                print("⚠️ [TranslationService] WARNING: Translation may be incomplete (fewer words than original)")
            }
            
            let decodedText = decodeURLEncodedString(rawText)
            print("✨ [TranslationService] Final decoded translation: '\(decodedText)'")
            
            // Check for untranslated words (words that appear the same in both languages)
            // This helps detect when parts of phrases aren't translated
            let originalWords = text.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            let decodedTranslatedWords = decodedText.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            
            // Find words that appear unchanged (possible untranslated words)
            var untranslatedWords: [String] = []
            for word in originalWords {
                if decodedTranslatedWords.contains(word) && word.count > 1 {
                    untranslatedWords.append(word)
                }
            }
            
            if !untranslatedWords.isEmpty {
                print("⚠️ [TranslationService] WARNING: Possible untranslated words detected: \(untranslatedWords)")
                print("💡 [TranslationService] Tip: Try using complete sentences for better translations")
            }
            
            print("✅ [TranslationService] Translation completed successfully")
            
            return decodedText
        } catch let decoding as DecodingError {
            print("❌ [TranslationService] ERROR: JSON decoding failed - \(decoding)")
            throw TranslationError.decodingError
        } catch {
            print("❌ [TranslationService] ERROR: Network or other error - \(error.localizedDescription)")
            print("📋 [TranslationService] Error details: \(error)")
            throw TranslationError.networkError(error)
        }
    }
    
    /// Decode URL-encoded string, handling multiple levels of encoding
    private func decodeURLEncodedString(_ string: String) -> String {
        print("🔍 [TranslationService] Starting URL decoding...")
        print("📥 [TranslationService] Input to decoder: '\(string)'")
        print("📏 [TranslationService] Input length: \(string.count) characters")
        
        var decoded = string
        
        // Fix malformed percent encoding where spaces appear between % and hex digits
        // e.g., "Hola% 20How" -> "Hola%20How", "Hola% 2BHow" -> "Hola%2BHow"
        // Use regex to match % followed by optional spaces and then hex digits
        print("🔧 [TranslationService] Fixing malformed percent encoding...")
        do {
            let regex = try NSRegularExpression(pattern: "%\\s+([0-9A-Fa-f]{2})", options: [])
            let nsString = decoded as NSString
            let range = NSRange(location: 0, length: nsString.length)
            let matches = regex.numberOfMatches(in: decoded, options: [], range: range)
            print("   Found \(matches) malformed encoding pattern(s)")
            decoded = regex.stringByReplacingMatches(in: decoded, options: [], range: range, withTemplate: "%$1")
        } catch {
            print("   ⚠️ Regex failed, using fallback replacement")
            // Fallback: simple replacement if regex fails
            decoded = decoded.replacingOccurrences(of: "% ", with: "%")
        }
        print("✅ [TranslationService] After fixing malformed encoding: '\(decoded)'")
        
        // Replace plus signs with spaces (URL encoding can use + for spaces)
        // Do this before percent decoding
        print("➕ [TranslationService] Replacing '+' with spaces...")
        let plusCount = decoded.filter { $0 == "+" }.count
        if plusCount > 0 {
            print("   Found \(plusCount) '+' character(s)")
        }
        decoded = decoded.replacingOccurrences(of: "+", with: " ")
        print("✅ [TranslationService] After replacing '+': '\(decoded)'")
        
        // Keep decoding until no more percent encoding remains
        print("🔄 [TranslationService] Starting iterative percent decoding...")
        var previousDecoded: String?
        var iterations = 0
        let maxIterations = 10 // Prevent infinite loops
        
        while decoded != previousDecoded && iterations < maxIterations {
            previousDecoded = decoded
            iterations += 1
            
            // First try standard percent decoding
            if let newDecoded = decoded.removingPercentEncoding {
                decoded = newDecoded
                print("   ✓ Iteration \(iterations): '\(decoded)'")
            } else {
                print("   ✗ Iteration \(iterations): removingPercentEncoding returned nil, stopping")
                break
            }
        }
        
        if iterations >= maxIterations {
            print("⚠️ [TranslationService] Reached max iterations (\(maxIterations))")
        }
        
        print("✨ [TranslationService] Final decoded output: '\(decoded)'")
        print("📏 [TranslationService] Final length: \(decoded.count) characters")
        
        return decoded
    }
}
