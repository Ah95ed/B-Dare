import '../../domain/entities/puzzle.dart';
import '../../domain/entities/game_type.dart';

/// Result من معالجة حركة في اللعبة
class MoveResult {
  final bool isValid;
  final bool isCorrect;
  final int? score;
  final bool isGameComplete;
  final Map<String, dynamic>? updatedGameState;
  final String? errorMessage;

  const MoveResult({
    required this.isValid,
    required this.isCorrect,
    this.score,
    this.isGameComplete = false,
    this.updatedGameState,
    this.errorMessage,
  });

  factory MoveResult.success({
    required bool isCorrect,
    int? score,
    bool isGameComplete = false,
    Map<String, dynamic>? updatedGameState,
  }) {
    return MoveResult(
      isValid: true,
      isCorrect: isCorrect,
      score: score,
      isGameComplete: isGameComplete,
      updatedGameState: updatedGameState,
    );
  }

  factory MoveResult.error(String message) {
    return MoveResult(
      isValid: false,
      isCorrect: false,
      errorMessage: message,
    );
  }
}

/// Abstract interface لجميع Game Engines
abstract class GameEngine {
  /// نوع اللعبة الذي يدعمه هذا Engine
  GameType get gameType;

  /// التحقق من صحة الحركة
  /// [moveData]: بيانات الحركة (تختلف حسب نوع اللعبة)
  /// [puzzle]: اللغز الحالي
  /// [currentGameState]: حالة اللعبة الحالية
  bool validateMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
  });

  /// معالجة الحركة وإرجاع النتيجة
  MoveResult processMove({
    required Map<String, dynamic> moveData,
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep,
    int currentScore,
  });

  /// التحقق من شرط الفوز
  bool checkWinCondition({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    int currentStep,
  });

  /// حساب النقاط للحركة
  int calculateScore({
    required bool isCorrect,
    required Puzzle puzzle,
    int currentStep,
    int? timeRemaining,
    Map<String, dynamic>? moveData,
  });

  /// الحصول على حالة اللعبة المحدثة
  Map<String, dynamic>? getGameState({
    required Puzzle puzzle,
    Map<String, dynamic>? currentGameState,
    Map<String, dynamic>? moveData,
  });

  /// تهيئة حالة اللعبة من Puzzle
  Map<String, dynamic> initializeGameState(Puzzle puzzle);
}

