import '../../../../core/constants/progression_constants.dart';
import 'achievement.dart';
import 'daily_challenge.dart';
import 'player_progress.dart';

class ProgressionSummary {
  final PlayerProgress progress;
  final int xpEarned;
  final bool leveledUp;
  final List<Achievement> achievements;
  final List<Achievement> newlyUnlocked;
  final DailyChallengeStatus dailyStatus;
  final bool newPhaseUnlocked;
  final PhaseDefinition? unlockedPhase;

  const ProgressionSummary({
    required this.progress,
    required this.xpEarned,
    required this.leveledUp,
    required this.achievements,
    required this.newlyUnlocked,
    required this.dailyStatus,
    required this.newPhaseUnlocked,
    required this.unlockedPhase,
  });
}
