import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/difficulty_prediction.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/player_cognitive_profile.dart';
import '../../domain/repositories/adaptive_learning_repository_interface.dart';
import '../models/cognitive_profile_model.dart';
import '../models/performance_sample_model.dart';
import '../services/difficulty_calculator.dart';
import '../services/ml_prediction_service.dart';
import '../services/performance_analyzer.dart';
import '../../../progression/domain/entities/game_result.dart';

class AdaptiveLearningRepository implements AdaptiveLearningRepositoryInterface {
  static const _profileKey = 'adaptive_learning_profile_v1';
  static const _historyKey = 'adaptive_learning_history_v1';
  static const _historyLimit = 60;

  final PerformanceAnalyzer _analyzer;
  final DifficultyCalculator _difficultyCalculator;
  final MlPredictionService _mlPredictionService;

  AdaptiveLearningRepository({
    PerformanceAnalyzer? analyzer,
    DifficultyCalculator? difficultyCalculator,
    MlPredictionService? mlPredictionService,
  })  : _analyzer = analyzer ?? PerformanceAnalyzer(),
        _difficultyCalculator = difficultyCalculator ?? const DifficultyCalculator(),
        _mlPredictionService = mlPredictionService ?? const MlPredictionService();

  @override
  Future<PlayerCognitiveProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = _readProfile(prefs);
    if (cached != null) {
      return cached;
    }

    final history = _readHistory(prefs);
    if (history.isEmpty) {
      return PlayerCognitiveProfile.initial();
    }
    return _rebuildProfile(history, previous: null, prefs: prefs);
  }

  @override
  Future<PlayerCognitiveProfile> recordResult(GameResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = _readHistory(prefs);
    history.add(PerformanceSampleModel.fromResult(result));
    if (history.length > _historyLimit) {
      history.removeAt(0);
    }

    final previous = _readProfile(prefs);
    final profile = _rebuildProfile(
      history,
      previous: previous,
      prefs: prefs,
      lastLinks: result.puzzle.linksCount,
    );

    return profile;
  }

  @override
  Future<DifficultyPrediction> getPrediction() async {
    final profile = await getProfile();
    return _mlPredictionService.buildPrediction(profile);
  }

  @override
  Future<LearningPath> getLearningPath() async {
    final profile = await getProfile();
    return _mlPredictionService.buildLearningPath(profile);
  }

  PlayerCognitiveProfile _rebuildProfile(
    List<PerformanceSampleModel> history, {
    PlayerCognitiveProfile? previous,
    SharedPreferences? prefs,
    int? lastLinks,
  }) {
    final insight = _analyzer.analyze(history);
    final lastRecommendation = previous?.recommendedLinks ?? lastLinks ?? 3;
    final recommendation = _difficultyCalculator.recommend(
      lastLinks: lastLinks ?? lastRecommendation,
      winRate: insight.winRate,
      perfectRate: insight.perfectRate,
      averageTimePerLink: insight.averageTimePerLink,
      previousRecommendation: lastRecommendation,
    );

    final focusAreas = insight.weakDomains.isNotEmpty
        ? insight.weakDomains
        : (insight.strongDomains.isNotEmpty
            ? insight.strongDomains
            : <String>['Exploration']);

    final model = CognitiveProfileModel(
      totalSessions: history.length,
      winRate: insight.winRate,
      perfectRate: insight.perfectRate,
      averageLinks: insight.averageLinks,
      averageTimePerLink: insight.averageTimePerLink,
      recommendedLinks: recommendation,
      preferredRepresentation: insight.preferredRepresentation,
      strongDomains: insight.strongDomains,
      focusAreas: focusAreas,
      updatedAt: DateTime.now(),
    );

    if (prefs != null) {
      _writeProfile(prefs, model);
      _writeHistory(prefs, history);
    }
    return model;
  }

  CognitiveProfileModel? _readProfile(SharedPreferences prefs) {
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      return CognitiveProfileModel.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  void _writeProfile(SharedPreferences prefs, CognitiveProfileModel model) {
    prefs.setString(_profileKey, json.encode(model.toJson()));
  }

  List<PerformanceSampleModel> _readHistory(SharedPreferences prefs) {
    final raw = prefs.getString(_historyKey);
    if (raw == null) return <PerformanceSampleModel>[];
    try {
      final list = json.decode(raw) as List<dynamic>;
      return list
          .map((item) =>
              PerformanceSampleModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <PerformanceSampleModel>[];
    }
  }

  void _writeHistory(
    SharedPreferences prefs,
    List<PerformanceSampleModel> history,
  ) {
    prefs.setString(
      _historyKey,
      json.encode(history.map((e) => e.toJson()).toList()),
    );
  }
}
