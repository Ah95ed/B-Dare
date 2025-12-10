import 'package:flutter/foundation.dart';
import '../../domain/repositories/tournament_repository_interface.dart';
import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/entities/bracket.dart';
import '../services/tournament_service.dart';

/// Tournament Repository Implementation
/// يستخدم Cloudflare backend للبيانات
class TournamentRepository implements TournamentRepositoryInterface {
  final TournamentService _service;

  TournamentRepository({TournamentService? service})
      : _service = service ?? TournamentService();

  @override
  Future<List<Tournament>> getAllTournaments({
    TournamentStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _service.fetchTournaments(
        status: status,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      debugPrint('Error fetching tournaments: $e');
      return [];
    }
  }

  @override
  Future<Tournament?> getTournamentById(String tournamentId) async {
    try {
      return await _service.fetchTournament(tournamentId);
    } catch (e) {
      debugPrint('Error fetching tournament: $e');
      return null;
    }
  }

  @override
  Future<Tournament> createTournament(Tournament tournament) async {
    try {
      return await _service.createTournament(tournament);
    } catch (e) {
      debugPrint('Error creating tournament: $e');
      rethrow;
    }
  }

  @override
  Future<Tournament> updateTournament(Tournament tournament) async {
    try {
      return await _service.updateTournament(tournament);
    } catch (e) {
      debugPrint('Error updating tournament: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTournament(String tournamentId) async {
    try {
      await _service.deleteTournament(tournamentId);
    } catch (e) {
      debugPrint('Error deleting tournament: $e');
      rethrow;
    }
  }

  @override
  Future<void> registerTeam(String tournamentId, Team team) async {
    try {
      await _service.registerTeam(tournamentId, team);
    } catch (e) {
      debugPrint('Error registering team: $e');
      rethrow;
    }
  }

  @override
  Future<void> unregisterTeam(String tournamentId, String teamId) async {
    try {
      await _service.unregisterTeam(tournamentId, teamId);
    } catch (e) {
      debugPrint('Error unregistering team: $e');
      rethrow;
    }
  }

  @override
  Future<List<Team>> getTournamentTeams(String tournamentId) async {
    try {
      return await _service.fetchTournamentTeams(tournamentId);
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      return [];
    }
  }

  @override
  Future<Team?> getTeamById(String tournamentId, String teamId) async {
    try {
      return await _service.fetchTeam(tournamentId, teamId);
    } catch (e) {
      debugPrint('Error fetching team: $e');
      return null;
    }
  }

  @override
  Future<List<TournamentStage>> getTournamentStages(String tournamentId) async {
    try {
      return await _service.fetchTournamentStages(tournamentId);
    } catch (e) {
      debugPrint('Error fetching stages: $e');
      return [];
    }
  }

  @override
  Future<TournamentStage?> getStageById(String tournamentId, String stageId) async {
    try {
      return await _service.fetchStage(tournamentId, stageId);
    } catch (e) {
      debugPrint('Error fetching stage: $e');
      return null;
    }
  }

  @override
  Future<TournamentStage> createStage(TournamentStage stage) async {
    try {
      return await _service.createStage(stage);
    } catch (e) {
      debugPrint('Error creating stage: $e');
      rethrow;
    }
  }

  @override
  Future<TournamentStage> updateStage(TournamentStage stage) async {
    try {
      return await _service.updateStage(stage);
    } catch (e) {
      debugPrint('Error updating stage: $e');
      rethrow;
    }
  }

  @override
  Future<List<Match>> getStageMatches(String tournamentId, String stageId) async {
    try {
      return await _service.fetchStageMatches(tournamentId, stageId);
    } catch (e) {
      debugPrint('Error fetching matches: $e');
      return [];
    }
  }

  @override
  Future<Match?> getMatchById(String tournamentId, String matchId) async {
    try {
      return await _service.fetchMatch(tournamentId, matchId);
    } catch (e) {
      debugPrint('Error fetching match: $e');
      return null;
    }
  }

  @override
  Future<Match> createMatch(Match match) async {
    try {
      return await _service.createMatch(match);
    } catch (e) {
      debugPrint('Error creating match: $e');
      rethrow;
    }
  }

  @override
  Future<Match> updateMatch(Match match) async {
    try {
      return await _service.updateMatch(match);
    } catch (e) {
      debugPrint('Error updating match: $e');
      rethrow;
    }
  }

  @override
  Future<TournamentBracket?> getTournamentBracket(String tournamentId) async {
    try {
      return await _service.fetchBracket(tournamentId);
    } catch (e) {
      debugPrint('Error fetching bracket: $e');
      return null;
    }
  }

  @override
  Future<void> saveBracket(TournamentBracket bracket) async {
    try {
      await _service.saveBracket(bracket);
    } catch (e) {
      debugPrint('Error saving bracket: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMatchResult(String tournamentId, String matchId, Match match) async {
    try {
      await _service.updateMatchResult(tournamentId, matchId, match);
    } catch (e) {
      debugPrint('Error updating match result: $e');
      rethrow;
    }
  }

  @override
  Future<void> startStage(String tournamentId, String stageId) async {
    try {
      await _service.startStage(tournamentId, stageId);
    } catch (e) {
      debugPrint('Error starting stage: $e');
      rethrow;
    }
  }

  @override
  Future<void> completeStage(String tournamentId, String stageId) async {
    try {
      await _service.completeStage(tournamentId, stageId);
    } catch (e) {
      debugPrint('Error completing stage: $e');
      rethrow;
    }
  }

  @override
  Future<void> startTournament(String tournamentId) async {
    try {
      await _service.startTournament(tournamentId);
    } catch (e) {
      debugPrint('Error starting tournament: $e');
      rethrow;
    }
  }

  @override
  Future<void> completeTournament(String tournamentId) async {
    try {
      await _service.completeTournament(tournamentId);
    } catch (e) {
      debugPrint('Error completing tournament: $e');
      rethrow;
    }
  }
}

