# Trivia Challenge - Interactive Quiz Game

An engaging trivia game application that fetches questions from the Open Trivia DB API. Users can customize their game experience with extensive options including question count, categories, difficulty levels, question types, and timer settings. Features both card and list views with visual feedback for answers.

## Overview

Trivia Challenge is a comprehensive quiz application built with SwiftUI that provides an interactive trivia experience. The app offers extensive customization options, multiple view modes, timer functionality, and detailed scoring with visual feedback for correct and incorrect answers.

## Features

### Game Customization

- **Question Configuration**
  - Number of questions: 1-50 (stepper control)
  - 24 categories including:
    - General Knowledge, Sports, Film, Science
    - Geography, History, Politics, Art
    - Entertainment (Books, Music, TV, Video Games)
    - Science (Computers, Mathematics, Nature)
    - And more...
  - Difficulty levels: Any, Easy, Medium, Hard (slider)
  - Question types: Multiple Choice, True/False, Any
  - Encoding options: Default, URL 3986, Base64

- **Timer Settings**
  - Customizable timer duration:
    - 1 minute
    - 5 minutes
    - 15 minutes
    - 30 minutes
    - 1 hour
  - Visual timer display in game
  - Auto-submit when timer expires
  - Real-time countdown

### Game Modes

- **Card View**
  - Beautiful flashcard-style cards
  - Question and answers on cards
  - Smooth card transitions
  - Visual answer selection

- **List View**
  - Expandable list format
  - Questions can be tapped to reveal
  - Compact information display
  - Easy navigation

### Answer System

- **Answer Selection**
  - Tap to select answer
  - Blue checkmark on selected answer
  - Visual feedback for selections
  - Multiple choice or true/false support

- **Scoring & Feedback**
  - Submit button to finish game
  - Correct answers marked in green
  - Incorrect answers marked in red
  - Final score calculation
  - Score display after submission

### Question Handling

- **HTML Entity Decoding**
  - Decodes HTML entities in questions
  - Handles special characters
  - Proper formatting display
  - Supports numeric entities

- **Answer Shuffling**
  - Answers shuffled once during initialization
  - Prevents re-shuffling on render
  - Consistent answer order
  - Correct answer mixed with incorrect

## Technical Architecture

### Models

- **TriviaQuestion**
  - Question text (HTML decoded)
  - Category, difficulty, type
  - Correct answer
  - Incorrect answers array
  - Shuffled answers (cached)
  - Unique ID (UUID)

- **TriviaResponse**
  - API response wrapper
  - Response code handling
  - Results array

### View Model

- **TriviaViewModel** (`ViewModel.swift`)
  - Manages game state
  - Handles API calls
  - Timer management
  - Score calculation
  - Answer selection tracking

### API Integration

- **TriviaAPI** (`Model.swift`)
  - Open Trivia DB integration
  - URL construction with query parameters
  - Response code handling:
    - 0: Success
    - 1: No Results
    - 2: Invalid Parameter
    - 3: Token Not Found
    - 4: Token Empty
  - Error handling and user feedback

### View Components

- **ContentView** - Options screen and game launcher
- **OptionsView** - Customization interface
- **GameView** - Main game interface
- **QuestionCardView** - Card view for questions
- **QuestionListRow** - List view for questions
- **AnswerRow** - Answer selection component

## Project Structure

```
TriviaApp/
├── ContentView.swift          # Main options screen
├── OptionsView.swift          # Game customization
├── GameView.swift             # Game interface
├── QuestionCardView.swift     # Card view component
├── QuestionListRow.swift      # List view component
├── AnswerRow.swift            # Answer selection
├── ViewModel.swift            # Game state management
├── Model.swift                # Data models and API
└── TriviaAppApp.swift        # App entry point
```

## Game Flow

1. **Setup Phase**
   - App launches to options screen
   - User selects number of questions (1-50)
   - Chooses category from 24 options
   - Sets difficulty (Any/Easy/Medium/Hard)
   - Selects question type (Multiple/True-False/Any)
   - Chooses timer duration
   - Selects view mode (Card/List)

2. **Game Start**
   - Tap "Start Trivia" button
   - Questions fetched from API
   - Timer starts (if enabled)
   - Questions displayed in selected view

3. **Playing**
   - User reads question
   - Selects answer (tap to choose)
   - Blue checkmark appears on selection
   - Can change answer before submission
   - Timer counts down (if enabled)

4. **Submission**
   - Tap submit button (or auto-submit on timer)
   - Answers evaluated
   - Correct answers turn green
   - Incorrect answers turn red
   - Final score displayed

## Categories Available

1. Any Category
2. General Knowledge
3. Entertainment: Books
4. Entertainment: Film
5. Entertainment: Music
6. Entertainment: Musicals & Theatres
7. Entertainment: Television
8. Entertainment: Video Games
9. Entertainment: Board Games
10. Science & Nature
11. Science: Computers
12. Science: Mathematics
13. Mythology
14. Sports
15. Geography
16. History
17. Politics
18. Art
19. Celebrities
20. Animals
21. Vehicles
22. Entertainment: Comics
23. Science: Gadgets
24. Entertainment: Japanese Anime & Manga
25. Entertainment: Cartoon & Animations

## Features Breakdown

### Required Features ✅

- [x] Options screen with customization
  - [x] Number of questions (1-50 stepper)
  - [x] Category selection (24 categories)
  - [x] Difficulty slider (Any/Easy/Medium/Hard)
  - [x] Question type (Multiple/True-False/Any)
- [x] Start Trivia button loads game
- [x] Questions in Card and List views
- [x] Answer selection with checkmark
- [x] Submit and score display

### Optional Features ✅

- [x] Answers marked correct (green) / incorrect (red)
- [x] Timer with customizable duration
- [x] Auto-submit on timer expiration
- [x] Timer display in game header

## Code Highlights

### HTML Entity Decoding

```swift
func htmlDecoded() -> String {
    // Handles &amp;, &#039;, &quot;, etc.
    // Supports numeric entities
    // Thread-safe decoding
}
```

### Timer Management

```swift
func startTimer() {
    timerTask = Task { @MainActor [weak self] in
        while self.timeRemaining > 0 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.timeRemaining -= 1
        }
        if self.timeRemaining <= 0 {
            self.hasSubmitted = true // Auto-submit
        }
    }
}
```

### Score Calculation

```swift
var score: Int {
    guard hasSubmitted else { return 0 }
    return questions.reduce(0) { acc, q in
        let selected = selections[q.id]
        return acc + ((selected == q.decodedCorrect()) ? 1 : 0)
    }
}
```

## Technologies Used

- **SwiftUI** - Modern declarative UI framework
- **Swift** - Programming language
- **Combine** - Reactive programming
- **Open Trivia DB API** - Question source
- **Async/Await** - Modern concurrency
- **URLSession** - Network requests

## API Integration

- **Endpoint**: `https://opentdb.com/api.php`
- **Parameters**:
  - `amount`: Number of questions (1-50)
  - `category`: Category ID (optional)
  - `difficulty`: easy/medium/hard (optional)
  - `type`: multiple/boolean (optional)
  - `encode`: Encoding format (optional)

## Error Handling

The app handles various API response codes:
- **0**: Success - questions returned
- **1**: No Results - not enough questions for criteria
- **2**: Invalid Parameter - bad request
- **3**: Token Not Found - session issue
- **4**: Token Empty - exhausted questions

User-friendly error messages displayed for all scenarios.

## Video Walkthrough

[View Demo Video](https://www.loom.com/share/1dde990988f941228c465ecc1514a848)

## Design Highlights

- **Color Scheme**
  - Blue header for branding
  - Green for correct answers
  - Red for incorrect answers
  - Blue checkmark for selections
  - Clean white backgrounds

- **User Experience**
  - Intuitive customization options
  - Clear visual feedback
  - Smooth transitions
  - Responsive layout
  - Accessible controls

## Challenges & Solutions

- **HTML Entities**: Implemented comprehensive decoding for special characters
- **Answer Shuffling**: Cached shuffled answers to prevent re-shuffling
- **Timer Management**: Used async/await for accurate countdown
- **State Management**: Proper @Published properties for reactive updates

## Future Enhancements

Potential improvements:
- High score tracking
- Question difficulty progression
- Multiplayer mode
- Question explanations
- Category statistics
- Save game progress
- Share results
- Daily challenges
- Achievement system
- Offline mode with cached questions

## Setup Instructions

1. Open `TriviaApp.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. Customize game options
4. Tap "Start Trivia" to begin
5. Answer questions and submit to see score

## Notes

- Requires internet connection for API calls
- Questions are fetched fresh each game
- Timer is optional and can be disabled
- Score is calculated after submission
- Answers can be changed before submitting

## License

Copyright 2025 Abhijeet Cherungottil

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
