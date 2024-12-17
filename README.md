# RuckingApp680

A SwiftUI app for tracking rucking workouts - combining hiking with weighted gear for an enhanced fitness experience.

## Features

### Workout Tracking
- Log workouts with distance, duration, and gear
- Choose from preset routes or enter custom distances
- Track time with an intuitive HH:MM:SS picker
- View workout history with detailed statistics

### Gear Management
- Organize gear by category (Backpack, Vest, Sandbag, Stone)
- Track weight for each piece of equipment
- Calculate total load for each workout
- Easy gear selection during workout creation

### Route System
- Quick selection of routes for new workouts
- Support for custom distance entries

### Workout Analytics
- Calculate pace per mile
- Track calories burned
- Monitor total weight carried
- View detailed workout summaries

## Technical Details

Built using:
- SwiftUI
- MVVM Architecture
- Environment Objects for state management
- Custom UI components for enhanced user experience

## Data Structure

The app uses three main models:
- `Workout`: Tracks individual workout sessions
- `GearItem`: Manages equipment inventory
- `Route`: Stores predefined routes

## State Management

Uses three main stores:
- `WorkoutStore`: Manages workout history
- `GearStore`: Handles gear inventory
- `RouteStore`: Maintains route collection

## UI Components

Features custom components like:
- Route cards with horizontal scrolling
- Time picker with wheel-style input
- Categorized gear selection
- Detailed workout history view

## Getting Started

1. Clone the repository
2. Open in Xcode
3. Build and run on iOS 15.0 or later