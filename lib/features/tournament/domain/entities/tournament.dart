import 'package:equatable/equatable.dart';
import 'tournament_stage.dart';
import 'bracket.dart';

/// نوع البطولة
enum TournamentType {
  singleElimination, // إقصاء فردي
  doubleElimination, // إقصاء مزدوج
  swiss, // نظام سويسري
  roundRobin, // دوري دائري
}

/// حالة البطولة
enum TournamentStatus {
  registration, // التسجيل
  qualifiers, // التصفيات
  playoffs, // التصفيات النهائية
  finalStage, // النهائي
  completed, // مكتملة
  cancelled, // ملغاة
}

/// إعدادات البطولة
class TournamentSettings extends Equatable {
  final int maxTeams;
  final int minTeamsPerMatch;
  final int maxTeamsPerMatch;
  final Duration matchDuration;
  final Duration breakBetweenMatches;
  final bool allowRescheduling;
  final int reschedulingDeadlineHours; // ساعات قبل المباراة
  final bool autoForfeitEnabled;
  final int autoForfeitMinutes; // دقائق بعد الوقت المحدد

  const TournamentSettings({
    required this.maxTeams,
    this.minTeamsPerMatch = 2,
    this.maxTeamsPerMatch = 2,
    this.matchDuration = const Duration(minutes: 30),
    this.breakBetweenMatches = const Duration(minutes: 5),
    this.allowRescheduling = true,
    this.reschedulingDeadlineHours = 24,
    this.autoForfeitEnabled = true,
    this.autoForfeitMinutes = 15,
  });

  @override
  List<Object?> get props => [
        maxTeams,
        minTeamsPerMatch,
        maxTeamsPerMatch,
        matchDuration,
        breakBetweenMatches,
        allowRescheduling,
        reschedulingDeadlineHours,
        autoForfeitEnabled,
        autoForfeitMinutes,
      ];
}

/// البطولة العالمية
class Tournament extends Equatable {
  final String id;
  final String name;
  final String description;
  final TournamentType type;
  final TournamentStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final int maxTeams;
  final int currentTeams;
  final List<TournamentStage> stages;
  final TournamentBracket? bracket;
  final TournamentSettings settings;
  final String? prizePool; // الجوائز
  final String? organizerId; // منظم البطولة
  final Map<String, dynamic>? metadata; // بيانات إضافية

  const Tournament({
    required this.id,
    required this.name,
    this.description = '',
    required this.type,
    this.status = TournamentStatus.registration,
    required this.startDate,
    required this.endDate,
    required this.registrationStartDate,
    required this.registrationEndDate,
    required this.maxTeams,
    this.currentTeams = 0,
    this.stages = const [],
    this.bracket,
    required this.settings,
    this.prizePool,
    this.organizerId,
    this.metadata,
  });

  bool get isRegistrationOpen {
    final now = DateTime.now();
    return now.isAfter(registrationStartDate) && now.isBefore(registrationEndDate);
  }

  bool get isFull => currentTeams >= maxTeams;

  bool get canStart => currentTeams >= settings.minTeamsPerMatch && isRegistrationOpen == false;

  TournamentStage? get currentStage {
    if (stages.isEmpty) return null;
    return stages.firstWhere(
      (stage) => stage.status == StageStatus.inProgress,
      orElse: () => stages.first,
    );
  }

  Tournament copyWith({
    String? id,
    String? name,
    String? description,
    TournamentType? type,
    TournamentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? registrationStartDate,
    DateTime? registrationEndDate,
    int? maxTeams,
    int? currentTeams,
    List<TournamentStage>? stages,
    TournamentBracket? bracket,
    TournamentSettings? settings,
    String? prizePool,
    String? organizerId,
    Map<String, dynamic>? metadata,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      registrationStartDate: registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      maxTeams: maxTeams ?? this.maxTeams,
      currentTeams: currentTeams ?? this.currentTeams,
      stages: stages ?? this.stages,
      bracket: bracket ?? this.bracket,
      settings: settings ?? this.settings,
      prizePool: prizePool ?? this.prizePool,
      organizerId: organizerId ?? this.organizerId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        status,
        startDate,
        endDate,
        registrationStartDate,
        registrationEndDate,
        maxTeams,
        currentTeams,
        stages,
        bracket,
        settings,
        prizePool,
        organizerId,
        metadata,
      ];
}

