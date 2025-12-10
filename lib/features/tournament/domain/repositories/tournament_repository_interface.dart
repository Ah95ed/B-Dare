import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/entities/bracket.dart';

/// Interface لـ Tournament Repository
abstract class TournamentRepositoryInterface {
  /// الحصول على جميع البطولات
  Future<List<Tournament>> getAllTournaments({
    TournamentStatus? status,
    int? limit,
    int? offset,
  });

  /// الحصول على بطولة محددة
  Future<Tournament?> getTournamentById(String tournamentId);

  /// إنشاء بطولة جديدة
  Future<Tournament> createTournament(Tournament tournament);

  /// تحديث بطولة
  Future<Tournament> updateTournament(Tournament tournament);

  /// حذف بطولة
  Future<void> deleteTournament(String tournamentId);

  /// تسجيل فريق في بطولة
  Future<void> registerTeam(String tournamentId, Team team);

  /// إلغاء تسجيل فريق
  Future<void> unregisterTeam(String tournamentId, String teamId);

  /// الحصول على جميع الفرق في بطولة
  Future<List<Team>> getTournamentTeams(String tournamentId);

  /// الحصول على فريق محدد
  Future<Team?> getTeamById(String tournamentId, String teamId);

  /// الحصول على جميع المراحل في بطولة
  Future<List<TournamentStage>> getTournamentStages(String tournamentId);

  /// الحصول على مرحلة محددة
  Future<TournamentStage?> getStageById(String tournamentId, String stageId);

  /// إنشاء مرحلة جديدة
  Future<TournamentStage> createStage(TournamentStage stage);

  /// تحديث مرحلة
  Future<TournamentStage> updateStage(TournamentStage stage);

  /// الحصول على جميع المباريات في مرحلة
  Future<List<Match>> getStageMatches(String tournamentId, String stageId);

  /// الحصول على مباراة محددة
  Future<Match?> getMatchById(String tournamentId, String matchId);

  /// إنشاء مباراة جديدة
  Future<Match> createMatch(Match match);

  /// تحديث مباراة
  Future<Match> updateMatch(Match match);

  /// الحصول على bracket البطولة
  Future<TournamentBracket?> getTournamentBracket(String tournamentId);

  /// حفظ bracket
  Future<void> saveBracket(TournamentBracket bracket);

  /// تحديث نتيجة مباراة
  Future<void> updateMatchResult(String tournamentId, String matchId, Match match);

  /// بدء مرحلة
  Future<void> startStage(String tournamentId, String stageId);

  /// إكمال مرحلة
  Future<void> completeStage(String tournamentId, String stageId);

  /// بدء بطولة
  Future<void> startTournament(String tournamentId);

  /// إكمال بطولة
  Future<void> completeTournament(String tournamentId);
}

