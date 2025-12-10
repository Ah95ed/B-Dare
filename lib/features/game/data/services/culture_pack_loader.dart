import 'package:flutter/services.dart' show rootBundle;

class CulturePackEntry {
  final String start;
  final String end;
  final List<String> pathNodes;
  final String? category;
  final String locale;

  CulturePackEntry({
    required this.start,
    required this.end,
    required this.pathNodes,
    required this.locale,
    this.category,
  });
}

class CulturePackLoader {
  Future<List<CulturePackEntry>> loadFromAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return _parseCsv(raw);
  }

  List<CulturePackEntry> _parseCsv(String raw) {
    final lines = raw.split('\n');
    final entries = <CulturePackEntry>[];
    for (final line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split(',');
      if (parts.length < 4) continue;
      final start = parts[0].trim();
      final end = parts[1].trim();
      final pathNodes =
          parts[2].split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final locale = parts[3].trim().isEmpty ? 'ar' : parts[3].trim();
      final category = parts.length > 4 ? parts[4].trim() : null;
      entries.add(
        CulturePackEntry(
          start: start,
          end: end,
          pathNodes: pathNodes,
          locale: locale,
          category: category?.isEmpty == true ? null : category,
        ),
      );
    }
    return entries;
  }
}
