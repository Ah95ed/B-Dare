import 'package:equatable/equatable.dart';
import 'match.dart';

/// نوع المرحلة
enum StageType {
  qualifier, // تصفيات
  elimination, // إقصاء
  finalStage, // نهائي
}

/// حالة المرحلة
enum StageStatus {
  notStarted, // لم تبدأ
  inProgress, // جارية
  completed, // مكتملة
}

/// نظام المباراة
enum MatchFormat {
  bestOf3, // أفضل 3 (أول من يفوز جولتين)
  bestOf5, // أفضل 5 (أول من يفوز 3 جولات)
  bestOf7, // أفضل 7 (أول من يفوز 4 جولات)
  singleGame, // مباراة واحدة
}

extension MatchFormatExtension on MatchFormat {
  int get requiredWins {
    switch (this) {
      case MatchFormat.bestOf3:
        return 2;
      case MatchFormat.bestOf5:
        return 3;
      case MatchFormat.bestOf7:
        return 4;
      case MatchFormat.singleGame:
        return 1;
    }
  }

  int get maxGames {
    switch (this) {
      case MatchFormat.bestOf3:
        return 3;
      case MatchFormat.bestOf5:
        return 5;
      case MatchFormat.bestOf7:
        return 7;
      case MatchFormat.singleGame:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case MatchFormat.bestOf3:
        return 'أفضل 3';
      case MatchFormat.bestOf5:
        return 'أفضل 5';
      case MatchFormat.bestOf7:
        return 'أفضل 7';
      case MatchFormat.singleGame:
        return 'مباراة واحدة';
    }
  }
}

/// مرحلة البطولة
class TournamentStage extends Equatable {
  final String id;
  final String tournamentId;
  final String name;
  final StageType type;
  final StageStatus status;
  final int roundNumber; // رقم الجولة (1, 2, 3...)
  final int totalRounds; // إجمالي الجولات
  final List<Match> matches;
  final DateTime startDate;
  final DateTime endDate;
  final MatchFormat format;
  final int? teamsAdvancing; // عدد الفرق المتأهلة

  const TournamentStage({
    required this.id,
    required this.tournamentId,
    required this.name,
    required this.type,
    this.status = StageStatus.notStarted,
    required this.roundNumber,
    required this.totalRounds,
    this.matches = const [],
    required this.startDate,
    required this.endDate,
    required this.format,
    this.teamsAdvancing,
  });

  bool get isCompleted {
    if (matches.isEmpty) return false;
    return matches.every((match) => match.status == MatchStatus.completed);
  }

  bool get isInProgress {
    return matches.any((match) => match.status == MatchStatus.inProgress);
  }

  List<Match> get completedMatches {
    return matches.where((match) => match.status == MatchStatus.completed).toList();
  }

  List<Match> get upcomingMatches {
    return matches.where((match) => match.status == MatchStatus.scheduled).toList();
  }

  TournamentStage copyWith({
    String? id,
    String? tournamentId,
    String? name,
    StageType? type,
    StageStatus? status,
    int? roundNumber,
    int? totalRounds,
    List<Match>? matches,
    DateTime? startDate,
    DateTime? endDate,
    MatchFormat? format,
    int? teamsAdvancing,
  }) {
    return TournamentStage(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      roundNumber: roundNumber ?? this.roundNumber,
      totalRounds: totalRounds ?? this.totalRounds,
      matches: matches ?? this.matches,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      format: format ?? this.format,
      teamsAdvancing: teamsAdvancing ?? this.teamsAdvancing,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tournamentId,
        name,
        type,
        status,
        roundNumber,
        totalRounds,
        matches,
        startDate,
        endDate,
        format,
        teamsAdvancing,
      ];
}

