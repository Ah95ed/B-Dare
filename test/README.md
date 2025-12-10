# Test Suite for Mystery Link

This directory contains automated tests for the Mystery Link game.

## Test Structure

```
test/
├── features/
│   └── game/
│       ├── presentation/
│       │   ├── bloc/
│       │   │   └── game_bloc_test.dart      # BLoC unit tests
│       │   └── widgets/
│       │       ├── timer_widget_test.dart   # Timer widget tests
│       │       └── option_card_test.dart   # Option card widget tests
│       └── data/
│           └── services/
│               └── score_service_test.dart  # Score service tests
└── widget_test.dart                         # Basic app smoke test
```

## Running Tests

To run all tests:
```bash
flutter test
```

To run a specific test file:
```bash
flutter test test/features/game/presentation/bloc/game_bloc_test.dart
```

To run tests with coverage:
```bash
flutter test --coverage
```

## Test Coverage

### Unit Tests
- **GameBloc Tests**: Tests for game state management, puzzle loading, scoring, timeouts, and completion
- **ScoreService Tests**: Tests for score saving, retrieval, and high score management

### Widget Tests
- **TimerWidget Tests**: Tests for timer display and warning states
- **OptionCard Tests**: Tests for option card display, selection, and result states

## Test Dependencies

- `flutter_test`: Flutter's testing framework
- `bloc_test`: Testing utilities for BLoC pattern
- `mocktail`: Mocking library for creating test doubles

## Writing New Tests

When adding new features, ensure to:
1. Write unit tests for business logic (BLoC, Services)
2. Write widget tests for UI components
3. Maintain test coverage above 80%
4. Use descriptive test names that explain what is being tested

## Notes

- Tests use `mocktail` for mocking dependencies
- SharedPreferences is mocked for storage-related tests
- Tests are designed to be fast and isolated

