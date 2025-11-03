# Project 4 - *TranslationMe*

Submitted by: **Abhijeet Cherungottil**

**TranslationMe** is a SwiftUI iOS app that translates text between languages using the MyMemory API, speaks text aloud with AVSpeechSynthesizer, and syncs a persistent translation history via Firebase Firestore.

Time spent: **8 hours** in total

---

## Required Features

The following **required** functionality is completed:

- [x] App loads to show an input editor, language pickers, and a result area:
  - Upon launch, users see text input, From/To language selectors, and a placeholder for translated text.
- [x] Users can translate text between languages via a button:
  - Tapping “Translate” calls the MyMemory API and shows a progress indicator until completion.
- [x] Translated text is displayed clearly once available:
  - The result section shows the translated text, ready for copying or speaking.
- [x] User can manage history via a button:
  - A “Clear” button deletes all saved translations from Firestore.

---

## Optional Features

The following **optional** features are implemented:

- [x] Multiple languages supported (EN, ES, FR, DE, IT, HI, ZH, PT) with UI “Auto Detect”.
- [x] Real-time history syncing with Firestore and offline cache for resilience.
- [x] Text-to-speech for both original and translated text with locale-aware voices.
- [x] Enhanced UI:
  - Context menu on history rows to copy original/translation or speak the translation.
  - Clear button to batch-delete history.
  - Responsive layout and clean presentation.

---

## Additional Features

- [x] Error alerts on failed translations with descriptive messages.
- [x] Input validation, progress feedback, and safe defaults for source language.
- [x] Timestamp and language pair label (e.g., EN→ES) on history items.

---

## Video Walkthrough
<div>
    <a href="https://www.loom.com/share/edf4b466d15d4f8ab2a8986386fbbeec">
      <p>final - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/edf4b466d15d4f8ab2a8986386fbbeec">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/edf4b466d15d4f8ab2a8986386fbbeec-7b4de3d2181808a7-full-play.gif">
    </a>
  </div>


---

## Notes

Some challenges I faced while building the app:
- Handling Firestore permissions and ensuring offline cache behaves predictably.
- Dealing with URL-encoded responses and partial matches from the MyMemory API.
- Mapping language codes to device TTS voices across locales.

To ignore the Firebase config from git and stop tracking it:
- Add this line to `.gitignore`: `TranslateApp/GoogleService-Info.plist`
- Then run:
```
git rm --cached TranslateApp/GoogleService-Info.plist
git add .gitignore
git commit -m "Ignore GoogleService-Info.plist and stop tracking it"
```

To run Firebase features, add your own `GoogleService-Info.plist` inside `TranslateApp/`.

---

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
