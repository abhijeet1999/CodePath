# TranslationMe - Multi-Language Translation App

A comprehensive iOS translation application built with SwiftUI that translates text between multiple languages using the MyMemory API, includes text-to-speech functionality, and maintains a persistent translation history with Firebase Firestore.

## Overview

TranslationMe is a feature-rich translation app that provides real-time text translation between 8+ languages, voice synthesis for both original and translated text, and cloud-synced translation history. The app features a clean SwiftUI interface with offline support and real-time synchronization.

## Features

### Translation Engine

- **Multi-Language Support**
  - 8 supported languages: English, Spanish, French, German, Italian, Hindi, Chinese, Portuguese
  - Auto-detect source language option (UI only, defaults to English)
  - Language pair selection (From/To)
  - Real-time translation via MyMemory API

- **Translation Quality**
  - URL-encoded response handling
  - Multiple encoding level support
  - Match quality indicators
  - Error handling and user feedback

### Text-to-Speech

- **Voice Synthesis**
  - Speak original text in source language
  - Speak translated text in target language
  - Locale-aware voice selection
  - Stop/play controls for speech
  - Visual indicators for active speech

### Translation History

- **Cloud-Synced History**
  - Firebase Firestore integration
  - Real-time synchronization across devices
  - Offline cache support
  - Persistent storage
  - Timestamp tracking
  - Language pair labels (e.g., EN→ES)

- **History Management**
  - Scrollable history list
  - Context menu actions (copy, speak)
  - Clear all history button
  - Batch delete functionality
  - Automatic sorting by timestamp

### User Interface

- **Modern SwiftUI Design**
  - Clean, intuitive layout
  - Text editor for input
  - Language picker menus
  - Progress indicators during translation
  - Error alerts with descriptive messages
  - Responsive design

- **Interactive Elements**
  - Speaker buttons for TTS
  - Context menus on history items
  - Copy to clipboard functionality
  - Clear history with confirmation

## Technical Architecture

### Core Components

- **TranslationService** (`TranslationService.swift`)
  - Handles MyMemory API integration
  - URL encoding/decoding
  - Error handling and logging
  - Response parsing and validation

- **TranslationHistoryManager** (`TranslationHistoryManager.swift`)
  - Firebase Firestore integration
  - Real-time listener for updates
  - Offline cache management
  - Batch operations for clearing history

- **VoiceService** (`VoiceService.swift`)
  - AVSpeechSynthesizer integration
  - Language-to-voice mapping
  - Speech control (start/stop)
  - State management for active speech

- **ContentView** (`ContentView.swift`)
  - Main UI and state management
  - User interaction handling
  - Translation workflow orchestration

### Data Models

- **Translation**
  - Original text
  - Translated text
  - Source language code
  - Target language code
  - Timestamp
  - Document ID (Firestore)

### API Integration

- **MyMemory Translation API**
  - Public API endpoint
  - Language pair specification
  - URL-encoded responses
  - Rate limit awareness
  - Error response handling

- **Firebase Firestore**
  - Cloud database for history
  - Real-time listeners
  - Offline persistence
  - Batch operations

## Project Structure

```
TranslateApp/
├── ContentView.swift                  # Main UI
├── TranslationService.swift          # API integration
├── TranslationHistoryManager.swift   # Firebase integration
├── VoiceService.swift                 # Text-to-speech
├── Translation.swift                  # Data model
├── TranslateAppApp.swift              # App entry point
└── GoogleService-Info.plist          # Firebase config
```

## Supported Languages

| Code | Language |
|------|----------|
| en   | English |
| es   | Spanish |
| fr   | French |
| de   | German |
| it   | Italian |
| hi   | Hindi |
| zh   | Chinese |
| pt   | Portuguese |
| auto | Auto Detect (UI only) |

## User Flow

1. **Translate Text**
   - Enter text in input editor
   - Select source language (From)
   - Select target language (To)
   - Tap "Translate" button
   - View translated result

2. **Listen to Translation**
   - Tap speaker icon next to text
   - Text is spoken in appropriate language
   - Tap again to stop

3. **View History**
   - Scroll through translation history
   - See original and translated text
   - View timestamp and language pair
   - Use context menu for actions

4. **Manage History**
   - Long-press history item for context menu
   - Copy original or translation
   - Speak translation
   - Clear all history

## Features Breakdown

### Required Features ✅

- [x] Input editor and language pickers on launch
- [x] Translate text between languages
- [x] Display translated text clearly
- [x] Manage history with clear button

### Optional Features ✅

- [x] Multiple languages (8 languages)
- [x] Real-time Firestore sync with offline cache
- [x] Text-to-speech for both languages
- [x] Enhanced UI with context menus
- [x] Copy functionality
- [x] Error handling with alerts

### Additional Features ✅

- [x] Error alerts on failed translations
- [x] Input validation and progress feedback
- [x] Timestamp and language pair labels
- [x] Safe defaults for source language
- [x] Comprehensive logging for debugging

## Code Highlights

### Translation Service

```swift
func translate(text: String, from source: String, to target: String) async throws -> String {
    // Builds URL with language pair
    // Makes async network request
    // Decodes URL-encoded response
    // Returns translated text
}
```

### Firebase History Manager

```swift
func saveTranslation(_ translation: Translation) {
    // Saves to Firestore
    // Real-time listener updates UI
    // Offline cache support
}
```

### Text-to-Speech

```swift
func speak(_ text: String, language: String) {
    // Maps language to locale
    // Uses AVSpeechSynthesizer
    // Handles voice selection
}
```

## Technologies Used

- **SwiftUI** - Modern declarative UI framework
- **Swift** - Programming language
- **MyMemory API** - Translation service
- **Firebase Firestore** - Cloud database
- **AVFoundation** - Text-to-speech
- **Combine** - Reactive programming

## Setup Instructions

### Prerequisites

1. Xcode 14.0 or later
2. iOS 15.0 or later
3. Firebase account and project

### Configuration Steps

1. **Firebase Setup**
   - Create Firebase project
   - Add iOS app to project
   - Download `GoogleService-Info.plist`
   - Place in `TranslateApp/` directory
   - Enable Firestore Database
   - Configure security rules (for development):
     ```
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /{document=**} {
           allow read, write: if true;
         }
       }
     }
     ```

2. **Build and Run**
   - Open `TranslateApp.xcodeproj`
   - Ensure `GoogleService-Info.plist` is included
   - Build and run on simulator or device

### Security Note

For production, update Firestore security rules to restrict access appropriately. The current setup allows open access for development purposes.

## API Limitations

- **MyMemory API**: Free tier has rate limits
- Consider API key for production use
- Handle quota exhaustion gracefully

## Error Handling

The app includes comprehensive error handling:
- Network errors
- API failures
- Decoding errors
- Firebase permission errors
- User-friendly error messages

## Video Walkthrough

[View Demo Video](https://www.loom.com/share/edf4b466d15d4f8ab2a8986386fbbeec)

## Challenges & Solutions

- **URL Encoding**: Implemented multi-level decoding for MyMemory responses
- **Firestore Permissions**: Added error detection and user guidance
- **Voice Mapping**: Created locale-aware voice selection
- **Offline Support**: Configured Firestore offline persistence

## Future Enhancements

Potential improvements:
- Additional language support
- Translation favorites/bookmarks
- Share translations
- Translation quality scoring
- Batch translation
- Offline translation models
- Translation suggestions
- History search and filtering

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
