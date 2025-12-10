import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/tournament_stage.dart';
import '../../domain/entities/bracket.dart';
import '../../../../core/constants/app_constants.dart';

/// Service للاتصال بـ Cloudflare backend للمسابقات
class TournamentService {
  final String baseUrl;

  TournamentService({String? baseUrl})
      : baseUrl = baseUrl ?? AppConstants.tournamentApiUrl;

  /// الحصول على جميع البطولات
  Future<List<Tournament>> fetchTournaments({
    TournamentStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) {
        queryParams['status'] = status.name;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final uri = Uri.parse('$baseUrl/api/tournaments').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final tournaments = (data['tournaments'] as List)
            .map((t) => _tournamentFromJson(t as Map<String, dynamic>))
            .toList();
        return tournaments;
      } else {
        throw Exception('Failed to fetch tournaments: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTournaments: $e');
      rethrow;
    }
  }

  /// الحصول على بطولة محددة
  Future<Tournament?> fetchTournament(String tournamentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _tournamentFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTournament: $e');
      rethrow;
    }
  }

  /// إنشاء بطولة جديدة
  Future<Tournament> createTournament(Tournament tournament) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_tournamentToJson(tournament)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _tournamentFromJson(data);
      } else {
        throw Exception('Failed to create tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in createTournament: $e');
      rethrow;
    }
  }

  /// تحديث بطولة
  Future<Tournament> updateTournament(Tournament tournament) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tournaments/${tournament.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_tournamentToJson(tournament)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _tournamentFromJson(data);
      } else {
        throw Exception('Failed to update tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updateTournament: $e');
      rethrow;
    }
  }

  /// حذف بطولة
  Future<void> deleteTournament(String tournamentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in deleteTournament: $e');
      rethrow;
    }
  }

  /// تسجيل فريق في بطولة
  Future<void> registerTeam(String tournamentId, Team team) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/teams'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_teamToJson(team)),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to register team: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in registerTeam: $e');
      rethrow;
    }
  }

  /// إلغاء تسجيل فريق
  Future<void> unregisterTeam(String tournamentId, String teamId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/teams/$teamId'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to unregister team: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in unregisterTeam: $e');
      rethrow;
    }
  }

  /// الحصول على جميع الفرق في بطولة
  Future<List<Team>> fetchTournamentTeams(String tournamentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/teams'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final teams = (data['teams'] as List)
            .map((t) => _teamFromJson(t as Map<String, dynamic>))
            .toList();
        return teams;
      } else {
        throw Exception('Failed to fetch teams: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTournamentTeams: $e');
      rethrow;
    }
  }

  /// الحصول على فريق محدد
  Future<Team?> fetchTeam(String tournamentId, String teamId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/teams/$teamId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _teamFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch team: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTeam: $e');
      rethrow;
    }
  }

  /// الحصول على جميع المراحل في بطولة
  Future<List<TournamentStage>> fetchTournamentStages(String tournamentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/stages'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final stages = (data['stages'] as List)
            .map((s) => _stageFromJson(s as Map<String, dynamic>))
            .toList();
        return stages;
      } else {
        throw Exception('Failed to fetch stages: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchTournamentStages: $e');
      rethrow;
    }
  }

  /// الحصول على مرحلة محددة
  Future<TournamentStage?> fetchStage(String tournamentId, String stageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/stages/$stageId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _stageFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch stage: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchStage: $e');
      rethrow;
    }
  }

  /// إنشاء مرحلة جديدة
  Future<TournamentStage> createStage(TournamentStage stage) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/${stage.tournamentId}/stages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_stageToJson(stage)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _stageFromJson(data);
      } else {
        throw Exception('Failed to create stage: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in createStage: $e');
      rethrow;
    }
  }

  /// تحديث مرحلة
  Future<TournamentStage> updateStage(TournamentStage stage) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tournaments/${stage.tournamentId}/stages/${stage.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_stageToJson(stage)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _stageFromJson(data);
      } else {
        throw Exception('Failed to update stage: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updateStage: $e');
      rethrow;
    }
  }

  /// الحصول على جميع المباريات في مرحلة
  Future<List<Match>> fetchStageMatches(String tournamentId, String stageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/stages/$stageId/matches'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final matches = (data['matches'] as List)
            .map((m) => _matchFromJson(m as Map<String, dynamic>))
            .toList();
        return matches;
      } else {
        throw Exception('Failed to fetch matches: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchStageMatches: $e');
      rethrow;
    }
  }

  /// الحصول على مباراة محددة
  Future<Match?> fetchMatch(String tournamentId, String matchId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/matches/$matchId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _matchFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch match: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchMatch: $e');
      rethrow;
    }
  }

  /// بدء مباراة
  Future<Match> startMatch(String tournamentId, String matchId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/matches/$matchId/start'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _matchFromJson(data);
      } else {
        throw Exception('Failed to start match: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in startMatch: $e');
      rethrow;
    }
  }

  /// إنشاء مباراة جديدة
  Future<Match> createMatch(Match match) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/${match.tournamentId}/matches'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_matchToJson(match)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _matchFromJson(data);
      } else {
        throw Exception('Failed to create match: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in createMatch: $e');
      rethrow;
    }
  }

  /// تحديث مباراة
  Future<Match> updateMatch(Match match) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tournaments/${match.tournamentId}/matches/${match.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_matchToJson(match)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _matchFromJson(data);
      } else {
        throw Exception('Failed to update match: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updateMatch: $e');
      rethrow;
    }
  }

  /// الحصول على bracket البطولة
  Future<TournamentBracket?> fetchBracket(String tournamentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/bracket'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _bracketFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch bracket: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchBracket: $e');
      rethrow;
    }
  }

  /// حفظ bracket
  Future<void> saveBracket(TournamentBracket bracket) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tournaments/${bracket.tournamentId}/bracket'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_bracketToJson(bracket)),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to save bracket: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in saveBracket: $e');
      rethrow;
    }
  }

  /// تحديث نتيجة مباراة
  Future<void> updateMatchResult(String tournamentId, String matchId, Match match) async {
    await updateMatch(match);
  }

  /// بدء مرحلة
  Future<void> startStage(String tournamentId, String stageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/stages/$stageId/start'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to start stage: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in startStage: $e');
      rethrow;
    }
  }

  /// إكمال مرحلة
  Future<void> completeStage(String tournamentId, String stageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/stages/$stageId/complete'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to complete stage: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in completeStage: $e');
      rethrow;
    }
  }

  /// بدء بطولة
  Future<void> startTournament(String tournamentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/start'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to start tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in startTournament: $e');
      rethrow;
    }
  }

  /// إكمال بطولة
  Future<void> completeTournament(String tournamentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tournaments/$tournamentId/complete'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to complete tournament: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in completeTournament: $e');
      rethrow;
    }
  }

  // JSON Serialization Helpers
  Map<String, dynamic> _tournamentToJson(Tournament tournament) {
    return {
      'id': tournament.id,
      'name': tournament.name,
      'description': tournament.description,
      'type': tournament.type.name,
      'status': tournament.status.name,
      'startDate': tournament.startDate.toIso8601String(),
      'endDate': tournament.endDate.toIso8601String(),
      'registrationStartDate': tournament.registrationStartDate.toIso8601String(),
      'registrationEndDate': tournament.registrationEndDate.toIso8601String(),
      'maxTeams': tournament.maxTeams,
      'currentTeams': tournament.currentTeams,
      'settings': {
        'maxTeams': tournament.settings.maxTeams,
        'minTeamsPerMatch': tournament.settings.minTeamsPerMatch,
        'maxTeamsPerMatch': tournament.settings.maxTeamsPerMatch,
        'matchDuration': tournament.settings.matchDuration.inSeconds,
        'breakBetweenMatches': tournament.settings.breakBetweenMatches.inSeconds,
        'allowRescheduling': tournament.settings.allowRescheduling,
        'reschedulingDeadlineHours': tournament.settings.reschedulingDeadlineHours,
        'autoForfeitEnabled': tournament.settings.autoForfeitEnabled,
        'autoForfeitMinutes': tournament.settings.autoForfeitMinutes,
      },
      'prizePool': tournament.prizePool,
      'organizerId': tournament.organizerId,
      'metadata': tournament.metadata,
    };
  }

  Tournament _tournamentFromJson(Map<String, dynamic> json) {
    // TODO: Implement full deserialization
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: TournamentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TournamentType.singleElimination,
      ),
      status: TournamentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TournamentStatus.registration,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      registrationStartDate: DateTime.parse(json['registrationStartDate'] as String),
      registrationEndDate: DateTime.parse(json['registrationEndDate'] as String),
      maxTeams: json['maxTeams'] as int,
      currentTeams: json['currentTeams'] as int? ?? 0,
      settings: TournamentSettings(
        maxTeams: json['settings']['maxTeams'] as int,
        minTeamsPerMatch: json['settings']['minTeamsPerMatch'] as int? ?? 2,
        maxTeamsPerMatch: json['settings']['maxTeamsPerMatch'] as int? ?? 2,
        matchDuration: Duration(seconds: json['settings']['matchDuration'] as int? ?? 1800),
        breakBetweenMatches: Duration(seconds: json['settings']['breakBetweenMatches'] as int? ?? 300),
        allowRescheduling: json['settings']['allowRescheduling'] as bool? ?? true,
        reschedulingDeadlineHours: json['settings']['reschedulingDeadlineHours'] as int? ?? 24,
        autoForfeitEnabled: json['settings']['autoForfeitEnabled'] as bool? ?? true,
        autoForfeitMinutes: json['settings']['autoForfeitMinutes'] as int? ?? 15,
      ),
      prizePool: json['prizePool'] as String?,
      organizerId: json['organizerId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> _teamToJson(Team team) {
    return {
      'id': team.id,
      'name': team.name,
      'captainId': team.captainId,
      'memberIds': team.memberIds,
      'timeZone': team.timeZone,
      'preferredTimeSlots': team.preferredTimeSlots.map((t) => t.toIso8601String()).toList(),
      'stats': {
        'matchesPlayed': team.stats.matchesPlayed,
        'matchesWon': team.stats.matchesWon,
        'matchesLost': team.stats.matchesLost,
        'totalScore': team.stats.totalScore,
        'winRate': team.stats.winRate,
        'currentStreak': team.stats.currentStreak,
        'isWinningStreak': team.stats.isWinningStreak,
      },
      'seed': team.seed,
      'avatarUrl': team.avatarUrl,
      'countryCode': team.countryCode,
      'registeredAt': team.registeredAt.toIso8601String(),
    };
  }

  Team _teamFromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      captainId: json['captainId'] as String,
      memberIds: (json['memberIds'] as List).cast<String>(),
      timeZone: json['timeZone'] as String,
      preferredTimeSlots: (json['preferredTimeSlots'] as List?)
              ?.map((t) => DateTime.parse(t as String))
              .toList() ??
          [],
      stats: TeamStats(
        matchesPlayed: json['stats']?['matchesPlayed'] as int? ?? 0,
        matchesWon: json['stats']?['matchesWon'] as int? ?? 0,
        matchesLost: json['stats']?['matchesLost'] as int? ?? 0,
        totalScore: json['stats']?['totalScore'] as int? ?? 0,
        winRate: (json['stats']?['winRate'] as num?)?.toDouble() ?? 0.0,
        currentStreak: json['stats']?['currentStreak'] as int? ?? 0,
        isWinningStreak: json['stats']?['isWinningStreak'] as bool? ?? true,
      ),
      seed: json['seed'] as int?,
      avatarUrl: json['avatarUrl'] as String?,
      countryCode: json['countryCode'] as String?,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> _stageToJson(TournamentStage stage) {
    return {
      'id': stage.id,
      'tournamentId': stage.tournamentId,
      'name': stage.name,
      'type': stage.type.name,
      'status': stage.status.name,
      'roundNumber': stage.roundNumber,
      'totalRounds': stage.totalRounds,
      'matches': stage.matches.map((m) => _matchToJson(m)).toList(),
      'startDate': stage.startDate.toIso8601String(),
      'endDate': stage.endDate.toIso8601String(),
      'format': stage.format.name,
      'teamsAdvancing': stage.teamsAdvancing,
    };
  }

  TournamentStage _stageFromJson(Map<String, dynamic> json) {
    return TournamentStage(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      name: json['name'] as String,
      type: StageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StageType.qualifier,
      ),
      status: StageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StageStatus.notStarted,
      ),
      roundNumber: json['roundNumber'] as int,
      totalRounds: json['totalRounds'] as int,
      matches: (json['matches'] as List?)
              ?.map((m) => _matchFromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      format: MatchFormat.values.firstWhere(
        (e) => e.name == json['format'],
        orElse: () => MatchFormat.bestOf3,
      ),
      teamsAdvancing: json['teamsAdvancing'] as int?,
    );
  }

  Map<String, dynamic> _matchToJson(Match match) {
    return {
      'id': match.id,
      'tournamentId': match.tournamentId,
      'stageId': match.stageId,
      'team1': _teamToJson(match.team1),
      'team2': _teamToJson(match.team2),
      'status': match.status.name,
      'scheduledTime': match.scheduledTime.toIso8601String(),
      'startTime': match.startTime?.toIso8601String(),
      'endTime': match.endTime?.toIso8601String(),
      'gameResults': match.gameResults.map((r) => {
            'gameNumber': r.gameNumber,
            'winnerTeamId': r.winnerTeamId,
            'team1Score': r.team1Score,
            'team2Score': r.team2Score,
            'duration': r.duration.inSeconds,
            'completedAt': r.completedAt.toIso8601String(),
          }).toList(),
      'winner': match.winner != null ? _teamToJson(match.winner!) : null,
      'format': match.format.name,
      'roomId': match.roomId,
      'timeZone': match.timeZone,
      'preferredTimeSlots': match.preferredTimeSlots?.map((t) => t.toIso8601String()).toList(),
      'isRescheduled': match.isRescheduled,
      'rescheduleReason': match.rescheduleReason,
    };
  }

  Match _matchFromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      stageId: json['stageId'] as String,
      team1: _teamFromJson(json['team1'] as Map<String, dynamic>),
      team2: _teamFromJson(json['team2'] as Map<String, dynamic>),
      status: MatchStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MatchStatus.scheduled,
      ),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      gameResults: (json['gameResults'] as List?)
              ?.map((r) => GameResult(
                    gameNumber: r['gameNumber'] as int,
                    winnerTeamId: r['winnerTeamId'] as String?,
                    team1Score: r['team1Score'] as int,
                    team2Score: r['team2Score'] as int,
                    duration: Duration(seconds: r['duration'] as int),
                    completedAt: DateTime.parse(r['completedAt'] as String),
                  ))
              .toList() ??
          [],
      winner: json['winner'] != null ? _teamFromJson(json['winner'] as Map<String, dynamic>) : null,
      format: MatchFormat.values.firstWhere(
        (e) => e.name == json['format'],
        orElse: () => MatchFormat.bestOf3,
      ),
      roomId: json['roomId'] as String?,
      timeZone: json['timeZone'] as String?,
      preferredTimeSlots: (json['preferredTimeSlots'] as List?)
          ?.map((t) => DateTime.parse(t as String))
          .toList(),
      isRescheduled: json['isRescheduled'] as bool? ?? false,
      rescheduleReason: json['rescheduleReason'] as String?,
    );
  }

  Map<String, dynamic> _bracketToJson(TournamentBracket bracket) {
    // TODO: Implement full bracket serialization
    return {
      'id': bracket.id,
      'tournamentId': bracket.tournamentId,
      'type': bracket.type.name,
      'totalRounds': bracket.totalRounds,
    };
  }

  TournamentBracket _bracketFromJson(Map<String, dynamic> json) {
    // TODO: Implement full bracket deserialization
    throw UnimplementedError('Bracket deserialization not yet implemented');
  }
}

