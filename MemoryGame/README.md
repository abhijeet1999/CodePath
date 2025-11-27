# Memory Match Game

A fun and interactive card-flipping memory game built with **SwiftUI**. Test your memory skills by matching pairs of cards in this beautifully designed puzzle game.

## Overview

Memory Match Game challenges players to find matching pairs of cards by remembering their positions. The game features multiple difficulty levels, smooth animations, and an intuitive user interface built entirely with SwiftUI.

## Features

### Core Gameplay

- **Card Flipping Mechanics**
  - Tap cards to flip them and reveal their content
  - Cards automatically flip back if no match is found
  - Matching pairs disappear from the grid
  - Smooth flip animations

- **Difficulty Levels**
  - Choose from 3, 6, or 10 pairs of cards
  - Dynamic grid layout that adjusts to game size
  - Scrollable view for larger grids

- **Game Controls**
  - "Choose Size" button to select difficulty
  - "Reset Game" button to start a new game
  - Automatic card shuffling on reset

- **Win Detection**
  - Automatic detection when all pairs are matched
  - Celebration alert when game is completed
  - Option to play again after winning

## Technical Architecture

### Models

- **Card** (`Card.swift`)
  - `id`: Unique identifier (UUID)
  - `content`: Emoji or symbol displayed on card
  - `isFaceUp`: Boolean indicating if card is flipped
  - `isMatched`: Boolean indicating if card is part of a matched pair

### Game Logic

- **State Management**
  - Uses `@State` for game state
  - Tracks first flipped card index
  - Manages card array and game configuration

- **Card Matching Algorithm**
  - Tracks first flipped card
  - Compares second card with first
  - Removes matched pairs or flips unmatched cards back
  - Checks for win condition after each match

- **Card Generation**
  - Uses emoji set for card content
  - Creates pairs by duplicating selected emojis
  - Shuffles cards randomly for each game

### User Interface

- **SwiftUI Components**
  - `LazyVGrid` for responsive card grid layout
  - `ScrollView` for larger game sizes
  - `CardView` for individual card rendering
  - Gradient background for visual appeal

- **Interactive Elements**
  - Tap gestures on cards for flipping
  - Confirmation dialog for size selection
  - Alert for win notification

## Project Structure

```
MemoryGame/
├── ContentView.swift       # Main game view and logic
├── CardView.swift          # Individual card component
├── MemoryGameApp.swift     # App entry point
└── Model/
    └── Card.swift          # Card data model
```

## Game Flow

1. **Game Start**
   - App loads with default 3 pairs
   - Cards are shuffled and displayed face-down

2. **Playing**
   - User taps first card → flips to reveal content
   - User taps second card → flips to reveal content
   - If match: both cards disappear
   - If no match: both cards flip back after 1 second

3. **Win Condition**
   - When all pairs are matched
   - Alert appears: "🎉 You Won!"
   - Option to play again

4. **Reset**
   - Shuffles cards
   - Resets all game state
   - Starts fresh game

## Features Breakdown

### Required Features ✅

- [x] Grid of face-down cards on app launch
- [x] Tap to flip cards between back and face
- [x] Unmatched cards flip back after delay
- [x] Matched pairs disappear from view
- [x] Reset button to start new game

### Optional Features ✅

- [x] Selectable number of pairs (3, 6, or 10)
- [x] Dynamic layout adjustment for different grid sizes
- [x] Scrolling support for larger grids
- [x] Enhanced UI with color-coded buttons
- [x] Smooth flip animations
- [x] Win detection and celebration alert

## Design Highlights

- **Color Scheme**
  - Orange "Choose Size" button
  - Green "Reset Game" button
  - Gradient background (blue to purple)
  - Clean card design with good contrast

- **User Experience**
  - Intuitive tap-to-flip interaction
  - Visual feedback for all actions
  - Clear game state indicators
  - Responsive layout for all screen sizes

## Technologies Used

- **SwiftUI** - Modern declarative UI framework
- **Swift** - Programming language
- **Combine** - Reactive programming (via SwiftUI)

## Code Highlights

### Card Matching Logic

```swift
func flipCard(_ card: Card) {
    // Tracks first flipped card
    // Compares with second card
    // Handles match/no-match scenarios
    // Checks for win condition
}
```

### Dynamic Grid Layout

```swift
LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10)
```

## Video Walkthrough

[View Demo Video](https://www.loom.com/share/59769035a6cd474784032a4e36de4a95)

## Challenges & Solutions

- **State Management**: Used `@State` and proper SwiftUI state management to handle card flips and game state
- **Animation Timing**: Implemented delays to ensure smooth card flip-back animations
- **Layout Responsiveness**: Used `LazyVGrid` with flexible columns for adaptive layouts

## Future Enhancements

Potential improvements:
- Score tracking and high scores
- Timer for speed challenges
- Different card themes (animals, shapes, colors)
- Multiplayer mode
- Difficulty progression system

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
