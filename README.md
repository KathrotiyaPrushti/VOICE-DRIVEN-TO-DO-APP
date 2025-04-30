# Voice-Driven To-Do List App

A Flutter-based voice-driven to-do list application that allows users to manage their tasks entirely through voice commands, with local storage support.

## Features

- Voice-driven task management
- Local storage with Hive
- Natural language understanding for commands
- Audible confirmations and prompts
- Clean, conversational UI

## Setup Instructions

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Initialize Hive:
   ```bash
   flutter pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Voice Commands

The app supports the following voice commands:

- "Add [task description]" - Creates a new task
- "Complete [task description]" - Marks a task as completed
- "Delete [task description]" - Deletes a task

## Local Storage

The app uses Hive for local storage, ensuring your tasks are saved even when the app is closed. Tasks are stored locally on your device.

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
