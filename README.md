# Mystery Link Game

A Flutter game that challenges players to connect two elements (A → Z) through a chain of intermediate links (1-10 links).

## Features

- **Solo Mode**: Play alone and challenge yourself
- **Group Mode**: Play with friends (2-6 players) in local pass & play mode
- **Practice Mode**: Learn and practice with easy puzzles
- **Guided Mode**: Get hints and guidance while playing
- **Daily Challenges**: New puzzle every day
- **Multiple Representation Types**: Text, Icon, Image, and Event
- **Difficulty Levels**: 1-10 links per puzzle
- **30+ Puzzles**: Diverse puzzles across multiple categories
- **Scoring System**: Points based on correctness, difficulty, and speed
- **Progression System**: Level up, earn XP, unlock achievements
- **Bilingual Support**: Arabic and English with full RTL support
- **Beautiful UI**: Modern Material Design 3 with smooth animations
- **Splash Screen**: Elegant app launch experience

## Project Structure

```
lib/
  main.dart
  core/
    constants/      # App and game constants
    router/         # Navigation routing
    theme/          # App theme and colors
    utils/          # Utility functions and extensions
  features/
    home/           # Home screen
    mode_selection/ # Mode selection screen
    game/           # Game logic and UI
      data/         # Data models, repositories, datasources
      domain/       # Business logic entities
      presentation/ # UI (screens, widgets, BLoC)
    result/         # Result screen
  shared/
    widgets/        # Shared widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate JSON serialization code (if needed):
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Validating Puzzle Coverage

Before shipping new content, validate that every theme has puzzles for all four representation types (rules defined in `tool/puzzle_requirements.json`):

```bash
dart run tool/puzzle_validator.dart
```

The report highlights missing categories, representation gaps, and image-less puzzles.

## Architecture

The project follows **Clean Architecture** principles:

- **Data Layer**: Models, repositories, and datasources
- **Domain Layer**: Business logic entities and repository interfaces
- **Presentation Layer**: UI components, BLoC for state management

### State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:
- `GameBloc`: Manages game state for solo mode
- `GroupGameBloc`: Manages game state for group mode

## Game Mechanics

1. **Puzzle Selection**: Choose representation type and difficulty (1-10 links)
2. **Gameplay**: Select the correct intermediate link at each step
3. **Scoring**: 
   - Base points per step: 100
   - Multiplier based on difficulty (links count)
   - Time bonus for quick answers
4. **Time Limit**: Configurable per puzzle (default: 12 seconds per step)

## Data

Puzzles are stored in `assets/data/puzzles.json` with the following structure:
- **30 puzzles** covering various categories:
  - General Knowledge
  - Science & Technology
  - Nature & Environment
  - History & Culture
  - Mathematics
  - Biology & Life Sciences
  - Geography & Earth Sciences
  - Physics, Chemistry, Astronomy
  - Technology & Computing
  - Medicine & Health
  - And more...
- Each puzzle has a start node (A) and end node (Z)
- Multiple steps with options (one correct, multiple distractors)
- Support for multiple languages and representation types
- Difficulty ranges from 1 to 10 links

## Testing

See [docs/TESTING_GUIDE.md](docs/TESTING_GUIDE.md) for comprehensive testing guidelines.

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/game/presentation/bloc/game_bloc_test.dart
```

## Building and Deployment

See [docs/BUILD_GUIDE.md](docs/BUILD_GUIDE.md) for detailed build and deployment instructions.

### Quick Build Commands

```bash
# Windows Release
flutter build windows --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## Documentation

- [Testing Guide](docs/TESTING_GUIDE.md) - Comprehensive testing procedures
- [Build Guide](docs/BUILD_GUIDE.md) - Building and deployment instructions
- [Innovation Roadmap](INNOVATION_ROADMAP_2025_2035.md) - Future features and enhancements
- [Priority Implementation Guide](PRIORITY_IMPLEMENTATION_GUIDE.md) - Implementation priorities
- [Use Cases and Examples](USE_CASES_AND_EXAMPLES.md) - Real-world usage scenarios

## Future Enhancements

See [INNOVATION_ROADMAP_2025_2035.md](INNOVATION_ROADMAP_2025_2035.md) for comprehensive future plans including:

- **AI-Powered Features**: Adaptive learning, AI puzzle generation, thinking assistant
- **Multisensory Learning**: AR mode, audio mode, haptic feedback
- **Advanced Reasoning**: Multi-step reasoning, pattern recognition, critical thinking
- **Social Learning**: Collaborative building, cognitive challenges, creator community
- **Educational Integration**: Curriculum mode, classroom mode, real-world problems
- **Emerging Technologies**: VR mode, blockchain integration, IoT connectivity

Current roadmap focuses on:
- ✅ 30+ diverse puzzles
- ✅ Enhanced UX with helpful messages
- ✅ Splash screen
- ✅ Automated tests
- 🔄 Adaptive learning system (Phase 1 - 2025)
- 🔄 Thinking assistant (Phase 1 - 2025)
- 🔄 Multi-step reasoning (Phase 1 - 2025)

## License

This project is licensed under the MIT License.

