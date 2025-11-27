# BeReal - Social Media App

**BeReal** is an iOS social media application inspired by the BeReal concept, where users post photos of what they're currently doing. The app enforces a unique social interaction model where users can only see their friends' posts after they've posted their own photo within a 24-hour window.

## Overview

This app implements a complete social media experience with user authentication, photo posting, comments, and location tracking. Built using UIKit and ParseSwift for backend services.

## Features

### Core Functionality

- **User Authentication**
  - User registration with email and password
  - Login/logout functionality
  - Persistent login using UserDefaults
  - User profile management

- **Post Management**
  - Upload photos from photo library or camera
  - Add optional captions to posts
  - Automatic location tracking and display
  - Timestamp display for each post
  - 24-hour posting restriction (users can only see posts from the last 24 hours)

- **Social Features**
  - Feed of posts from all users
  - Users cannot see other users' posts until they post their own
  - Post visibility is restricted until user uploads their photo
  - Comment system with user attribution
  - Comments display username and user information

- **User Interface**
  - Home feed with table view of posts
  - Post detail view for viewing and commenting
  - Sign up and login screens
  - Navigation between screens
  - Custom post table view cells

## Technical Architecture

### Models

- **User** (`User.swift`)
  - Extends `ParseUser` for authentication
  - Stores user credentials and profile information
  - Tracks `lastPostedDate` for posting restrictions

- **Post** (`Post.swift`)
  - Extends `ParseObject` for backend storage
  - Contains caption, user reference, image file, and location
  - Automatically tracks creation and update timestamps

- **Comment** (`Comment.swift`)
  - Extends `ParseObject`
  - Links comments to posts and users
  - Stores comment text and metadata

### Key Components

- **HomeViewController**
  - Displays feed of posts
  - Queries posts from last 24 hours
  - Handles navigation to post detail and new post screens
  - Implements logout functionality

- **DetailViewController**
  - Handles photo upload and post creation
  - Captures location data
  - Manages image selection from library or camera

- **PostCommentViewController**
  - Displays post details and comments
  - Allows users to add new comments
  - Shows comment history with user information

- **UserAuthenticator**
  - Manages user session persistence
  - Handles UserDefaults storage for user data
  - Provides helper methods for user data management

### Backend Integration

- Uses **ParseSwift** for backend services
- Cloud-based data storage for posts, users, and comments
- File storage for images
- Real-time querying and updates

## Project Structure

```
BeReal/
├── Models/
│   ├── User.swift          # User model with ParseUser
│   ├── Post.swift          # Post model with ParseObject
│   └── Comment.swift       # Comment model
├── ViewController/
│   ├── HomeViewController.swift      # Main feed view
│   ├── DetailViewController.swift    # Post creation view
│   ├── PostCommentViewController.swift  # Comment view
│   ├── SignUpViewController.swift    # Registration
│   └── PostTableViewCell.swift       # Custom cell
├── StoryBoard/             # Storyboard files
├── UserAuthenticator.swift # Session management
├── Constants.swift         # App constants
└── Date+Extension.swift    # Date utilities
```

## Setup Instructions

1. **Prerequisites**
   - Xcode 14.0 or later
   - iOS 13.0 or later
   - ParseSwift SDK configured

2. **Backend Configuration**
   - Set up Parse server backend
   - Configure Parse application ID and client key
   - Set up file storage for images

3. **Build and Run**
   - Open `BeReal.xcodeproj` in Xcode
   - Configure Parse credentials in app configuration
   - Build and run on simulator or device

## Features Breakdown

### Required Features ✅

- [x] App icon and styled launch screen
- [x] User registration and login
- [x] Feed of posts when logged in
- [x] Upload new posts with photo and optional caption
- [x] Logout functionality
- [x] Camera integration for photo capture
- [x] Post visibility restriction (must post to see others)
- [x] Comment system with user data
- [x] Time and location attached to posts
- [x] 24-hour posting window restriction

### Optional Features ✅

- [x] Location and time display in feed
- [x] Persistent login (user stays logged in)

## Technologies Used

- **Swift** - Programming language
- **UIKit** - User interface framework
- **ParseSwift** - Backend as a Service
- **Core Location** - Location services
- **UIKit Storyboards** - Interface design

## Video Walkthrough

[View Demo Video](https://www.loom.com/share/5251ac8a19334eaabb7c925ee6f297db)

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
