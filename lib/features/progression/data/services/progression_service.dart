import 'dart:convert';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/progression_constants.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/daily_challenge.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/player_progress.dart';
import '../../domain/entities/progression_summary.dart';

class ProgressionService {
  static const _progressKey = 'player_progress_v1';
  static const _achievementKey = 'player_achievements_v1';
  static const _dailyKey = 'daily_challenge_v1';

  Future<PlayerProgress> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadProgress(prefs);
  }

  Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadAchievements(prefs);
  }

  Future<DailyChallengeStatus> getDailyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await _loadDailyStatus(prefs);
    final now = _today();
    final completedToday = status.lastCompletionDate != null &&
        _isSameDay(status.lastCompletionDate!, now);
    return status.copyWith(today: now, completedToday: completedToday);
  }

  DailyChallengeConfig getTodayConfig() {
    final now = DateTime.now().toUtc();
    final daySeed =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/
            const Duration(days: 1).inMilliseconds;
    const types = RepresentationType.values;
    final representation = types[daySeed % types.length];
    const linksRange = ProgressionConstants.maxDailyLinks -
        ProgressionConstants.minDailyLinks +
        1;
    final links = ProgressionConstants.minDailyLinks + (daySeed % linksRange);
    return DailyChallengeConfig(
      representationType: representation,
      linksCount: links,
    );
  }

  Future<ProgressionSummary> recordGameResult(GameResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final currentProgress = await _loadProgress(prefs);
    final today = _today();
    var achievements = await _loadAchievements(prefs);
    var dailyStatus = await _loadDailyStatus(prefs);
    final phaseDef =
        ProgressionConstants.phaseForLinks(result.puzzle.linksCount);
    final phaseIndex = ProgressionConstants.phases
        .indexWhere((definition) => definition.id == phaseDef.id);

    final xpEarned = ProgressionConstants.calculateXp(
      score: result.score,
      timeSpent: result.timeSpent,
      linksCount: result.puzzle.linksCount,
      isPerfect: result.isPerfect,
      isDaily: result.isDaily,
      isWin: result.isWin,
    );

    int xpInLevel = currentProgress.xpInLevel + xpEarned;
    final int totalXp = currentProgress.totalXp + xpEarned;
    int level = currentProgress.level;
    bool leveledUp = false;
    int xpNeeded = ProgressionConstants.xpNeededForNextLevel(level);

    while (xpInLevel >= xpNeeded) {
      xpInLevel -= xpNeeded;
      level += 1;
      leveledUp = true;
      xpNeeded = ProgressionConstants.xpNeededForNextLevel(level);
    }

    final phaseWins = _ensurePhaseMap(currentProgress.phaseWins);
    final phasePerfectWins = _ensurePhaseMap(currentProgress.phasePerfectWins);
    final phaseStreaks = _ensurePhaseMap(currentProgress.phaseStreaks);

    if (result.isWin) {
      phaseWins[phaseDef.id] = (phaseWins[phaseDef.id] ?? 0) + 1;
      if (result.isPerfect) {
        phasePerfectWins[phaseDef.id] =
            (phasePerfectWins[phaseDef.id] ?? 0) + 1;
      }
      final currentStreak = phaseStreaks[phaseDef.id] ?? 0;
      phaseStreaks[phaseDef.id] = currentStreak + 1;
    } else {
      phaseStreaks[phaseDef.id] = 0;
    }

    var updatedProgress = currentProgress.copyWith(
      level: level,
      xpInLevel: xpInLevel,
      totalXp: totalXp,
      gamesPlayed: currentProgress.gamesPlayed + 1,
      perfectGames: currentProgress.perfectGames +
          (result.isPerfect && result.isWin ? 1 : 0),
      phaseWins: phaseWins,
      phasePerfectWins: phasePerfectWins,
      phaseStreaks: phaseStreaks,
    );

    final newlyUnlocked = <Achievement>[];
    achievements = _ensureAllAchievements(achievements);

    void unlockIf(bool condition, AchievementType type) {
      if (!condition) return;
      final index = achievements.indexWhere((a) => a.type == type);
      if (index == -1 || achievements[index].isUnlocked) {
        return;
      }
      final unlocked = achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      achievements[index] = unlocked;
      newlyUnlocked.add(unlocked);
    }

    unlockIf(result.isWin, AchievementType.firstWin);
    unlockIf(result.isPerfect && result.isWin, AchievementType.perfectChain);
    unlockIf(result.timeSpent.inSeconds <= 60 && result.isWin,
        AchievementType.speedRunner);
    unlockIf(result.isDaily && result.isWin, AchievementType.dailyHero);

    if (result.isDaily && result.isWin) {
      final last = dailyStatus.lastCompletionDate;
      final completionDate = today;
      int streak = 1;
      if (last != null) {
        final dayDiff = completionDate
            .difference(
              DateTime(last.year, last.month, last.day),
            )
            .inDays;
        if (dayDiff == 0) {
          streak = dailyStatus.streakCount;
        } else if (dayDiff == 1) {
          streak = dailyStatus.streakCount + 1;
        }
      }
      dailyStatus = DailyChallengeStatus(
        today: today,
        lastCompletionDate: completionDate,
        streakCount: streak,
        completedToday: true,
        bestScore: math.max(dailyStatus.bestScore, result.score),
      );
    } else {
      final completedToday = dailyStatus.lastCompletionDate != null &&
          _isSameDay(dailyStatus.lastCompletionDate!, today);
      dailyStatus = dailyStatus.copyWith(
        today: today,
        completedToday: completedToday,
      );
    }

    bool newPhaseUnlocked = false;
    PhaseDefinition? unlockedPhase;
    var unlockedPhaseIndex = updatedProgress.unlockedPhaseIndex;

    if (result.isWin && phaseIndex == unlockedPhaseIndex) {
      final meetsWins = phaseWins[phaseDef.id]! >= phaseDef.requiredWins;
      final meetsPerfect =
          phasePerfectWins[phaseDef.id]! >= phaseDef.requiredPerfectWins;
      final meetsStreak = phaseDef.requiredStreak <= 0 ||
          phaseStreaks[phaseDef.id]! >= phaseDef.requiredStreak;

      if (meetsWins && meetsPerfect && meetsStreak) {
        final nextIndex = unlockedPhaseIndex + 1;
        if (nextIndex < ProgressionConstants.phases.length) {
          unlockedPhaseIndex = nextIndex;
          newPhaseUnlocked = true;
          unlockedPhase = ProgressionConstants.phaseByIndex(nextIndex);
        }
      }
    }

    updatedProgress = updatedProgress.copyWith(
      dailyStreak: dailyStatus.streakCount,
      lastDailyCompletion: dailyStatus.lastCompletionDate,
      unlockedPhaseIndex: unlockedPhaseIndex,
      phaseWins: phaseWins,
      phasePerfectWins: phasePerfectWins,
      phaseStreaks: phaseStreaks,
    );

    await prefs.setString(
      _progressKey,
      json.encode(updatedProgress.toJson()),
    );
    await prefs.setString(
      _achievementKey,
      json.encode(achievements.map((a) => a.toJson()).toList()),
    );
    await prefs.setString(
      _dailyKey,
      json.encode(dailyStatus.toJson()),
    );

    return ProgressionSummary(
      progress: updatedProgress,
      xpEarned: xpEarned,
      leveledUp: leveledUp,
      achievements: achievements,
      newlyUnlocked: newlyUnlocked,
      dailyStatus: dailyStatus,
      newPhaseUnlocked: newPhaseUnlocked,
      unlockedPhase: unlockedPhase,
    );
  }

  Future<PlayerProgress> _loadProgress(SharedPreferences prefs) async {
    final raw = prefs.getString(_progressKey);
    if (raw == null) {
      final initial = PlayerProgress.initial();
      final wins = _ensurePhaseMap(initial.phaseWins);
      final perfects = _ensurePhaseMap(initial.phasePerfectWins);
      final streaks = _ensurePhaseMap(initial.phaseStreaks);
      return initial.copyWith(
        phaseWins: wins,
        phasePerfectWins: perfects,
        phaseStreaks: streaks,
      );
    }
    try {
      final jsonMap = json.decode(raw) as Map<String, dynamic>;
      final progress = PlayerProgress.fromJson(jsonMap);
      return progress.copyWith(
        phaseWins: _ensurePhaseMap(progress.phaseWins),
        phasePerfectWins: _ensurePhaseMap(progress.phasePerfectWins),
        phaseStreaks: _ensurePhaseMap(progress.phaseStreaks),
      );
    } catch (_) {
      return PlayerProgress.initial();
    }
  }

  Future<List<Achievement>> _loadAchievements(SharedPreferences prefs) async {
    final raw = prefs.getString(_achievementKey);
    if (raw == null) {
      return _ensureAllAchievements(const []);
    }
    try {
      final jsonList = json.decode(raw) as List<dynamic>;
      final achievements = jsonList
          .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
          .toList();
      return _ensureAllAchievements(achievements);
    } catch (_) {
      return _ensureAllAchievements(const []);
    }
  }

  Future<DailyChallengeStatus> _loadDailyStatus(SharedPreferences prefs) async {
    final raw = prefs.getString(_dailyKey);
    if (raw == null) {
      return DailyChallengeStatus.initial();
    }
    try {
      final jsonMap = json.decode(raw) as Map<String, dynamic>;
      return DailyChallengeStatus.fromJson(jsonMap);
    } catch (_) {
      return DailyChallengeStatus.initial();
    }
  }

  List<Achievement> _ensureAllAchievements(List<Achievement> achievements) {
    final map = {
      for (final achievement in achievements) achievement.type: achievement
    };
    for (final type in AchievementType.values) {
      map.putIfAbsent(type, () => Achievement.locked(type));
    }
    return AchievementType.values.map((type) => map[type]!).toList();
  }

  Map<String, int> _ensurePhaseMap(Map<String, int> source) {
    final map = Map<String, int>.from(source);
    for (final phase in ProgressionConstants.phases) {
      map.putIfAbsent(phase.id, () => 0);
    }
    return map;
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
