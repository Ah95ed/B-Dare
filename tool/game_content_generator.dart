import 'dart:convert';
import 'dart:io';

/// Script لتوليد محتوى تلقائي للأنماط المختلفة
/// يمكن استخدامه لإضافة puzzles جديدة بسرعة
void main() async {
  print('Game Content Generator');
  print('=====================\n');

  final puzzlesFile = File('assets/data/puzzles.json');
  
  if (!await puzzlesFile.exists()) {
    print('Error: puzzles.json not found');
    exit(1);
  }

  print('Reading existing puzzles...');
  final content = await puzzlesFile.readAsString();
  final List<dynamic> existingPuzzles = jsonDecode(content);

  print('Found ${existingPuzzles.length} existing puzzles\n');

  // توليد puzzles جديدة لكل نمط
  final newPuzzles = <Map<String, dynamic>>[];

  // Memory Flip puzzles
  newPuzzles.addAll(_generateMemoryFlipPuzzles(10));
  
  // Spot the Odd puzzles
  newPuzzles.addAll(_generateSpotTheOddPuzzles(10));
  
  // Sort & Solve puzzles
  newPuzzles.addAll(_generateSortSolvePuzzles(10));
  
  // Story Tiles puzzles
  newPuzzles.addAll(_generateStoryTilesPuzzles(10));
  
  // Shadow Match puzzles
  newPuzzles.addAll(_generateShadowMatchPuzzles(10));
  
  // Emoji Circuit puzzles
  newPuzzles.addAll(_generateEmojiCircuitPuzzles(10));
  
  // Cipher Tiles puzzles
  newPuzzles.addAll(_generateCipherTilesPuzzles(10));
  
  // Spot the Change puzzles
  newPuzzles.addAll(_generateSpotTheChangePuzzles(10));
  
  // Color Harmony puzzles
  newPuzzles.addAll(_generateColorHarmonyPuzzles(10));
  
  // Puzzle Sentence puzzles
  newPuzzles.addAll(_generatePuzzleSentencePuzzles(10));

  print('Generated ${newPuzzles.length} new puzzles');

  // دمج مع puzzles الموجودة
  final allPuzzles = [...existingPuzzles, ...newPuzzles];

  // كتابة الملف المحدث
  final updatedContent = const JsonEncoder.withIndent('  ').convert(allPuzzles);
  await puzzlesFile.writeAsString(updatedContent);

  print('\n✅ Content generation completed!');
  print('Total puzzles: ${allPuzzles.length}');
  print('New puzzles added: ${newPuzzles.length}');
}

List<Map<String, dynamic>> _generateMemoryFlipPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final categories = ['General Knowledge', 'Science & Technology', 'Nature & Environment'];
  final pairs = [
    ['Apple', 'تفاحة'], ['Orange', 'برتقالة'], ['Banana', 'موزة'],
    ['Cat', 'قطة'], ['Dog', 'كلب'], ['Bird', 'طائر'],
    ['Sun', 'شمس'], ['Moon', 'قمر'], ['Star', 'نجمة'],
    ['Red', 'أحمر'], ['Blue', 'أزرق'], ['Green', 'أخضر'],
  ];

  for (int i = 0; i < count; i++) {
    final pair = pairs[i % pairs.length];
    final cards = <Map<String, dynamic>>[];
    final pairCount = 3 + (i % 3); // 3-5 pairs
    
    for (int j = 0; j < pairCount; j++) {
      final pairId = 'pair${j + 1}';
      cards.add({
        'id': 'card${j * 2 + 1}',
        'pairId': pairId,
        'label': pair[0],
        'labels': {'en': pair[0], 'ar': pair[1]},
      });
      cards.add({
        'id': 'card${j * 2 + 2}',
        'pairId': pairId,
        'label': pair[0],
        'labels': {'en': pair[0], 'ar': pair[1]},
      });
    }

    puzzles.add({
      'id': 'memory_flip_gen_${i + 1}',
      'gameType': 'memoryFlip',
      'type': 'text',
      'category': categories[i % categories.length],
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 60 + (i * 10),
      'start': {
        'id': 'start',
        'label': 'Memory Game',
        'representationType': 'text',
        'labels': {'en': 'Memory Game', 'ar': 'لعبة الذاكرة'},
      },
      'end': {
        'id': 'end',
        'label': 'Memory Game',
        'representationType': 'text',
        'labels': {'en': 'Memory Game', 'ar': 'لعبة الذاكرة'},
      },
      'steps': [],
      'gameTypeData': {'cards': cards},
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateSpotTheOddPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final categories = ['General Knowledge', 'Science & Technology', 'Nature & Environment'];
  final itemSets = [
    (['Apple', 'Orange', 'Banana', 'Car'], 'Car'),
    (['Cat', 'Dog', 'Bird', 'Tree'], 'Tree'),
    (['Red', 'Blue', 'Green', 'Number'], 'Number'),
    (['Monday', 'Tuesday', 'Wednesday', 'Color'], 'Color'),
  ];

  for (int i = 0; i < count; i++) {
    final set = itemSets[i % itemSets.length];
    final items = <Map<String, dynamic>>[];
    final oddItem = set.$2;

    for (final item in set.$1) {
      items.add({
        'id': 'item_${item.toLowerCase()}',
        'label': item,
        'isOdd': item == oddItem,
        'labels': {'en': item, 'ar': item},
      });
    }

    puzzles.add({
      'id': 'spot_odd_gen_${i + 1}',
      'gameType': 'spotTheOdd',
      'type': 'text',
      'category': categories[i % categories.length],
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 30 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Find the Odd One',
        'representationType': 'text',
        'labels': {'en': 'Find the Odd One', 'ar': 'اكتشف المختلف'},
      },
      'end': {
        'id': 'end',
        'label': 'Find the Odd One',
        'representationType': 'text',
        'labels': {'en': 'Find the Odd One', 'ar': 'اكتشف المختلف'},
      },
      'steps': [],
      'gameTypeData': {
        'items': items,
        'correctAnswer': 'item_${oddItem.toLowerCase()}',
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateSortSolvePuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final categories = ['General Knowledge', 'Science & Technology'];
  final sortSets = [
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    ['January', 'February', 'March', 'April'],
    ['1', '2', '3', '4'],
    ['A', 'B', 'C', 'D'],
  ];

  for (int i = 0; i < count; i++) {
    final items = <Map<String, dynamic>>[];
    final set = sortSets[i % sortSets.length];
    
    // خلط الترتيب
    final shuffled = List.from(set)..shuffle();

    for (int j = 0; j < shuffled.length; j++) {
      items.add({
        'id': 'item_${j + 1}',
        'label': shuffled[j],
        'order': set.indexOf(shuffled[j]) + 1,
        'labels': {'en': shuffled[j], 'ar': shuffled[j]},
      });
    }

    puzzles.add({
      'id': 'sort_solve_gen_${i + 1}',
      'gameType': 'sortSolve',
      'type': 'text',
      'category': categories[i % categories.length],
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 45 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Sort Items',
        'representationType': 'text',
        'labels': {'en': 'Sort Items', 'ar': 'رتب العناصر'},
      },
      'end': {
        'id': 'end',
        'label': 'Sort Items',
        'representationType': 'text',
        'labels': {'en': 'Sort Items', 'ar': 'رتب العناصر'},
      },
      'steps': [],
      'gameTypeData': {
        'items': items,
        'sortType': 'chronological',
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateStoryTilesPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final stories = [
    ['Once upon a time', 'there was a king', 'who lived in a castle'],
    ['The sun was shining', 'birds were singing', 'flowers were blooming'],
    ['A brave knight', 'went on a quest', 'to save the princess'],
  ];

  for (int i = 0; i < count; i++) {
    final story = stories[i % stories.length];
    final tiles = <Map<String, dynamic>>[];
    
    // خلط الترتيب
    final shuffled = List.from(story)..shuffle();

    for (int j = 0; j < shuffled.length; j++) {
      tiles.add({
        'id': 'tile_${j + 1}',
        'label': shuffled[j],
        'order': story.indexOf(shuffled[j]) + 1,
        'labels': {'en': shuffled[j], 'ar': shuffled[j]},
      });
    }

    puzzles.add({
      'id': 'story_tiles_gen_${i + 1}',
      'gameType': 'storyTiles',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 60 + (i * 10),
      'start': {
        'id': 'start',
        'label': 'Story Tiles',
        'representationType': 'text',
        'labels': {'en': 'Story Tiles', 'ar': 'بلاطات القصة'},
      },
      'end': {
        'id': 'end',
        'label': 'Story Tiles',
        'representationType': 'text',
        'labels': {'en': 'Story Tiles', 'ar': 'بلاطات القصة'},
      },
      'steps': [],
      'gameTypeData': {'tiles': tiles},
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateShadowMatchPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final shapes = ['Circle', 'Square', 'Triangle', 'Star'];

  for (int i = 0; i < count; i++) {
    final shape = shapes[i % shapes.length];
    final shadows = <Map<String, dynamic>>[];

    for (int j = 0; j < 3; j++) {
      shadows.add({
        'id': 'shadow_${j + 1}',
        'label': '$shape Shadow ${j + 1}',
        'isCorrect': j == 0,
        'labels': {'en': '$shape Shadow ${j + 1}', 'ar': 'ظل $shape ${j + 1}'},
      });
    }

    puzzles.add({
      'id': 'shadow_match_gen_${i + 1}',
      'gameType': 'shadowMatch',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 30 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Shadow Match',
        'representationType': 'text',
        'labels': {'en': 'Shadow Match', 'ar': 'مطابقة الظلال'},
      },
      'end': {
        'id': 'end',
        'label': 'Shadow Match',
        'representationType': 'text',
        'labels': {'en': 'Shadow Match', 'ar': 'مطابقة الظلال'},
      },
      'steps': [],
      'gameTypeData': {
        'shape': {
          'id': 'shape1',
          'label': shape,
          'labels': {'en': shape, 'ar': shape},
        },
        'shadows': shadows,
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateEmojiCircuitPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final emojis = ['😀', '😢', '😡', '😴', '😍'];

  for (int i = 0; i < count; i++) {
    final circuitEmojis = <Map<String, dynamic>>[];
    final emojiCount = 3 + (i % 3);

    for (int j = 0; j < emojiCount; j++) {
      circuitEmojis.add({
        'id': 'emoji_${j + 1}',
        'emoji': emojis[j % emojis.length],
        'label': 'Emoji ${j + 1}',
        'labels': {'en': 'Emoji ${j + 1}', 'ar': 'إيموجي ${j + 1}'},
      });
    }

    puzzles.add({
      'id': 'emoji_circuit_gen_${i + 1}',
      'gameType': 'emojiCircuit',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 45 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Emoji Circuit',
        'representationType': 'text',
        'labels': {'en': 'Emoji Circuit', 'ar': 'دائرة الإيموجي'},
      },
      'end': {
        'id': 'end',
        'label': 'Emoji Circuit',
        'representationType': 'text',
        'labels': {'en': 'Emoji Circuit', 'ar': 'دائرة الإيموجي'},
      },
      'steps': [],
      'gameTypeData': {
        'emojis': circuitEmojis,
        'rule': 'emotions',
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateCipherTilesPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final words = ['ABC', 'CAT', 'DOG', 'SUN', 'MOON'];

  for (int i = 0; i < count; i++) {
    final word = words[i % words.length];
    final encoded = word.split('').map((c) => c.codeUnitAt(0) - 64).join('');

    puzzles.add({
      'id': 'cipher_tiles_gen_${i + 1}',
      'gameType': 'cipherTiles',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 60 + (i * 10),
      'start': {
        'id': 'start',
        'label': 'Cipher Tiles',
        'representationType': 'text',
        'labels': {'en': 'Cipher Tiles', 'ar': 'بلاطات الشفرة'},
      },
      'end': {
        'id': 'end',
        'label': 'Cipher Tiles',
        'representationType': 'text',
        'labels': {'en': 'Cipher Tiles', 'ar': 'بلاطات الشفرة'},
      },
      'steps': [],
      'gameTypeData': {
        'cipher': 'A=1, B=2, C=3',
        'encodedWord': encoded,
        'decodedWord': word,
        'hint': 'A=1, B=2, C=3',
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateSpotTheChangePuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final changes = ['door_color', 'window_size', 'roof_shape'];

  for (int i = 0; i < count; i++) {
    final change = changes[i % changes.length];
    final options = <Map<String, dynamic>>[];

    for (int j = 0; j < 3; j++) {
      options.add({
        'id': 'opt_${j + 1}',
        'label': 'Change ${j + 1}',
        'isCorrect': j == 0,
      });
    }

    puzzles.add({
      'id': 'spot_change_gen_${i + 1}',
      'gameType': 'spotTheChange',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 30 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Spot the Change',
        'representationType': 'text',
        'labels': {'en': 'Spot the Change', 'ar': 'اكتشف التغيير'},
      },
      'end': {
        'id': 'end',
        'label': 'Spot the Change',
        'representationType': 'text',
        'labels': {'en': 'Spot the Change', 'ar': 'اكتشف التغيير'},
      },
      'steps': [],
      'gameTypeData': {
        'image1': {
          'id': 'img1',
          'label': 'Scene 1',
          'description': 'Before',
        },
        'image2': {
          'id': 'img2',
          'label': 'Scene 2',
          'description': 'After',
        },
        'change': change,
        'options': options,
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generateColorHarmonyPuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final colorPairs = [
    (['Red', '#FF0000'], ['Blue', '#0000FF'], 'Purple'),
    (['Yellow', '#FFFF00'], ['Blue', '#0000FF'], 'Green'),
    (['Red', '#FF0000'], ['Yellow', '#FFFF00'], 'Orange'),
  ];

  for (int i = 0; i < count; i++) {
    final pair = colorPairs[i % colorPairs.length];
    final targetColor = pair.$3;

    puzzles.add({
      'id': 'color_harmony_gen_${i + 1}',
      'gameType': 'colorHarmony',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 30 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Color Harmony',
        'representationType': 'text',
        'labels': {'en': 'Color Harmony', 'ar': 'انسجام الألوان'},
      },
      'end': {
        'id': 'end',
        'label': 'Color Harmony',
        'representationType': 'text',
        'labels': {'en': 'Color Harmony', 'ar': 'انسجام الألوان'},
      },
      'steps': [],
      'gameTypeData': {
        'colors': [
          {
            'id': 'color1',
            'label': pair.$1[0],
            'hex': pair.$1[1],
            'labels': {'en': pair.$1[0], 'ar': pair.$1[0]},
          },
          {
            'id': 'color2',
            'label': pair.$2[0],
            'hex': pair.$2[1],
            'labels': {'en': pair.$2[0], 'ar': pair.$2[0]},
          },
        ],
        'targetColor': {
          'id': 'target',
          'label': targetColor,
          'hex': '#800080',
          'labels': {'en': targetColor, 'ar': targetColor},
        },
        'mixRule': '${pair.$1[0].toLowerCase()}_${pair.$2[0].toLowerCase()}',
      },
    });
  }

  return puzzles;
}

List<Map<String, dynamic>> _generatePuzzleSentencePuzzles(int count) {
  final puzzles = <Map<String, dynamic>>[];
  final sentences = [
    ['The', 'cat', 'sat', 'on', 'mat'],
    ['I', 'love', 'to', 'play', 'games'],
    ['The', 'sun', 'shines', 'brightly', 'today'],
  ];

  for (int i = 0; i < count; i++) {
    final sentence = sentences[i % sentences.length];
    final words = <Map<String, dynamic>>[];
    
    // خلط الترتيب
    final shuffled = List.from(sentence)..shuffle();

    for (int j = 0; j < shuffled.length; j++) {
      words.add({
        'id': 'word_${j + 1}',
        'label': shuffled[j],
        'order': sentence.indexOf(shuffled[j]) + 1,
        'labels': {'en': shuffled[j], 'ar': shuffled[j]},
      });
    }

    puzzles.add({
      'id': 'puzzle_sentence_gen_${i + 1}',
      'gameType': 'puzzleSentence',
      'type': 'text',
      'category': 'General Knowledge',
      'difficulty': i % 3 == 0 ? 'easy' : (i % 3 == 1 ? 'medium' : 'hard'),
      'linksCount': 1 + (i % 3),
      'timeLimit': 45 + (i * 5),
      'start': {
        'id': 'start',
        'label': 'Puzzle Sentence',
        'representationType': 'text',
        'labels': {'en': 'Puzzle Sentence', 'ar': 'جملة الأحجية'},
      },
      'end': {
        'id': 'end',
        'label': 'Puzzle Sentence',
        'representationType': 'text',
        'labels': {'en': 'Puzzle Sentence', 'ar': 'جملة الأحجية'},
      },
      'steps': [],
      'gameTypeData': {
        'words': words,
        'correctSentence': sentence.join(' '),
      },
    });
  }

  return puzzles;
}

