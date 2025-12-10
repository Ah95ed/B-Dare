import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameScore {
  final int score;
  final int linksCount;
  final String difficulty;
  final DateTime date;
  final Duration timeSpent;
  final bool isCompleted;

  GameScore({
    required this.score,
    required this.linksCount,
    required this.difficulty,
    required this.date,
    required this.timeSpent,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'linksCount': linksCount,
      'difficulty': difficulty,
      'date': date.toIso8601String(),
      'timeSpent': timeSpent.inSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      score: json['score'] as int,
      linksCount: json['linksCount'] as int,
      difficulty: json['difficulty'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSpent: Duration(seconds: json['timeSpent'] as int),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}

class ScoreService {
  static const String _highScoresKey = 'high_scores';

  Future<void> saveScore(GameScore score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getHighScores();
    scores.add(score);
    scores.sort((a, b) => b.score.compareTo(a.score));
    
    // Keep only top 50 scores
    final topScores = scores.take(50).toList();
    
    final jsonList = topScores.map((s) => s.toJson()).toList();
    await prefs.setString(_highScoresKey, json.encode(jsonList));
  }

  Future<List<GameScore>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_highScoresKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((json) => GameScore.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<GameScore>> getTopScores({int limit = 10}) async {
    final scores = await getHighScores();
    return scores.take(limit).toList();
  }

  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoresKey);
  }
}

