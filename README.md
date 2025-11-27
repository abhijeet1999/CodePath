# CodePath iOS Projects Collection

A collection of iOS applications built with Swift, showcasing various mobile development concepts and frameworks. Each project demonstrates different aspects of iOS development including UIKit, SwiftUI, API integration, backend services, and user interface design.

## Projects Overview

### 1. [BeReal](./BeReal/) - Social Media App
A social media application inspired by BeReal, featuring user authentication, photo posting, comments, and location tracking. Built with UIKit and ParseSwift backend.

**Key Features:**
- User registration and authentication
- Photo upload with location tracking
- Comment system
- 24-hour posting restriction
- Parse backend integration

**Technologies:** Swift, UIKit, ParseSwift, Core Location

---

### 2. [MemoryGame](./MemoryGame/) - Card Matching Game
An interactive memory matching game built with SwiftUI. Players flip cards to find matching pairs with multiple difficulty levels.

**Key Features:**
- Card flipping mechanics
- Multiple difficulty levels (3, 6, 10 pairs)
- Win detection and celebration
- Smooth animations
- Responsive grid layout

**Technologies:** Swift, SwiftUI

---

### 3. [MyProject](./MyProject/) - Student Profile App
A simple form-based application for creating student profiles with customizable information and interactive UI elements.

**Key Features:**
- Student information form
- Pet count stepper
- Year selection
- Introduction generator
- Background customization

**Technologies:** Swift, UIKit, Storyboards

---

### 4. [PhotoScavengersApp](./PhotoScavengersApp/) - Scavenger Hunt
A location-based scavenger hunt app where users complete tasks by taking photos at specific locations with automatic geotagging.

**Key Features:**
- Task management
- Photo attachment with location
- Map display
- Task completion tracking
- Custom task creation

**Technologies:** Swift, UIKit, Core Location, MapKit, PhotosUI

---

### 5. [TranslateApp](./TranslateApp/) - Translation App
A comprehensive translation application with multi-language support, text-to-speech, and cloud-synced translation history using Firebase.

**Key Features:**
- 8+ language support
- MyMemory API integration
- Text-to-speech in multiple languages
- Firebase Firestore history
- Offline cache support

**Technologies:** Swift, SwiftUI, Firebase Firestore, AVFoundation, MyMemory API

---

### 6. [TriviaApp](./TriviaApp/) - Trivia Game
An engaging trivia game that fetches questions from Open Trivia DB with extensive customization options, timer functionality, and multiple view modes.

**Key Features:**
- 24 question categories
- Customizable difficulty and question count
- Timer with auto-submit
- Card and list view modes
- Visual answer feedback
- Score calculation

**Technologies:** Swift, SwiftUI, Open Trivia DB API, Async/Await

---

## Project Statistics

| Project | Framework | Backend | API Integration | Special Features |
|---------|-----------|---------|-----------------|------------------|
| BeReal | UIKit | ParseSwift | - | Authentication, Comments |
| MemoryGame | SwiftUI | - | - | Animations, Game Logic |
| MyProject | UIKit | - | - | Form Handling |
| PhotoScavengersApp | UIKit | - | - | Location, Maps |
| TranslateApp | SwiftUI | Firebase | MyMemory | TTS, Cloud Sync |
| TriviaApp | SwiftUI | - | Open Trivia DB | Timer, Scoring |

## Technologies Used Across Projects

### UI Frameworks
- **UIKit** - Traditional iOS UI framework (BeReal, MyProject, PhotoScavengersApp)
- **SwiftUI** - Modern declarative UI (MemoryGame, TranslateApp, TriviaApp)

### Backend Services
- **ParseSwift** - Backend as a Service (BeReal)
- **Firebase Firestore** - Cloud database (TranslateApp)

### APIs & Services
- **MyMemory Translation API** - Translation service (TranslateApp)
- **Open Trivia DB** - Trivia questions (TriviaApp)

### iOS Frameworks
- **Core Location** - Location services (BeReal, PhotoScavengersApp)
- **MapKit** - Map display (PhotoScavengersApp)
- **AVFoundation** - Text-to-speech (TranslateApp)
- **PhotosUI** - Photo library access (PhotoScavengersApp)

## Getting Started

Each project has its own README with detailed setup instructions. Navigate to the project folder and follow the specific setup guide.

### General Requirements
- Xcode 14.0 or later
- iOS 13.0+ (varies by project)
- Swift 5.0+
- CocoaPods or Swift Package Manager (for dependencies)

### Common Setup Steps
1. Clone the repository
2. Navigate to the project folder
3. Open `.xcodeproj` file in Xcode
4. Install dependencies (if any)
5. Configure API keys/backend (if required)
6. Build and run

## Project Structure

```
CodePath/
├── BeReal/                 # Social media app
├── MemoryGame/            # Card matching game
├── MyProject/             # Student profile app
├── PhotoScavengersApp/    # Scavenger hunt app
├── TranslateApp/          # Translation app
└── TriviaApp/            # Trivia game
```

## Learning Outcomes

These projects demonstrate:
- **UIKit Development** - Storyboards, view controllers, table views
- **SwiftUI Development** - Declarative UI, state management, modern patterns
- **API Integration** - REST APIs, async/await, error handling
- **Backend Integration** - Parse, Firebase, cloud services
- **iOS Features** - Location services, camera, photo library, maps
- **User Interface Design** - Responsive layouts, animations, user experience
- **Data Management** - Models, persistence, cloud sync
- **Game Development** - Game logic, state management, scoring

## Author

**Abhijeet Cherungottil**

All projects are part of a learning journey in iOS development, showcasing various concepts and best practices.

## License

All projects are licensed under the Apache License, Version 2.0. See individual project README files for license details.

---

## Quick Links

- [BeReal Documentation](./BeReal/README.md)
- [MemoryGame Documentation](./MemoryGame/README.md)
- [MyProject Documentation](./MyProject/README.md)
- [PhotoScavengersApp Documentation](./PhotoScavengersApp/README.md)
- [TranslateApp Documentation](./TranslateApp/README.md)
- [TriviaApp Documentation](./TriviaApp/README.md)

