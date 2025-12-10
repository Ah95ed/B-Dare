class PhaseDefinition {
  final String id;
  final String title;
  final String description;
  final int maxLinks;
  final int requiredWins;
  final int requiredPerfectWins;
  final int requiredStreak;

  const PhaseDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.maxLinks,
    required this.requiredWins,
    required this.requiredPerfectWins,
    required this.requiredStreak,
  });
}

class ProgressionConstants {
  static const int baseXpPerLevel = 500;
  static const int xpGrowthPerLevel = 150;
  static const int maxDailyLinks = 7;
  static const int minDailyLinks = 4;

  static const List<PhaseDefinition> phases = [
    PhaseDefinition(
      id: 'phase1',
      title: 'Foundations',
      description: 'Two strong links between start and end.',
      maxLinks: 4,
      requiredWins: 3,
      requiredPerfectWins: 0,
      requiredStreak: 3,
    ),
    PhaseDefinition(
      id: 'phase2',
      title: 'Growth',
      description: 'Expand to mid-sized chains with mixed representations.',
      maxLinks: 8,
      requiredWins: 5,
      requiredPerfectWins: 0,
      requiredStreak: 0,
    ),
    PhaseDefinition(
      id: 'phase3',
      title: 'Mastery',
      description: 'Tackle twelve links and prove precision.',
      maxLinks: 12,
      requiredWins: 7,
      requiredPerfectWins: 1,
      requiredStreak: 0,
    ),
    PhaseDefinition(
      id: 'phase4',
      title: 'Elite',
      description: 'Unlock the full chain of twenty links.',
      maxLinks: 20,
      requiredWins: 10,
      requiredPerfectWins: 2,
      requiredStreak: 0,
    ),
  ];

  static PhaseDefinition phaseForLinks(int links) {
    return phases.firstWhere(
      (phase) => links <= phase.maxLinks,
      orElse: () => phases.last,
    );
  }

  static PhaseDefinition phaseByIndex(int index) {
    if (index < 0) return phases.first;
    if (index >= phases.length) return phases.last;
    return phases[index];
  }

  static int xpNeededForNextLevel(int level) {
    if (level <= 1) {
      return baseXpPerLevel;
    }
    return baseXpPerLevel + ((level - 1) * xpGrowthPerLevel);
  }

  static int calculateXp({
    required int score,
    required Duration timeSpent,
    required int linksCount,
    required bool isPerfect,
    bool isDaily = false,
    bool isWin = true,
  }) {
    final scoreXp = (score / 10).round();
    final speedBonus = timeSpent.inSeconds > 0
        ? (linksCount * 50 ~/ (timeSpent.inSeconds.clamp(1, 300)))
        : 0;
    final perfectBonus = isPerfect ? 120 : 0;
    final dailyBonus = isDaily ? 200 : 0;
    final completionBonus = isWin ? 150 : 50;

    final total = [
      scoreXp,
      speedBonus,
      perfectBonus,
      dailyBonus,
      completionBonus,
    ].fold<int>(0, (previous, element) => previous + element);

    if (total < 50) {
      return 50;
    }
    if (total > 2000) {
      return 2000;
    }
    return total;
  }
}
