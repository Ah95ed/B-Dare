import '../../features/game/domain/entities/game_type.dart';

class GameConstants {
  // Difficulty levels
  static const int minLinks = 1;
  static const int maxLinks = 20;
  static const int defaultLinks = 3;
  static const String linkCategoryAny = 'Any';
  static const List<String> linkCategories = [
    linkCategoryAny,
    'General Knowledge',
    'Science & Technology',
    'Nature & Environment',
    'Agriculture & Food',
    'Industry & Economy',
    'Sports & Health',
    'Arts & Culture',
    'History & Heritage',
    'Geography & Places',
  ];
  static const List<String> groupProfiles = [
    'Students',
    'School',
    'Friends',
    'Family',
    'Colleagues',
    'Club',
    'Community',
  ];
  
  // Time limits (in seconds)
  static const int timePerStep = 12;
  static const int minTimePerStep = 8;
  static const int maxTimePerStep = 20;
  
  // Scoring
  static const int basePointsPerStep = 100;
  static const int bonusMultiplier = 2;
  static const int timeBonusThreshold = 5; // seconds remaining for bonus
  static const double hintPenaltyMultiplier = 0.5; // 50% of points when hint is used
  
  // Options per step
  static const int minOptions = 3;
  static const int maxOptions = 7;
  static const int defaultOptions = 4;
  
  // Group mode
  static const int minPlayers = 2;
  static const int maxPlayers = 6;
  
  // Animation durations
  static const Duration cardFlipDuration = Duration(milliseconds: 300);
  static const Duration transitionDuration = Duration(milliseconds: 200);
  
  // Game Types
  static const GameType defaultGameType = GameType.mysteryLink;
  
  static const List<GameType> availableGameTypes = [
    GameType.mysteryLink,
    GameType.memoryFlip,
    GameType.spotTheOdd,
    GameType.sortSolve,
    GameType.storyTiles,
    GameType.shadowMatch,
    GameType.emojiCircuit,
    GameType.cipherTiles,
    GameType.spotTheChange,
    GameType.colorHarmony,
    GameType.puzzleSentence,
  ];
}

