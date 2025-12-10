import 'package:equatable/equatable.dart';
import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/entities/bracket.dart';

/// Tournament States
abstract class TournamentState extends Equatable {
  const TournamentState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class TournamentInitial extends TournamentState {
  const TournamentInitial();
}

/// جاري التحميل
class TournamentLoading extends TournamentState {
  const TournamentLoading();
}

/// تم تحميل البطولات
class TournamentsLoaded extends TournamentState {
  final List<Tournament> tournaments;

  const TournamentsLoaded(this.tournaments);

  @override
  List<Object?> get props => [tournaments];
}

/// تم تحميل بطولة محددة
class TournamentLoaded extends TournamentState {
  final Tournament tournament;
  final List<Team>? teams;
  final List<TournamentStage>? stages;
  final TournamentBracket? bracket;

  const TournamentLoaded({
    required this.tournament,
    this.teams,
    this.stages,
    this.bracket,
  });

  @override
  List<Object?> get props => [tournament, teams, stages, bracket];
}

/// تم تحميل الفرق
class TeamsLoaded extends TournamentState {
  final String tournamentId;
  final List<Team> teams;

  const TeamsLoaded({
    required this.tournamentId,
    required this.teams,
  });

  @override
  List<Object?> get props => [tournamentId, teams];
}

/// تم تحميل المراحل
class StagesLoaded extends TournamentState {
  final String tournamentId;
  final List<TournamentStage> stages;

  const StagesLoaded({
    required this.tournamentId,
    required this.stages,
  });

  @override
  List<Object?> get props => [tournamentId, stages];
}

/// تم تحميل المباريات
class MatchesLoaded extends TournamentState {
  final String tournamentId;
  final String stageId;
  final List<Match> matches;

  const MatchesLoaded({
    required this.tournamentId,
    required this.stageId,
    required this.matches,
  });

  @override
  List<Object?> get props => [tournamentId, stageId, matches];
}

/// تم تحميل مباراة محددة
class MatchLoaded extends TournamentState {
  final Match match;

  const MatchLoaded(this.match);

  @override
  List<Object?> get props => [match];
}

/// تم إنشاء/تحديث بطولة
class TournamentUpdated extends TournamentState {
  final Tournament tournament;

  const TournamentUpdated(this.tournament);

  @override
  List<Object?> get props => [tournament];
}

/// تم تسجيل فريق
class TeamRegistered extends TournamentState {
  final String tournamentId;
  final Team team;

  const TeamRegistered({
    required this.tournamentId,
    required this.team,
  });

  @override
  List<Object?> get props => [tournamentId, team];
}

/// تم تحديث نتيجة مباراة
class MatchResultUpdated extends TournamentState {
  final Match match;

  const MatchResultUpdated(this.match);

  @override
  List<Object?> get props => [match];
}

/// خطأ
class TournamentError extends TournamentState {
  final String message;

  const TournamentError(this.message);

  @override
  List<Object?> get props => [message];
}

