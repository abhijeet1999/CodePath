# Student Profile App

A simple iOS application that allows users to create and display a personalized student profile with customizable information and interactive UI elements.

## Overview

This app provides a straightforward interface for students to enter their personal information, customize their profile, and generate an introduction. Built with UIKit and Storyboards, it demonstrates basic iOS form handling and user interaction patterns.

## Features

### Profile Information

- **Personal Details**
  - First name text field
  - Last name text field
  - School name text field
  - Year of study selection (segmented control)

- **Pet Information**
  - Number of pets stepper control
  - Display label showing current pet count
  - Switch to indicate desire for more pets

- **Additional Options**
  - Optional comment field (toggleable)
  - Background color customization
  - Introduction generation

### Interactive Elements

- **Segmented Control**
  - Selects student year (First, Second, Third, Fourth, etc.)
  - Updates dynamically in introduction

- **Stepper Control**
  - Increments/decrements number of pets
  - Updates label in real-time

- **Switches**
  - "More Pets" switch: indicates if user wants more pets
  - "Add Comment" switch: shows/hides comment text field
  - "Background Color" switch: toggles background between white and yellow

- **Introduction Button**
  - Generates personalized introduction
  - Displays alert with formatted introduction text
  - Includes all user-entered information

## Technical Architecture

### View Controller

- **ViewController** (`ViewController.swift`)
  - Manages all UI outlets and actions
  - Handles user input and interactions
  - Generates and displays introduction alert

### UI Components

- **Text Fields**
  - `firstNameTextField`: First name input
  - `lastNameTextField`: Last name input
  - `schoolTextField`: School name input

- **Controls**
  - `yearSegmentControl`: Year selection
  - `petsStepper`: Pet count adjustment
  - `morePetsSwitch`: More pets preference
  - `isCommentSwitch`: Comment field toggle
  - `backgroundChangeColorButton`: Background color toggle

- **Labels**
  - `noOfPetsLabel`: Displays current pet count
  - `commentLabel`: Comment field label (hidden by default)

- **Views**
  - `backgroundview`: Main background view for color changes

## Project Structure

```
MyProject/
├── ViewController.swift    # Main view controller
├── Main.storyboard         # Interface layout
├── Assets.xcassets/        # Images and colors
│   └── MaristLogo.imageset/ # School logo
└── Base.lproj/
    └── LaunchScreen.storyboard
```

## User Flow

1. **Enter Information**
   - User fills in first name, last name, and school name
   - Selects year of study from segmented control
   - Adjusts number of pets using stepper
   - Toggles switches for preferences

2. **Customize Interface**
   - Optionally enable comment field
   - Toggle background color
   - Add optional comment text

3. **Generate Introduction**
   - Tap "Introduce Yourself" button
   - Alert displays formatted introduction
   - Introduction includes all entered information

## Introduction Format

The generated introduction follows this format:

```
My name is [FirstName] [LastName] and I attend [SchoolName].
I am currently in my [Year] year and I own [PetCount] dogs.
It is [true/false] that I want more pets.
[Optional: Comment added : [CommentText]]
```

## Features Breakdown

### Required Features ✅

- [x] Display school logo image
- [x] Three text fields (first name, last name, school name)
- [x] Segmented control for student year
- [x] Pet count label updated by stepper
- [x] Switch for more pets preference (true/false)
- [x] "Introduce Yourself" button with alert

### Optional Features ✅

- [x] Background color change button (yellow/white toggle)
- [x] Additional comment field (toggleable)
- [x] Stylistic enhancements beyond defaults

## Code Highlights

### Introduction Generation

```swift
@IBAction func introduceYourselfTapped(_ sender: UIButton) {
    let year = yearSegmentControl.titleForSegment(at: yearSegmentControl.selectedSegmentIndex)
    var introduction = "My name is \(firstNameTextField.text!) \(lastNameTextField.text!) and I attend \(schoolTextField.text!).I am currently in my \(year!) year and I own \(noOfPetsLabel.text!) dogs.It is \(morePetsSwitch.isOn) that I want more pets."
    
    if(isCommentSwitch.isOn) {
        introduction = introduction + "\n Comment added : \(commentTextField.text ?? "")"
    }
    
    let alertController = UIAlertController(title: "My Introduction", message: introduction, preferredStyle: .alert)
    let action = UIAlertAction(title: "Nice to meet you!", style: .default, handler: nil)
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
}
```

### Dynamic UI Updates

- Stepper updates label value in real-time
- Switches show/hide UI elements dynamically
- Background color changes instantly

## Technologies Used

- **Swift** - Programming language
- **UIKit** - iOS user interface framework
- **Storyboards** - Visual interface design
- **Interface Builder** - UI layout tool

## Design Elements

- **School Logo**: Marist logo displayed at top
- **Color Scheme**: Clean white background with yellow accent option
- **Layout**: Vertical stack of form elements
- **Typography**: System fonts for readability

## Use Cases

- Student orientation applications
- Profile creation forms
- Introduction generators
- Educational app templates

## Video Walkthrough

![App Walkthrough](video.gif)

## Setup Instructions

1. Open `MyProject.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. Fill in the form fields
4. Customize options as desired
5. Tap "Introduce Yourself" to see the result

## Future Enhancements

Potential improvements:
- Save profile to UserDefaults
- Multiple profile support
- Profile photo upload
- Export introduction as text
- Share functionality
- Data validation

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
