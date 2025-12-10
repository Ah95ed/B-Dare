import 'package:equatable/equatable.dart';
import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match.dart';

/// Tournament Events
abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object?> get props => [];
}

/// جلب جميع البطولات
class FetchTournaments extends TournamentEvent {
  final TournamentStatus? status;
  final int? limit;
  final int? offset;

  const FetchTournaments({
    this.status,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [status, limit, offset];
}

/// جلب بطولة محددة
class FetchTournament extends TournamentEvent {
  final String tournamentId;

  const FetchTournament(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// إنشاء بطولة جديدة
class CreateTournament extends TournamentEvent {
  final Tournament tournament;

  const CreateTournament(this.tournament);

  @override
  List<Object?> get props => [tournament];
}

/// تحديث بطولة
class UpdateTournament extends TournamentEvent {
  final Tournament tournament;

  const UpdateTournament(this.tournament);

  @override
  List<Object?> get props => [tournament];
}

/// حذف بطولة
class DeleteTournament extends TournamentEvent {
  final String tournamentId;

  const DeleteTournament(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// تسجيل فريق في بطولة
class RegisterTeam extends TournamentEvent {
  final String tournamentId;
  final Team team;

  const RegisterTeam({
    required this.tournamentId,
    required this.team,
  });

  @override
  List<Object?> get props => [tournamentId, team];
}

/// إلغاء تسجيل فريق
class UnregisterTeam extends TournamentEvent {
  final String tournamentId;
  final String teamId;

  const UnregisterTeam({
    required this.tournamentId,
    required this.teamId,
  });

  @override
  List<Object?> get props => [tournamentId, teamId];
}

/// جلب جميع الفرق في بطولة
class FetchTournamentTeams extends TournamentEvent {
  final String tournamentId;

  const FetchTournamentTeams(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// جلب جميع المراحل في بطولة
class FetchTournamentStages extends TournamentEvent {
  final String tournamentId;

  const FetchTournamentStages(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// جلب جميع المباريات في مرحلة
class FetchStageMatches extends TournamentEvent {
  final String tournamentId;
  final String stageId;

  const FetchStageMatches({
    required this.tournamentId,
    required this.stageId,
  });

  @override
  List<Object?> get props => [tournamentId, stageId];
}

/// جلب مباراة محددة
class FetchMatch extends TournamentEvent {
  final String tournamentId;
  final String matchId;

  const FetchMatch({
    required this.tournamentId,
    required this.matchId,
  });

  @override
  List<Object?> get props => [tournamentId, matchId];
}

/// تحديث نتيجة مباراة
class UpdateMatchResult extends TournamentEvent {
  final String tournamentId;
  final String matchId;
  final Match match;

  const UpdateMatchResult({
    required this.tournamentId,
    required this.matchId,
    required this.match,
  });

  @override
  List<Object?> get props => [tournamentId, matchId, match];
}

/// بدء مرحلة
class StartStage extends TournamentEvent {
  final String tournamentId;
  final String stageId;

  const StartStage({
    required this.tournamentId,
    required this.stageId,
  });

  @override
  List<Object?> get props => [tournamentId, stageId];
}

/// إكمال مرحلة
class CompleteStage extends TournamentEvent {
  final String tournamentId;
  final String stageId;

  const CompleteStage({
    required this.tournamentId,
    required this.stageId,
  });

  @override
  List<Object?> get props => [tournamentId, stageId];
}

/// بدء بطولة
class StartTournament extends TournamentEvent {
  final String tournamentId;

  const StartTournament(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// إكمال بطولة
class CompleteTournament extends TournamentEvent {
  final String tournamentId;

  const CompleteTournament(this.tournamentId);

  @override
  List<Object?> get props => [tournamentId];
}

/// إعادة تعيين الحالة
class ResetTournamentState extends TournamentEvent {
  const ResetTournamentState();
}

