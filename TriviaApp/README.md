# Project 5 - Trivia Challenge

Submitted by: **Abhijeet Cherungottil**

**Trivia Challenge** is an engaging trivia game app that fetches questions from the Open Trivia DB API. Users can customize their game experience by selecting the number of questions, category, difficulty level, question type, and timer duration. The app features both card and list views for displaying questions, with visual feedback for correct and incorrect answers.

Time spent: **12** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] App launches to an Options screen where user can modify the types of questions presented when the game starts. Users can choose:
  - [x] Number of questions (Stepper from 1-50)
  - [x] Category of questions (24 categories including Sports, Film, Science, Geography, History, etc.)
  - [x] Difficulty of questions (Slider with Any, Easy, Medium, Hard)
  - [x] Type of questions (Multiple Choice or True/False)
- [x] User can tap "Start Trivia" button to load and start the trivia game
- [x] Questions are presented in both List and Card view options
  - Card view: Beautiful flashcard-style cards with question and answers
  - List view: Expandable list with questions that can be tapped to reveal answers
- [x] Selected choices are marked with a blue checkmark when user taps their choice
- [x] User can submit choices and is presented with a score at the end of the trivia game
 
The following **optional** features are implemented:

- [x] User has answers marked as correct (green) or incorrect (red) after submitting choices
- [x] Implemented a timer that provides time pressure on the user
  - Customizable timer duration: 1, 5, 15, 30 minutes, or 1 hour
  - Auto-submits choices after timer expires
  - Timer displayed in the game header



## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div>
    <a href="https://www.loom.com/share/1dde990988f941228c465ecc1514a848">
      <p>trivia - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/1dde990988f941228c465ecc1514a848">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/1dde990988f941228c465ecc1514a848-bf1156d34a4cf2ba-full-play.gif">
    </a>
  </div>

## Notes

**Challenges encountered while building the app:**

1. **SwiftUI Concurrency Issues**: Initially had AttributeGraph cycle errors when modifying `@Published` properties during view updates. Fixed by using computed properties and `Task { @MainActor in }` for async state updates.

2. **Answer Shuffling**: The app was re-shuffling answers on every view render, causing them to jump around. Fixed by caching shuffled answers during question initialization.

3. **HTML Entity Decoding**: The Open Trivia API returns HTML-encoded strings. Initially used `NSAttributedString` which crashed on background threads. Replaced with a custom thread-safe HTML decoder.

4. **Navigation**: Getting the proper navigation bar with back button while maintaining the full-screen game experience required careful use of `NavigationView` and toolbar modifiers.

5. **Timer Implementation**: Ensuring the timer runs on the MainActor and properly handles background app state was crucial for accurate timing.

## Architecture

The app follows a clean MVVM architecture:

- **Model.swift**: Contains `TriviaQuestion`, `TriviaResponse` models, HTML decoder extension, and API client
- **ViewModel.swift**: `TriviaViewModel` manages game state, questions, selections, timer, and scoring
- **ContentView.swift**: Main entry view with options configuration
- **OptionsView.swift**: Configuration settings component
- **GameView.swift**: Full-screen game interface
- **QuestionCardView.swift**: Card-style question display
- **QuestionListRow.swift**: List-style question display
- **AnswerRow.swift**: Reusable answer button component

## API Integration

The app integrates with the Open Trivia Database API:
- Base URL: `https://opentdb.com/api.php`
- Supports all categories, difficulty levels, and question types
- Handles error responses (no results, invalid parameters, etc.)
- Implements proper timeout and error handling

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

