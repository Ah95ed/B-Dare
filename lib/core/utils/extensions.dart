extension StringExtensions on String {
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  String get trimmed {
    return trim();
  }
}

extension DurationExtensions on Duration {
  String get formatted {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
  
  String get formattedShort {
    final seconds = inSeconds;
    if (seconds >= 60) {
      return '${(seconds / 60).toStringAsFixed(1)}m';
    }
    return '${seconds}s';
  }
}

