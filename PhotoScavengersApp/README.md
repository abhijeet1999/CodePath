# Photo Scavenger Hunt App

An iOS application that turns everyday locations into a scavenger hunt adventure. Users complete tasks by taking photos at specific locations, with automatic location tracking and task management.

## Overview

Photo Scavenger Hunt App allows users to create and complete location-based photo tasks. Each task requires users to take a photo at a specific location, which is automatically geotagged. The app displays completed tasks with checkmarks and allows users to view task details including the photo location on a map.

## Features

### Task Management

- **Task List**
  - Display list of scavenger hunt tasks
  - Visual indicators for completed tasks (green checkmark)
  - Incomplete tasks shown with red circle
  - Task titles displayed in table view

- **Task Details**
  - View task description
  - See attached photo (if completed)
  - View location on map
  - Mark task as complete by adding photo

- **Add New Tasks**
  - Create custom scavenger hunt tasks
  - Set task title and description
  - Tasks added to main list

### Photo & Location Features

- **Photo Capture**
  - Attach photos from photo library
  - Photo selection interface
  - Photos stored with task data

- **Location Tracking**
  - Automatic location capture when photo is added
  - Location coordinates stored with task
  - Map display showing photo location
  - Uses Core Location framework

- **Task Completion**
  - Tasks marked complete when photo is added
  - Visual feedback with checkmark icon
  - Status persists across app sessions

## Technical Architecture

### Models

- **Task** (`Task.swift`)
  - `title`: Task name/description
  - `description`: Detailed task description
  - `isComplete`: Boolean completion status
  - `image`: UIImage for attached photo
  - `coordinate`: CLLocation for geotagging

### View Controllers

- **ViewController** (Main List)
  - Displays table view of all tasks
  - Handles task selection and navigation
  - Manages task data array
  - Reloads data when returning from detail view

- **DetailViewController**
  - Shows task details
  - Handles photo selection and attachment
  - Captures location data
  - Updates task completion status
  - Displays map with location

- **NewTaskViewController**
  - Creates new tasks
  - Input fields for title and description
  - Callback to add task to main list

### Data Management

- **In-Memory Storage**
  - Tasks stored in array
  - Default hard-coded tasks on app launch
  - Tasks persist during app session

- **Task Updates**
  - Callback pattern for saving task changes
  - Table view updates when task is modified
  - Real-time status updates

## Project Structure

```
PhotoScavengersApp/
├── ViewController.swift          # Main task list
├── DetailViewController.swift     # Task detail and photo
├── NewTaskViewController.swift    # Create new task
├── TaskTableViewCell.swift        # Custom table cell
├── Task.swift                     # Task data model
├── Main.storyboard                # Main interface
├── DetailView.storyboard          # Detail view
└── NewTask.storyboard             # New task view
```

## User Flow

1. **View Tasks**
   - App launches showing list of tasks
   - Tasks display with completion status
   - Green checkmark = complete, red circle = incomplete

2. **Complete a Task**
   - Tap task to view details
   - Add photo from library
   - Location automatically captured
   - Task marked as complete
   - Return to list to see updated status

3. **Create New Task**
   - Tap "+" button in navigation bar
   - Enter task title and description
   - Task added to list
   - Can be completed like other tasks

4. **View Task Details**
   - Tap any task in list
   - See description and photo (if completed)
   - View location on map
   - Edit or complete task

## Features Breakdown

### Required Features ✅

- [x] Display list of hard-coded tasks
- [x] Navigate to task detail view on tap
- [x] Add photo to complete task
- [x] Automatic location capture with photo
- [x] Task status updates in main list

### Optional Features

- [ ] Camera integration for direct photo capture

### Additional Features ✅

- [x] Add new custom tasks
- [x] Task completion visual indicators
- [x] Location display on map

## Code Highlights

### Task Model

```swift
struct Task {
    var title: String
    var description: String
    var isComplete: Bool = false
    var image: UIImage = UIImage()
    var coordinate: CLLocation = CLLocation()
}
```

### Task Completion Callback

```swift
detailVC.onSave = { [weak self] updatedItem in
    self?.data[indexPath.row] = updatedItem
    self?.scavengerTableView.reloadRows(at: [indexPath], with: .automatic)
}
```

## Technologies Used

- **Swift** - Programming language
- **UIKit** - iOS user interface framework
- **Core Location** - Location services
- **MapKit** - Map display
- **PhotosUI** - Photo library access
- **Storyboards** - Interface design

## Default Tasks

The app includes these default tasks:
- "Test 1" - Where do you want to go to be one with nature?
- "Test 2" - Where do you want to go to be one with nature?
- "Test 3" - Where do you want to go to be one with nature?
- "Test 4" - Where do you want to go to be one with nature?

## Permissions Required

- **Photo Library Access**: To select photos for tasks
- **Location Services**: To capture location when photo is added
- **Camera Access** (optional): For direct photo capture

## Video Walkthrough

[View Demo Video](https://www.loom.com/share/abac94908c8f4ffe80d3e405868745d5)

## Use Cases

- Educational field trips
- Team building activities
- Location-based learning
- Adventure games
- Tourism exploration
- Social media challenges

## Future Enhancements

Potential improvements:
- Persistent storage (Core Data or UserDefaults)
- Share tasks with friends
- Task categories and tags
- Photo filters and editing
- Progress tracking and statistics
- Cloud sync for tasks
- Social features and leaderboards
- Custom task templates
- Reminder notifications

## Setup Instructions

1. Open `PhotoScavengersApp.xcodeproj` in Xcode
2. Configure location permissions in Info.plist
3. Configure photo library permissions
4. Build and run on device (location features require physical device)
5. Grant necessary permissions when prompted

## Notes

- Location features work best on physical devices
- Simulator may have limited location functionality
- Photo library access requires user permission
- Tasks are stored in memory and reset on app restart (unless persistence is added)

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
