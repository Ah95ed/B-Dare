import 'dart:convert';
import 'dart:io';

/// Script لإضافة gameType: "mysteryLink" لجميع puzzles الموجودة
/// للحفاظ على backward compatibility
void main() async {
  final puzzlesFile = File('assets/data/puzzles.json');

  if (!await puzzlesFile.exists()) {
    stdout.writeln('Error: puzzles.json not found');
    exit(1);
  }

  stdout.writeln('Reading puzzles.json...');
  final content = await puzzlesFile.readAsString();
  final List<dynamic> puzzles = jsonDecode(content);

  stdout.writeln('Found ${puzzles.length} puzzles');
  stdout.writeln('Adding gameType field to existing puzzles...');

  int updated = 0;
  for (final puzzle in puzzles) {
    if (puzzle is Map<String, dynamic>) {
      // إضافة gameType فقط إذا لم يكن موجوداً
      if (!puzzle.containsKey('gameType')) {
        puzzle['gameType'] = 'mysteryLink';
        updated++;
      }
    }
  }

  stdout.writeln('Updated $updated puzzles');

  // كتابة الملف المحدث
  final updatedContent = const JsonEncoder.withIndent('  ').convert(puzzles);
  await puzzlesFile.writeAsString(updatedContent);

  stdout.writeln('✅ Migration completed!');
  stdout.writeln('All puzzles now have gameType field (default: mysteryLink)');
}
