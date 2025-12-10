import 'package:flutter/material.dart';

/// Enum يمثل أنواع الألعاب المختلفة
enum GameType {
  mysteryLink,
  memoryFlip,
  spotTheOdd,
  sortSolve,
  storyTiles,
  shadowMatch,
  emojiCircuit,
  cipherTiles,
  spotTheChange,
  colorHarmony,
  puzzleSentence,
}

/// Extension methods لـ GameType
extension GameTypeExtension on GameType {
  /// الاسم بالعربية
  String get name {
    switch (this) {
      case GameType.mysteryLink:
        return 'الرابط العجيب';
      case GameType.memoryFlip:
        return 'ذاكرة البطاقات';
      case GameType.spotTheOdd:
        return 'اكتشف المختلف';
      case GameType.sortSolve:
        return 'الترتيب والحل';
      case GameType.storyTiles:
        return 'بلاطات القصة';
      case GameType.shadowMatch:
        return 'مطابقة الظلال';
      case GameType.emojiCircuit:
        return 'دائرة الإيموجي';
      case GameType.cipherTiles:
        return 'بلاطات الشفرة';
      case GameType.spotTheChange:
        return 'اكتشف التغيير';
      case GameType.colorHarmony:
        return 'انسجام الألوان';
      case GameType.puzzleSentence:
        return 'جملة الأحجية';
    }
  }

  /// الاسم بالإنجليزية
  String get nameEn {
    switch (this) {
      case GameType.mysteryLink:
        return 'Mystery Link';
      case GameType.memoryFlip:
        return 'Memory Flip';
      case GameType.spotTheOdd:
        return 'Spot the Odd';
      case GameType.sortSolve:
        return 'Sort & Solve';
      case GameType.storyTiles:
        return 'Story Tiles';
      case GameType.shadowMatch:
        return 'Shadow Match';
      case GameType.emojiCircuit:
        return 'Emoji Circuit';
      case GameType.cipherTiles:
        return 'Cipher Tiles';
      case GameType.spotTheChange:
        return 'Spot the Change';
      case GameType.colorHarmony:
        return 'Color Harmony';
      case GameType.puzzleSentence:
        return 'Puzzle Sentence';
    }
  }

  /// الوصف بالعربية
  String get description {
    switch (this) {
      case GameType.mysteryLink:
        return 'اربط بين عنصرين عبر روابط متوسطة';
      case GameType.memoryFlip:
        return 'قلب البطاقات وابحث عن الأزواج المتطابقة';
      case GameType.spotTheOdd:
        return 'اكتشف العنصر المختلف عن البقية';
      case GameType.sortSolve:
        return 'رتب العناصر بطريقة منطقية';
      case GameType.storyTiles:
        return 'رتب البلاطات لتكوين قصة';
      case GameType.shadowMatch:
        return 'طابق الشكل مع ظله الصحيح';
      case GameType.emojiCircuit:
        return 'اربط الإيموجي حسب القواعد';
      case GameType.cipherTiles:
        return 'فك الشفرة واكتشف الكلمة';
      case GameType.spotTheChange:
        return 'اكتشف ما تغير بين الصورتين';
      case GameType.colorHarmony:
        return 'امزج الألوان للحصول على اللون المطلوب';
      case GameType.puzzleSentence:
        return 'رتب الكلمات لتكوين جملة صحيحة';
    }
  }

  /// الوصف بالإنجليزية
  String get descriptionEn {
    switch (this) {
      case GameType.mysteryLink:
        return 'Connect two elements through intermediate links';
      case GameType.memoryFlip:
        return 'Flip cards and find matching pairs';
      case GameType.spotTheOdd:
        return 'Find the item that differs from the rest';
      case GameType.sortSolve:
        return 'Arrange items in a logical order';
      case GameType.storyTiles:
        return 'Arrange tiles to form a story';
      case GameType.shadowMatch:
        return 'Match the shape with its correct shadow';
      case GameType.emojiCircuit:
        return 'Connect emojis according to rules';
      case GameType.cipherTiles:
        return 'Decode the cipher and discover the word';
      case GameType.spotTheChange:
        return 'Find what changed between two images';
      case GameType.colorHarmony:
        return 'Mix colors to get the target color';
      case GameType.puzzleSentence:
        return 'Arrange words to form a correct sentence';
    }
  }

  /// الأيقونة
  IconData get icon {
    switch (this) {
      case GameType.mysteryLink:
        return Icons.link;
      case GameType.memoryFlip:
        return Icons.flip;
      case GameType.spotTheOdd:
        return Icons.find_in_page;
      case GameType.sortSolve:
        return Icons.sort;
      case GameType.storyTiles:
        return Icons.auto_stories;
      case GameType.shadowMatch:
        return Icons.contrast;
      case GameType.emojiCircuit:
        return Icons.emoji_emotions;
      case GameType.cipherTiles:
        return Icons.vpn_key;
      case GameType.spotTheChange:
        return Icons.compare;
      case GameType.colorHarmony:
        return Icons.palette;
      case GameType.puzzleSentence:
        return Icons.text_fields;
    }
  }

  /// String representation للاستخدام في JSON
  String get value {
    switch (this) {
      case GameType.mysteryLink:
        return 'mysteryLink';
      case GameType.memoryFlip:
        return 'memoryFlip';
      case GameType.spotTheOdd:
        return 'spotTheOdd';
      case GameType.sortSolve:
        return 'sortSolve';
      case GameType.storyTiles:
        return 'storyTiles';
      case GameType.shadowMatch:
        return 'shadowMatch';
      case GameType.emojiCircuit:
        return 'emojiCircuit';
      case GameType.cipherTiles:
        return 'cipherTiles';
      case GameType.spotTheChange:
        return 'spotTheChange';
      case GameType.colorHarmony:
        return 'colorHarmony';
      case GameType.puzzleSentence:
        return 'puzzleSentence';
    }
  }

  /// هل النمط turn-based؟
  bool get isTurnBased {
    // جميع الأنماط المضافة هي turn-based
    return true;
  }

  /// هل يدعم multiplayer؟
  bool get supportsMultiplayer {
    // جميع الأنماط تدعم multiplayer
    return true;
  }

  /// Factory method من String
  static GameType? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'mysterylink':
      case 'mystery_link':
        return GameType.mysteryLink;
      case 'memoryflip':
      case 'memory_flip':
        return GameType.memoryFlip;
      case 'spotheodd':
      case 'spot_the_odd':
        return GameType.spotTheOdd;
      case 'sortsolve':
      case 'sort_solve':
        return GameType.sortSolve;
      case 'storytiles':
      case 'story_tiles':
        return GameType.storyTiles;
      case 'shadowmatch':
      case 'shadow_match':
        return GameType.shadowMatch;
      case 'emojicircuit':
      case 'emoji_circuit':
        return GameType.emojiCircuit;
      case 'ciphertiles':
      case 'cipher_tiles':
        return GameType.cipherTiles;
      case 'spothechange':
      case 'spot_the_change':
        return GameType.spotTheChange;
      case 'colorharmony':
      case 'color_harmony':
        return GameType.colorHarmony;
      case 'puzzlesentence':
      case 'puzzle_sentence':
        return GameType.puzzleSentence;
      default:
        return null;
    }
  }
}

