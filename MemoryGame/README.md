# Project 4 - *Memory Match Game*

Submitted by: **Abhijeet Cherungottil**

**Memory Match Game** is a fun and interactive card-flipping puzzle game built using **SwiftUI**. The player’s goal is to find all matching pairs by remembering the positions of flipped cards. The game tests short-term memory and focus, offering multiple difficulty levels to keep users engaged.

Time spent: **8 hours** in total

---

## Required Features

The following **required** functionality is completed:

- [x] App loads to display a grid of cards initially placed face-down:
  - Upon launching the app, a grid of cards appears, all facedown.
- [x] Users can tap cards to toggle their display between the back and the face: 
  - Tapping a card flips it to reveal the front image.
  - If the second card doesn’t match, both flip back down after a short delay.
- [x] When two matching cards are found, they both disappear from view:
  - Matching pairs are removed from the grid.
- [x] User can reset the game and start a new game via a button:
  - A “Reset Game” button shuffles the cards and restarts the game.

---

## Optional Features

The following **optional** features are implemented:

- [x] User can select number of pairs to play with (3 pairs, 6 pairs, or 10 pairs).
- [x] Game layout adjusts dynamically for larger grids and includes scrolling when needed.
- [x] Enhanced UI:
  - Orange “Choose Size” button and green “Reset Game” button for clear interaction.
  - Smooth flipping animations.
  - Light background with clean card design for better visibility.

---

## Additional Features

- [x] Display alert when the game is completed (“Congratulations! You’ve matched all pairs 🎉”).
- [x] Game automatically detects win condition.
- [x] Simple and adaptive grid layout using `LazyVGrid` for responsiveness.

---

## Video Walkthrough
<div>
    <a href="https://www.loom.com/share/59769035a6cd474784032a4e36de4a95">
      <p>Loom | Free Screen & Video Recording Software | Loom - 19 October 2025 - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/59769035a6cd474784032a4e36de4a95">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/59769035a6cd474784032a4e36de4a95-b7f2ec5a3fe36b86-full-play.gif">
    </a>
  </div>


---

## Notes

Some challenges I faced while building the app:
- Handling state updates correctly so that unmatched cards flip back smoothly.
- Managing animations and delays to ensure cards don’t flip too quickly.
- Maintaining a clean layout for different grid sizes.

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
