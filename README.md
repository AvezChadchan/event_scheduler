# Event Scheduler

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-2.x-blue?logo=dart)
![SQLite](https://img.shields.io/badge/Database-SQLite-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)

A Flutter-based mobile application for creating, managing, and tracking events with support for group-based events. The app provides an intuitive interface for admins to organize events, add participants, and monitor attendance using a local SQLite database.

## Features

- **Event Creation**: Add events with details like title, description, date, time, organizer, location, and group-based status.
- **Group-Based Events**: Support for organizing events with participant groups for better management.
- **Admin Dashboard**: View all events in a grid layout with customizable event cards.
- **Participant Management**: Add and manage participants for events, including group assignments.
- **Attendance Tracking**: Record and view attendance for events.
- **Local Storage**: Uses SQLite for persistent data storage, ensuring offline functionality.
- **Responsive UI**: Modern, user-friendly interface with a dark theme using custom widgets.

## Screenshots

*Coming soon!*

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 3.x or higher)
- [Dart](https://dart.dev/get-dart) (version 2.x or higher)
- Android Studio or VS Code with Flutter extensions
- An Android/iOS emulator or physical device

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/AvezChadchan/event_scheduler.git
   cd event_scheduler
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

   Ensure an emulator or device is connected. The app will automatically set up the SQLite database on first run.

### Database Setup

The app uses SQLite for local storage, managed via the `sqflite` package. The database (`event_schedule.db`) is created automatically when the app starts, with tables for events, participants, and attendance.

- **Schema**: Defined in `lib/data/local/db_helper.dart`.
- **Version**: 2 (includes `is_group_based` column for events).

To reset the database, delete the app’s data on the device/emulator or change the database name in `DBHelper`.

## Usage

1. **Create an Event**:
    - Navigate to the "Add Event" screen via the `+` button on the dashboard.
    - Fill in event details (title, date, time, etc.) and toggle "Group-Based Event" if needed.
    - Save the event to store it in the SQLite database.

2. **View Events**:
    - The dashboard displays all events in a grid of `EventCard` widgets.
    - Tap an event to view details or manage participants/attendance.

3. **Manage Participants**:
    - For group-based events, assign participants to groups when adding them.
    - View participants and attendance records via the event details screen.

## Project Structure

```
event_scheduler/
├── lib/
│   ├── components/           # Custom widgets (InputField, NeonButton, EventCard)
│   ├── data/
│   │   ├── local/            # Database helper (DBHelper)
│   ├── models/               # Data models (EventModel, ParticipantModel)
│   ├── screens/              # UI screens (EventCreate, AdminDashboard, EventDetail)
│   ├── widgets/              # Reusable widgets
├── pubspec.yaml              # Dependencies and app configuration
├── README.md                 # Project documentation
```

## Dependencies

- `flutter`: SDK for building the app