import 'dart:convert';
import 'dart:io';

/// Script لترجمة ملف app_en.arb إلى جميع اللغات الجديدة
/// يحافظ على placeholders و ICU syntax و metadata
void main(List<String> args) async {
  if (args.isEmpty) {
    stdout.writeln('Usage: dart tool/translate_arb.dart <target_language_code>');
    stdout.writeln('Example: dart tool/translate_arb.dart zh');
    exit(1);
  }

  final targetLang = args[0];
  final sourceFile = File('lib/l10n/app_en.arb');
  
  if (!await sourceFile.exists()) {
    stdout.writeln('Error: app_en.arb not found');
    exit(1);
  }

  stdout.writeln('Reading app_en.arb...');
  final sourceContent = await sourceFile.readAsString();
  final sourceJson = jsonDecode(sourceContent) as Map<String, dynamic>;

  stdout.writeln('Creating app_$targetLang.arb...');
  final targetJson = <String, dynamic>{};
  
  // Set locale
  targetJson['@@locale'] = targetLang;

  // Translate each key
  for (final entry in sourceJson.entries) {
    final key = entry.key;
    final value = entry.value;

    // Skip @@locale as we set it above
    if (key == '@@locale') continue;

    // Handle metadata objects (starting with @)
    if (key.startsWith('@') && value is Map) {
      targetJson[key] = value; // Keep metadata as-is
      continue;
    }

    // Handle regular string values
    if (value is String) {
      // Check if it contains placeholders or ICU syntax
      if (_hasPlaceholders(value) || _hasICUSyntax(value)) {
        // For now, keep the English text with a note
        // In production, you would use a translation service that preserves placeholders
        targetJson[key] = _translateWithPlaceholders(value, targetLang);
      } else {
        // Simple translation (placeholder for actual translation service)
        targetJson[key] = _translateText(value, targetLang);
      }
    } else {
      // Keep non-string values as-is
      targetJson[key] = value;
    }
  }

  // Write output file
  final outputFile = File('lib/l10n/app_$targetLang.arb');
  const encoder = JsonEncoder.withIndent('  ');
  await outputFile.writeAsString(encoder.convert(targetJson));
  
  stdout.writeln('✅ Created app_$targetLang.arb');
  stdout.writeln('⚠️  Note: This is a template. Please review and update translations.');
}

bool _hasPlaceholders(String text) {
  return text.contains(RegExp(r'\{[a-zA-Z0-9_]+\}'));
}

bool _hasICUSyntax(String text) {
  return text.contains(RegExp(r'\{[^}]+, (plural|select|gender)'));
}

String _translateWithPlaceholders(String text, String targetLang) {
  // Placeholder implementation
  // In production, use a translation service that preserves placeholders
  // For now, return the text with a comment
  return text; // TODO: Translate while preserving placeholders
}

String _translateText(String text, String targetLang) {
  // Placeholder implementation
  // In production, integrate with Google Translate API or similar service
  // For now, return the text with a comment
  return text; // TODO: Translate to $targetLang
}

