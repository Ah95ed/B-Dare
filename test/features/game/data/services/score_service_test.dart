import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/data/services/score_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ScoreService scoreService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    scoreService = ScoreService();
  });

  group('ScoreService', () {
    test('saves score correctly', () async {
      final score = GameScore(
        score: 1000,
        linksCount: 3,
        difficulty: 'medium',
        date: DateTime.now(),
        timeSpent: const Duration(seconds: 45),
        isCompleted: true,
      );

      await scoreService.saveScore(score);

      final highScores = await scoreService.getHighScores();
      expect(highScores.length, equals(1));
      expect(highScores.first.score, equals(1000));
      expect(highScores.first.linksCount, equals(3));
    });

    test('retrieves high scores in descending order', () async {
      final score1 = GameScore(
        score: 500,
        linksCount: 2,
        difficulty: 'easy',
        date: DateTime.now(),
        timeSpent: const Duration(seconds: 30),
        isCompleted: true,
      );

      final score2 = GameScore(
        score: 1500,
        linksCount: 5,
        difficulty: 'hard',
        date: DateTime.now(),
        timeSpent: const Duration(seconds: 60),
        isCompleted: true,
      );

      final score3 = GameScore(
        score: 800,
        linksCount: 3,
        difficulty: 'medium',
        date: DateTime.now(),
        timeSpent: const Duration(seconds: 40),
        isCompleted: true,
      );

      await scoreService.saveScore(score1);
      await scoreService.saveScore(score2);
      await scoreService.saveScore(score3);

      final highScores = await scoreService.getHighScores();
      expect(highScores.length, equals(3));
      expect(highScores[0].score, equals(1500)); // Highest first
      expect(highScores[1].score, equals(800));
      expect(highScores[2].score, equals(500));
    });

    test('limits high scores to top 50', () async {
      for (int i = 0; i < 60; i++) {
        final score = GameScore(
          score: i * 10,
          linksCount: 1,
          difficulty: 'easy',
          date: DateTime.now(),
          timeSpent: const Duration(seconds: 10),
          isCompleted: true,
        );
        await scoreService.saveScore(score);
      }

      final highScores = await scoreService.getHighScores();
      expect(highScores.length, lessThanOrEqualTo(50));
    });

    test('returns empty list when no scores exist', () async {
      final highScores = await scoreService.getHighScores();
      expect(highScores, isEmpty);
    });
  });
}

