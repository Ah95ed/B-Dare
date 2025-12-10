class PuzzleDataException implements Exception {
  final String message;
  final Object? cause;

  const PuzzleDataException(this.message, {this.cause});

  @override
  String toString() {
    if (cause == null) {
      return 'PuzzleDataException: $message';
    }
    return 'PuzzleDataException: $message (cause: $cause)';
  }
}

