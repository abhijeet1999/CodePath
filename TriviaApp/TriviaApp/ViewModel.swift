//
//  ViewModel.swift
//  TriviaApp
//
//  Created by Abhijeet Cherungottil on 10/23/25.
//

import SwiftUI
import Combine

// MARK: - View Model

@MainActor
class TriviaViewModel: ObservableObject {
    // Options
    @Published var numberOfQuestions: Int = 10
    @Published var selectedCategory: TriviaCategory = .any
    @Published var difficultyValue: Double = 0 // For slider: 0=any, 1=easy, 2=medium, 3=hard
    @Published var selectedType: TriviaType = .any
    @Published var selectedEncoding: TriviaEncoding = .defaultEncoding
    @Published var useCardView: Bool = true
    
    // Computed difficulty from slider value
    var selectedDifficulty: TriviaDifficulty {
        switch difficultyValue {
        case 0: return .any
        case 1: return .easy
        case 2: return .medium
        case 3: return .hard
        default: return .any
        }
    }
    
    // Game state
    @Published var questions: [TriviaQuestion] = []
    @Published var selections: [UUID: String] = [:] // question.id -> user selected answer
    @Published var hasSubmitted: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Timer
    @Published var timeRemaining: Int = 0
    @Published var selectedTimeDuration: TimeDuration = .fiveMinutes
    var totalTime: Int = 0
    var timerTask: Task<Void, Never>?
    
    // Score
    var score: Int {
        guard hasSubmitted else { return 0 }
        return questions.reduce(0) { acc, q in
            let selected = selections[q.id]
            return acc + ((selected == q.decodedCorrect()) ? 1 : 0)
        }
    }
    
    func loadQuestions() async {
        isLoading = true
        errorMessage = nil
        hasSubmitted = false
        selections = [:]
        questions = []
        stopTimer()
        do {
            let questionsFetched = try await TriviaAPI.fetchQuestions(
                amount: numberOfQuestions,
                category: selectedCategory.rawValueInt,
                difficulty: selectedDifficulty.rawValueString,
                type: selectedType.rawValueString,
                encoding: selectedEncoding.rawValueString
            )
            self.questions = questionsFetched
            isLoading = false
            // Use selected time duration
            totalTime = selectedTimeDuration.seconds
            timeRemaining = totalTime
            if totalTime > 0 {
                startTimer()
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func selectAnswer(question: TriviaQuestion, answer: String) {
        guard !hasSubmitted else { return } // don't allow changing after submission
        selections[question.id] = answer
    }
    
    func submit() {
        stopTimer()
        hasSubmitted = true
    }
    
    func startTimer() {
        stopTimer() // cancel old
        guard totalTime > 0 else { return }
        timerTask = Task { @MainActor [weak self] in
            guard let self = self else { return }
            while self.timeRemaining > 0 && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                self.timeRemaining -= 1
            }
            if self.timeRemaining <= 0 && !self.hasSubmitted {
                // Auto-submit
                self.hasSubmitted = true
            }
        }
    }
    
    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    deinit {
        timerTask?.cancel()
    }
}

// MARK: - Enums for options

enum TriviaCategory: String, CaseIterable, Identifiable {
    case any = "Any Category"
    case general = "General Knowledge"
    case books = "Entertainment: Books"
    case film = "Entertainment: Film"
    case music = "Entertainment: Music"
    case musicals = "Entertainment: Musicals & Theatres"
    case television = "Entertainment: Television"
    case videoGames = "Entertainment: Video Games"
    case boardGames = "Entertainment: Board Games"
    case science = "Science & Nature"
    case computers = "Science: Computers"
    case mathematics = "Science: Mathematics"
    case mythology = "Mythology"
    case sports = "Sports"
    case geography = "Geography"
    case history = "History"
    case politics = "Politics"
    case art = "Art"
    case celebrities = "Celebrities"
    case animals = "Animals"
    case vehicles = "Vehicles"
    case comics = "Entertainment: Comics"
    case gadgets = "Science: Gadgets"
    case anime = "Entertainment: Japanese Anime & Manga"
    case cartoons = "Entertainment: Cartoon & Animations"
    
    var id: String { rawValue }
    
    var rawValueInt: Int? {
        switch self {
        case .any: return nil
        case .general: return 9
        case .books: return 10
        case .film: return 11
        case .music: return 12
        case .musicals: return 13
        case .television: return 14
        case .videoGames: return 15
        case .boardGames: return 16
        case .science: return 17
        case .computers: return 18
        case .mathematics: return 19
        case .mythology: return 20
        case .sports: return 21
        case .geography: return 22
        case .history: return 23
        case .politics: return 24
        case .art: return 25
        case .celebrities: return 26
        case .animals: return 27
        case .vehicles: return 28
        case .comics: return 29
        case .gadgets: return 30
        case .anime: return 31
        case .cartoons: return 32
        }
    }
}

enum TriviaDifficulty: String, CaseIterable, Identifiable {
    case any = "Any"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    var id: String { rawValue }
    var rawValueString: String? {
        switch self {
        case .any: return nil
        case .easy: return "easy"
        case .medium: return "medium"
        case .hard: return "hard"
        }
    }
}

enum TriviaType: String, CaseIterable, Identifiable {
    case any = "Any Type"
    case multiple = "Multiple Choice"
    case boolean = "True / False"
    var id: String { rawValue }
    var rawValueString: String? {
        switch self {
        case .any: return nil
        case .multiple: return "multiple"
        case .boolean: return "boolean"
        }
    }
}

enum TriviaEncoding: String, CaseIterable, Identifiable {
    case `default` = "Default Encoding"
    case url3986 = "URL 3986"
    case base64 = "Base64"
    var id: String { rawValue }
    var rawValueString: String? {
        switch self {
        case .default: return "default"
        case .url3986: return "url3986"
        case .base64: return "base64"
        }
    }
    static var defaultEncoding: TriviaEncoding { .default }
}

enum TimeDuration: String, CaseIterable, Identifiable {
    case oneMinute = "1 Minute"
    case fiveMinutes = "5 Minutes"
    case fifteenMinutes = "15 Minutes"
    case thirtyMinutes = "30 Minutes"
    case oneHour = "1 Hour"
    
    var id: String { rawValue }
    
    var seconds: Int {
        switch self {
        case .oneMinute: return 60
        case .fiveMinutes: return 300
        case .fifteenMinutes: return 900
        case .thirtyMinutes: return 1800
        case .oneHour: return 3600
        }
    }
}
