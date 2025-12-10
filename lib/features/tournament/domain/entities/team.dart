import 'package:equatable/equatable.dart';

/// إحصائيات الفريق
class TeamStats extends Equatable {
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int totalScore;
  final double winRate;
  final int currentStreak; // سلسلة الانتصارات/الهزائم
  final bool isWinningStreak; // true = انتصارات، false = هزائم

  const TeamStats({
    this.matchesPlayed = 0,
    this.matchesWon = 0,
    this.matchesLost = 0,
    this.totalScore = 0,
    this.winRate = 0.0,
    this.currentStreak = 0,
    this.isWinningStreak = true,
  });

  TeamStats copyWith({
    int? matchesPlayed,
    int? matchesWon,
    int? matchesLost,
    int? totalScore,
    double? winRate,
    int? currentStreak,
    bool? isWinningStreak,
  }) {
    return TeamStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      matchesWon: matchesWon ?? this.matchesWon,
      matchesLost: matchesLost ?? this.matchesLost,
      totalScore: totalScore ?? this.totalScore,
      winRate: winRate ?? this.winRate,
      currentStreak: currentStreak ?? this.currentStreak,
      isWinningStreak: isWinningStreak ?? this.isWinningStreak,
    );
  }

  @override
  List<Object?> get props => [
        matchesPlayed,
        matchesWon,
        matchesLost,
        totalScore,
        winRate,
        currentStreak,
        isWinningStreak,
      ];
}

/// الفريق في البطولة
class Team extends Equatable {
  final String id;
  final String name;
  final String captainId; // قائد الفريق
  final List<String> memberIds; // أعضاء الفريق
  final String timeZone; // التوقيت المحلي
  final List<DateTime> preferredTimeSlots; // الأوقات المفضلة (3 خيارات)
  final TeamStats stats;
  final int? seed; // الترتيب في البطولة (للتصنيف)
  final String? avatarUrl; // صورة الفريق
  final String? countryCode; // رمز الدولة
  final DateTime registeredAt; // تاريخ التسجيل

  const Team({
    required this.id,
    required this.name,
    required this.captainId,
    required this.memberIds,
    required this.timeZone,
    this.preferredTimeSlots = const [],
    this.stats = const TeamStats(),
    this.seed,
    this.avatarUrl,
    this.countryCode,
    required this.registeredAt,
  });

  int get memberCount => memberIds.length;

  bool get isFull => memberIds.length >= 6; // حد أقصى 6 أعضاء

  bool get canJoin => !isFull;

  Team copyWith({
    String? id,
    String? name,
    String? captainId,
    List<String>? memberIds,
    String? timeZone,
    List<DateTime>? preferredTimeSlots,
    TeamStats? stats,
    int? seed,
    String? avatarUrl,
    String? countryCode,
    DateTime? registeredAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      captainId: captainId ?? this.captainId,
      memberIds: memberIds ?? this.memberIds,
      timeZone: timeZone ?? this.timeZone,
      preferredTimeSlots: preferredTimeSlots ?? this.preferredTimeSlots,
      stats: stats ?? this.stats,
      seed: seed ?? this.seed,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      countryCode: countryCode ?? this.countryCode,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        captainId,
        memberIds,
        timeZone,
        preferredTimeSlots,
        stats,
        seed,
        avatarUrl,
        countryCode,
        registeredAt,
      ];
}

