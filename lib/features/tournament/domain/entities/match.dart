import 'package:equatable/equatable.dart';
import 'team.dart';
import 'tournament_stage.dart';

/// حالة المباراة
enum MatchStatus {
  scheduled, // مجدولة
  inProgress, // جارية
  completed, // مكتملة
  forfeited, // انسحاب
  cancelled, // ملغاة
}

/// نتيجة جولة واحدة
class GameResult extends Equatable {
  final int gameNumber; // رقم الجولة (1, 2, 3...)
  final String? winnerTeamId; // الفريق الفائز
  final int team1Score;
  final int team2Score;
  final Duration duration;
  final DateTime completedAt;

  const GameResult({
    required this.gameNumber,
    this.winnerTeamId,
    required this.team1Score,
    required this.team2Score,
    required this.duration,
    required this.completedAt,
  });

  bool get isTeam1Winner {
    // TODO: يحتاج team1Id و team2Id للتحقق الصحيح
    return winnerTeamId != null;
  }
  
  bool get isTeam2Winner {
    // TODO: يحتاج team1Id و team2Id للتحقق الصحيح
    return false;
  }

  @override
  List<Object?> get props => [
        gameNumber,
        winnerTeamId,
        team1Score,
        team2Score,
        duration,
        completedAt,
      ];
}

/// المباراة بين فريقين
class Match extends Equatable {
  final String id;
  final String tournamentId;
  final String stageId;
  final Team team1;
  final Team team2;
  final MatchStatus status;
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<GameResult> gameResults; // نتائج الجولات
  final Team? winner;
  final MatchFormat format;
  final String? roomId; // Cloudflare room ID
  final String? timeZone; // Time zone للمباراة
  final List<DateTime>? preferredTimeSlots; // الأوقات المفضلة
  final bool isRescheduled; // هل تم إعادة الجدولة؟
  final String? rescheduleReason; // سبب إعادة الجدولة

  const Match({
    required this.id,
    required this.tournamentId,
    required this.stageId,
    required this.team1,
    required this.team2,
    this.status = MatchStatus.scheduled,
    required this.scheduledTime,
    this.startTime,
    this.endTime,
    this.gameResults = const [],
    this.winner,
    required this.format,
    this.roomId,
    this.timeZone,
    this.preferredTimeSlots,
    this.isRescheduled = false,
    this.rescheduleReason,
  });

  /// عدد الجولات المكتملة
  int get completedGames => gameResults.length;

  /// عدد الجولات المطلوبة للفوز
  int get requiredWins => format.requiredWins;

  /// هل المباراة مكتملة؟
  bool get isCompleted => status == MatchStatus.completed;

  /// هل المباراة جارية؟
  bool get isInProgress => status == MatchStatus.inProgress;

  /// النتيجة الحالية (Team1 wins - Team2 wins)
  String get currentScore {
    if (gameResults.isEmpty) return '0 - 0';
    final team1Wins = gameResults.where((r) => r.winnerTeamId == team1.id).length;
    final team2Wins = gameResults.where((r) => r.winnerTeamId == team2.id).length;
    return '$team1Wins - $team2Wins';
  }

  /// هل يمكن بدء المباراة؟
  bool get canStart {
    return status == MatchStatus.scheduled &&
        DateTime.now().isAfter(scheduledTime.subtract(const Duration(minutes: 15)));
  }

  /// هل يمكن إعادة الجدولة؟
  bool canReschedule(DateTime newTime) {
    if (!isRescheduled) return true; // يمكن إعادة الجدولة مرة واحدة
    final hoursUntilMatch = scheduledTime.difference(DateTime.now()).inHours;
    return hoursUntilMatch >= 24; // على الأقل 24 ساعة قبل المباراة
  }

  Match copyWith({
    String? id,
    String? tournamentId,
    String? stageId,
    Team? team1,
    Team? team2,
    MatchStatus? status,
    DateTime? scheduledTime,
    DateTime? startTime,
    DateTime? endTime,
    List<GameResult>? gameResults,
    Team? winner,
    MatchFormat? format,
    String? roomId,
    String? timeZone,
    List<DateTime>? preferredTimeSlots,
    bool? isRescheduled,
    String? rescheduleReason,
  }) {
    return Match(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      stageId: stageId ?? this.stageId,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      status: status ?? this.status,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      gameResults: gameResults ?? this.gameResults,
      winner: winner ?? this.winner,
      format: format ?? this.format,
      roomId: roomId ?? this.roomId,
      timeZone: timeZone ?? this.timeZone,
      preferredTimeSlots: preferredTimeSlots ?? this.preferredTimeSlots,
      isRescheduled: isRescheduled ?? this.isRescheduled,
      rescheduleReason: rescheduleReason ?? this.rescheduleReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tournamentId,
        stageId,
        team1,
        team2,
        status,
        scheduledTime,
        startTime,
        endTime,
        gameResults,
        winner,
        format,
        roomId,
        timeZone,
        preferredTimeSlots,
        isRescheduled,
        rescheduleReason,
      ];
}

