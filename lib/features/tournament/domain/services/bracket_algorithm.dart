import '../entities/bracket.dart';
import '../entities/team.dart';
import '../entities/match.dart';
import '../entities/tournament_stage.dart';

/// Abstract class لخوارزميات الـ Bracket
abstract class BracketAlgorithm {
  /// إنشاء bracket جديد
  TournamentBracket createBracket({
    required String tournamentId,
    required List<Team> teams,
    required BracketType type,
  });

  /// تحديث bracket بعد مباراة
  TournamentBracket updateBracket({
    required TournamentBracket bracket,
    required Match completedMatch,
  });

  /// الحصول على المباريات التالية
  List<Match> getNextMatches(TournamentBracket bracket);

  /// التحقق من اكتمال الجولة
  bool isRoundComplete(TournamentBracket bracket, int round);
}

/// Single Elimination Bracket Algorithm
class SingleEliminationBracketAlgorithm implements BracketAlgorithm {
  @override
  TournamentBracket createBracket({
    required String tournamentId,
    required List<Team> teams,
    required BracketType type,
  }) {
    if (teams.length < 2) {
      throw ArgumentError('Need at least 2 teams for bracket');
    }

    // حساب عدد الجولات
    final totalRounds = (teams.length - 1).bitLength;
    
    // إنشاء شجرة الـ bracket
    final rounds = <List<BracketNode>>[];
    final matches = <String, Match>{};
    
    // الجولة الأولى: جميع الفرق
    final firstRound = <BracketNode>[];
    for (int i = 0; i < teams.length; i += 2) {
      if (i + 1 < teams.length) {
        // مباراة بين فريقين
        final match = Match(
          id: 'match_${tournamentId}_r1_${i ~/ 2}',
          tournamentId: tournamentId,
          stageId: 'stage_1',
          team1: teams[i],
          team2: teams[i + 1],
          scheduledTime: DateTime.now(),
          format: MatchFormat.bestOf3,
        );
        
        matches[match.id] = match;
        
        final node = BracketNode(
          id: 'node_r1_${i ~/ 2}',
          matchId: match.id,
          round: 1,
          position: i ~/ 2,
        );
        
        firstRound.add(node);
      } else {
        // فريق واحد فقط (Bye - تلقائياً للجولة التالية)
        final node = BracketNode(
          id: 'node_r1_${i ~/ 2}',
          team: teams[i],
          round: 1,
          position: i ~/ 2,
        );
        firstRound.add(node);
      }
    }
    
    rounds.add(firstRound);
    
    // إنشاء الجولات التالية
    var currentRoundTeams = firstRound.length;
    for (int round = 2; round <= totalRounds; round++) {
      final roundNodes = <BracketNode>[];
      final teamsInRound = (currentRoundTeams / 2).ceil();
      
      for (int i = 0; i < teamsInRound; i++) {
        final match = Match(
          id: 'match_${tournamentId}_r${round}_$i',
          tournamentId: tournamentId,
          stageId: 'stage_$round',
          team1: teams[0], // TODO: سيتم تحديثه بعد اكتمال الجولة السابقة
          team2: teams[1], // TODO: سيتم تحديثه بعد اكتمال الجولة السابقة
          scheduledTime: DateTime.now(),
          format: round == totalRounds ? MatchFormat.bestOf7 : MatchFormat.bestOf5,
        );
        
        matches[match.id] = match;
        
        final node = BracketNode(
          id: 'node_r${round}_$i',
          matchId: match.id,
          round: round,
          position: i,
        );
        
        roundNodes.add(node);
      }
      
      rounds.add(roundNodes);
      currentRoundTeams = teamsInRound;
    }
    
    // الجذر (النهائي)
    final root = rounds.last.first;
    
    return TournamentBracket(
      id: 'bracket_$tournamentId',
      tournamentId: tournamentId,
      type: type,
      root: root,
      rounds: rounds,
      matches: matches,
      totalRounds: totalRounds,
    );
  }

  @override
  TournamentBracket updateBracket({
    required TournamentBracket bracket,
    required Match completedMatch,
  }) {
    // TODO: تحديث bracket بعد اكتمال مباراة
    // نقل الفائز إلى الجولة التالية
    return bracket;
  }

  @override
  List<Match> getNextMatches(TournamentBracket bracket) {
    // TODO: الحصول على المباريات التالية الجاهزة
    return [];
  }

  @override
  bool isRoundComplete(TournamentBracket bracket, int round) {
    if (round < 1 || round > bracket.rounds.length) return false;
    final roundMatches = bracket.getMatchesForRound(round);
    return roundMatches.every((match) => match.isCompleted);
  }
}

/// Double Elimination Bracket Algorithm
class DoubleEliminationBracketAlgorithm implements BracketAlgorithm {
  @override
  TournamentBracket createBracket({
    required String tournamentId,
    required List<Team> teams,
    required BracketType type,
  }) {
    // TODO: تنفيذ Double Elimination
    throw UnimplementedError('Double Elimination not yet implemented');
  }

  @override
  TournamentBracket updateBracket({
    required TournamentBracket bracket,
    required Match completedMatch,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Match> getNextMatches(TournamentBracket bracket) {
    throw UnimplementedError();
  }

  @override
  bool isRoundComplete(TournamentBracket bracket, int round) {
    throw UnimplementedError();
  }
}

/// Swiss System Bracket Algorithm
class SwissSystemBracketAlgorithm implements BracketAlgorithm {
  @override
  TournamentBracket createBracket({
    required String tournamentId,
    required List<Team> teams,
    required BracketType type,
  }) {
    // TODO: تنفيذ Swiss System
    throw UnimplementedError('Swiss System not yet implemented');
  }

  @override
  TournamentBracket updateBracket({
    required TournamentBracket bracket,
    required Match completedMatch,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Match> getNextMatches(TournamentBracket bracket) {
    throw UnimplementedError();
  }

  @override
  bool isRoundComplete(TournamentBracket bracket, int round) {
    throw UnimplementedError();
  }
}

/// Round-Robin Bracket Algorithm
class RoundRobinBracketAlgorithm implements BracketAlgorithm {
  @override
  TournamentBracket createBracket({
    required String tournamentId,
    required List<Team> teams,
    required BracketType type,
  }) {
    // TODO: تنفيذ Round-Robin
    throw UnimplementedError('Round-Robin not yet implemented');
  }

  @override
  TournamentBracket updateBracket({
    required TournamentBracket bracket,
    required Match completedMatch,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Match> getNextMatches(TournamentBracket bracket) {
    throw UnimplementedError();
  }

  @override
  bool isRoundComplete(TournamentBracket bracket, int round) {
    throw UnimplementedError();
  }
}

