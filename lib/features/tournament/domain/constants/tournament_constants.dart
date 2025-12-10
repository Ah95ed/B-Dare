import '../entities/tournament_stage.dart';
import '../entities/tournament.dart';
import 'dart:math';

/// ثوابت البطولات - بناءً على أفضل الممارسات 2025
class TournamentConstants {
  TournamentConstants._();

  // ============================================
  // مدة المباريات حسب المرحلة
  // ============================================

  /// مدة المباراة في التصفيات (Qualifiers)
  static const Duration qualifierMatchDuration = Duration(minutes: 20);

  /// مدة المباراة في التصفيات النهائية (Playoffs)
  static const Duration playoffMatchDuration = Duration(minutes: 30);

  /// مدة المباراة في النهائي (Finals)
  static const Duration finalMatchDuration = Duration(minutes: 50);

  /// مدة المباراة الافتراضية
  static const Duration defaultMatchDuration = Duration(minutes: 25);

  // ============================================
  // Format المباريات حسب المرحلة
  // ============================================

  /// Format المباريات في التصفيات
  static const MatchFormat qualifierFormat = MatchFormat.bestOf3;

  /// Format المباريات في التصفيات النهائية
  static const MatchFormat playoffFormat = MatchFormat.bestOf3;

  /// Format المباريات في النهائي
  static const MatchFormat finalFormat = MatchFormat.bestOf5;

  /// Format المباريات في Grand Finals
  static const MatchFormat grandFinalFormat = MatchFormat.bestOf7;

  // ============================================
  // استراحات بين الجولات والمباريات
  // ============================================

  /// استراحة بين الجولات في نفس المباراة
  static const Duration breakBetweenGames = Duration(minutes: 3);

  /// استراحة بين المباريات في نفس الجولة
  static const Duration breakBetweenMatches = Duration(minutes: 10);

  /// استراحة بين الجولات المختلفة
  static const Duration breakBetweenRounds = Duration(minutes: 20);

  /// استراحة قبل النهائي
  static const Duration breakBeforeFinals = Duration(minutes: 30);

  // ============================================
  // عدد الجولات حسب نوع البطولة
  // ============================================

  /// حساب عدد الجولات لـ Single Elimination
  static int calculateSingleEliminationRounds(int teamCount) {
    if (teamCount < 2) return 1;
    return (log(teamCount) / log(2)).ceil();
  }

  /// حساب عدد الجولات لـ Double Elimination (Winners Bracket)
  static int calculateDoubleEliminationWinnersRounds(int teamCount) {
    return calculateSingleEliminationRounds(teamCount);
  }

  /// حساب عدد الجولات لـ Double Elimination (Losers Bracket)
  static int calculateDoubleEliminationLosersRounds(int teamCount) {
    final winnersRounds = calculateDoubleEliminationWinnersRounds(teamCount);
    return (winnersRounds * 2) - 1;
  }

  /// حساب عدد الجولات لـ Swiss System
  static int calculateSwissSystemRounds(int teamCount) {
    if (teamCount <= 8) return 3;
    if (teamCount <= 16) return 4;
    if (teamCount <= 32) return 5;
    if (teamCount <= 64) return 6;
    if (teamCount <= 128) return 7;
    return 8; // 128+ teams
  }

  /// حساب عدد الجولات لـ Round Robin
  static int calculateRoundRobinRounds(int teamCount) {
    return teamCount - 1;
  }

  // ============================================
  // مدة البطولة الإجمالية
  // ============================================

  /// تقدير مدة البطولة (بالساعات) لـ Single Elimination
  static double estimateSingleEliminationDuration(
    int teamCount,
    Duration matchDuration,
  ) {
    final rounds = calculateSingleEliminationRounds(teamCount);
    final matchesPerRound = teamCount / 2;
    final totalMatches = matchesPerRound * rounds;
    final matchDurationHours = matchDuration.inMinutes / 60.0;
    final breakTimeHours = (breakBetweenRounds.inMinutes * rounds) / 60.0;
    
    return (totalMatches * matchDurationHours) + breakTimeHours;
  }

  /// تقدير مدة البطولة (بالساعات) لـ Double Elimination
  static double estimateDoubleEliminationDuration(
    int teamCount,
    Duration matchDuration,
  ) {
    final winnersRounds = calculateDoubleEliminationWinnersRounds(teamCount);
    final losersRounds = calculateDoubleEliminationLosersRounds(teamCount);
    final totalRounds = winnersRounds + losersRounds;
    final matchDurationHours = matchDuration.inMinutes / 60.0;
    final breakTimeHours = (breakBetweenRounds.inMinutes * totalRounds) / 60.0;
    
    // تقدير عدد المباريات
    final estimatedMatches = teamCount * 1.5; // متوسط في Double Elimination
    
    return (estimatedMatches * matchDurationHours) + breakTimeHours;
  }

  /// تقدير مدة البطولة (بالساعات) لـ Swiss System
  static double estimateSwissSystemDuration(
    int teamCount,
    Duration matchDuration,
    int rounds,
  ) {
    final matchesPerRound = teamCount / 2;
    final totalMatches = matchesPerRound * rounds;
    final matchDurationHours = matchDuration.inMinutes / 60.0;
    final breakTimeHours = (breakBetweenRounds.inMinutes * rounds) / 60.0;
    
    return (totalMatches * matchDurationHours) + breakTimeHours;
  }

  // ============================================
  // التوصيات حسب حجم البطولة
  // ============================================

  /// الحصول على التوصيات لبطولة صغيرة (8-16 فريق)
  static TournamentRecommendation getSmallTournamentRecommendation(int teamCount) {
    return TournamentRecommendation(
      type: TournamentType.singleElimination,
      totalRounds: calculateSingleEliminationRounds(teamCount),
      matchFormat: qualifierFormat,
      finalFormat: finalFormat,
      estimatedDuration: estimateSingleEliminationDuration(
        teamCount,
        qualifierMatchDuration,
      ),
      days: 1,
    );
  }

  /// الحصول على التوصيات لبطولة متوسطة (32-64 فريق)
  static TournamentRecommendation getMediumTournamentRecommendation(int teamCount) {
    return TournamentRecommendation(
      type: TournamentType.doubleElimination,
      totalRounds: calculateDoubleEliminationWinnersRounds(teamCount) +
          calculateDoubleEliminationLosersRounds(teamCount),
      matchFormat: playoffFormat,
      finalFormat: grandFinalFormat,
      estimatedDuration: estimateDoubleEliminationDuration(
        teamCount,
        playoffMatchDuration,
      ),
      days: 2,
    );
  }

  /// الحصول على التوصيات لبطولة كبيرة (128+ فريق)
  static TournamentRecommendation getLargeTournamentRecommendation(int teamCount) {
    final swissRounds = calculateSwissSystemRounds(teamCount);
    return TournamentRecommendation(
      type: TournamentType.swiss,
      totalRounds: swissRounds + 4, // Swiss + Playoffs
      matchFormat: qualifierFormat,
      finalFormat: grandFinalFormat,
      estimatedDuration: estimateSwissSystemDuration(
        teamCount,
        qualifierMatchDuration,
        swissRounds,
      ) + estimateSingleEliminationDuration(16, playoffMatchDuration),
      days: 4,
    );
  }

  /// الحصول على التوصيات حسب عدد الفرق
  static TournamentRecommendation getRecommendationForTeamCount(int teamCount) {
    if (teamCount <= 16) {
      return getSmallTournamentRecommendation(teamCount);
    } else if (teamCount <= 64) {
      return getMediumTournamentRecommendation(teamCount);
    } else {
      return getLargeTournamentRecommendation(teamCount);
    }
  }

  // ============================================
  // Format المباريات حسب المرحلة
  // ============================================

  /// الحصول على Format المباراة حسب نوع المرحلة
  static MatchFormat getMatchFormatForStageType(StageType stageType) {
    switch (stageType) {
      case StageType.qualifier:
        return qualifierFormat;
      case StageType.elimination:
        return playoffFormat;
      case StageType.finalStage:
        return finalFormat;
    }
  }

  /// الحصول على مدة المباراة حسب نوع المرحلة
  static Duration getMatchDurationForStageType(StageType stageType) {
    switch (stageType) {
      case StageType.qualifier:
        return qualifierMatchDuration;
      case StageType.elimination:
        return playoffMatchDuration;
      case StageType.finalStage:
        return finalMatchDuration;
    }
  }

  // ============================================
  // إعدادات افتراضية موصى بها
  // ============================================

  /// إعدادات البطولة الافتراضية الموصى بها
  static TournamentSettings getDefaultSettings(int maxTeams) {
    return TournamentSettings(
      maxTeams: maxTeams,
      minTeamsPerMatch: 2,
      maxTeamsPerMatch: 2,
      matchDuration: defaultMatchDuration,
      breakBetweenMatches: breakBetweenMatches,
      allowRescheduling: true,
      reschedulingDeadlineHours: 24,
      autoForfeitEnabled: true,
      autoForfeitMinutes: 15,
    );
  }
}

/// توصيات البطولة
class TournamentRecommendation {
  final TournamentType type;
  final int totalRounds;
  final MatchFormat matchFormat;
  final MatchFormat finalFormat;
  final double estimatedDuration; // بالساعات
  final int days;

  const TournamentRecommendation({
    required this.type,
    required this.totalRounds,
    required this.matchFormat,
    required this.finalFormat,
    required this.estimatedDuration,
    required this.days,
  });

  @override
  String toString() {
    return 'TournamentRecommendation('
        'type: $type, '
        'rounds: $totalRounds, '
        'format: $matchFormat, '
        'finalFormat: $finalFormat, '
        'duration: ${estimatedDuration.toStringAsFixed(1)} hours, '
        'days: $days'
        ')';
  }
}

