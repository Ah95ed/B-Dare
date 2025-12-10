import 'package:equatable/equatable.dart';
import 'team.dart';
import 'match.dart';

/// نوع الـ Bracket
enum BracketType {
  singleElimination, // إقصاء فردي
  doubleElimination, // إقصاء مزدوج
  swiss, // نظام سويسري
  roundRobin, // دوري دائري
}

/// عقدة في الـ Bracket (تمثل مباراة أو فريق)
class BracketNode extends Equatable {
  final String id;
  final String? matchId; // ID المباراة (إذا كانت عقدة مباراة)
  final Team? team; // الفريق (إذا كانت عقدة فريق)
  final BracketNode? parent; // العقدة الأم
  final BracketNode? leftChild; // العقدة اليسرى (الفريق 1)
  final BracketNode? rightChild; // العقدة اليمنى (الفريق 2)
  final int round; // رقم الجولة
  final int position; // الموضع في الجولة

  const BracketNode({
    required this.id,
    this.matchId,
    this.team,
    this.parent,
    this.leftChild,
    this.rightChild,
    required this.round,
    required this.position,
  });

  bool get isLeaf => leftChild == null && rightChild == null;
  bool get isMatch => matchId != null;
  bool get isTeam => team != null;

  @override
  List<Object?> get props => [
        id,
        matchId,
        team,
        parent,
        leftChild,
        rightChild,
        round,
        position,
      ];
}

/// الـ Bracket (شجرة التصفيات)
class TournamentBracket extends Equatable {
  final String id;
  final String tournamentId;
  final BracketType type;
  final BracketNode root; // الجذر (النهائي)
  final List<List<BracketNode>> rounds; // الجولات (كل جولة = قائمة عقد)
  final Map<String, Match> matches; // جميع المباريات
  final int totalRounds; // إجمالي الجولات

  const TournamentBracket({
    required this.id,
    required this.tournamentId,
    required this.type,
    required this.root,
    required this.rounds,
    required this.matches,
    required this.totalRounds,
  });

  /// الحصول على جميع المباريات في جولة معينة
  List<Match> getMatchesForRound(int round) {
    if (round < 1 || round > rounds.length) return [];
    final roundNodes = rounds[round - 1];
    return roundNodes
        .where((node) => node.matchId != null)
        .map((node) => matches[node.matchId!]!)
        .toList();
  }

  /// الحصول على الفائز النهائي
  Team? get winner {
    if (root.team != null) return root.team;
    if (root.matchId != null) {
      final finalMatch = matches[root.matchId];
      return finalMatch?.winner;
    }
    return null;
  }

  /// الحصول على عدد الفرق المتبقية
  int get remainingTeams {
    return rounds.last
        .where((node) => node.team != null || (node.matchId != null && matches[node.matchId]?.winner != null))
        .length;
  }

  @override
  List<Object?> get props => [
        id,
        tournamentId,
        type,
        root,
        rounds,
        matches,
        totalRounds,
      ];
}

