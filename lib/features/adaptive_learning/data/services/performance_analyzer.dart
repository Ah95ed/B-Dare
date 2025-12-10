import 'dart:math';

import '../../../game/domain/entities/link_node.dart';
import '../models/performance_sample_model.dart';

class PerformanceAnalyzerResult {
  final double winRate;
  final double perfectRate;
  final double averageLinks;
  final double averageTimePerLink;
  final RepresentationType preferredRepresentation;
  final List<String> strongDomains;
  final List<String> weakDomains;
  final Map<String, double> domainWinRates;

  const PerformanceAnalyzerResult({
    required this.winRate,
    required this.perfectRate,
    required this.averageLinks,
    required this.averageTimePerLink,
    required this.preferredRepresentation,
    required this.strongDomains,
    required this.weakDomains,
    required this.domainWinRates,
  });
}

class PerformanceAnalyzer {
  PerformanceAnalyzerResult analyze(List<PerformanceSampleModel> samples) {
    if (samples.isEmpty) {
      return const PerformanceAnalyzerResult(
        winRate: 0.0,
        perfectRate: 0.0,
        averageLinks: 0.0,
        averageTimePerLink: 0.0,
        preferredRepresentation: RepresentationType.text,
        strongDomains: [],
        weakDomains: [],
        domainWinRates: {},
      );
    }

    final total = samples.length;
    final wins = samples.where((s) => s.isWin).length;
    final perfects = samples.where((s) => s.isPerfect).length;
    final totalLinks =
        samples.fold<int>(0, (sum, item) => sum + max(1, item.linksCount));
    final totalSeconds =
        samples.fold<int>(0, (sum, item) => sum + item.timeSpent.inSeconds);

    final domainAttempts = <String, int>{};
    final domainWins = <String, int>{};
    final representationAttempts = <RepresentationType, int>{};
    final representationWins = <RepresentationType, int>{};

    for (final sample in samples) {
      final category = sample.category ?? 'General';
      domainAttempts[category] = (domainAttempts[category] ?? 0) + 1;
      if (sample.isWin) {
        domainWins[category] = (domainWins[category] ?? 0) + 1;
      }

      representationAttempts[sample.representationType] =
          (representationAttempts[sample.representationType] ?? 0) + 1;
      if (sample.isWin) {
        representationWins[sample.representationType] =
            (representationWins[sample.representationType] ?? 0) + 1;
      }
    }

    RepresentationType preferredRepresentation = RepresentationType.text;
    double bestRepresentationScore = -1.0;

    for (final type in representationAttempts.keys) {
      final attempts = representationAttempts[type]!;
      final winsForType = representationWins[type] ?? 0;
      final rate = attempts == 0 ? 0.0 : winsForType / attempts;
      if (rate > bestRepresentationScore) {
        bestRepresentationScore = rate;
        preferredRepresentation = type;
      }
    }

    final domainWinRates = <String, double>{};
    domainAttempts.forEach((domain, attempts) {
      final winsForDomain = domainWins[domain] ?? 0;
      domainWinRates[domain] =
          attempts == 0 ? 0.0 : winsForDomain / attempts.toDouble();
    });

    final sortedDomains = domainWinRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final strongDomains = sortedDomains
        .where((entry) => entry.value >= 0.6)
        .map((e) => e.key)
        .take(3)
        .toList();
    final weakDomains = sortedDomains
        .where((entry) => entry.value <= 0.4)
        .map((e) => e.key)
        .take(3)
        .toList();

    return PerformanceAnalyzerResult(
      winRate: total == 0 ? 0.0 : wins / total,
      perfectRate: total == 0 ? 0.0 : perfects / total,
      averageLinks: total == 0 ? 0.0 : totalLinks / total,
      averageTimePerLink:
          totalLinks == 0 ? 0.0 : totalSeconds / totalLinks.toDouble(),
      preferredRepresentation: preferredRepresentation,
      strongDomains: strongDomains,
      weakDomains: weakDomains,
      domainWinRates: domainWinRates,
    );
  }
}
