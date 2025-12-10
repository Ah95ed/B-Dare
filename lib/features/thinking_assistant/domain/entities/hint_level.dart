enum HintLevel {
  gentle,
  focused,
  reveal;

  String get label {
    switch (this) {
      case HintLevel.gentle:
        return 'Gentle';
      case HintLevel.focused:
        return 'Focused';
      case HintLevel.reveal:
        return 'Reveal';
    }
  }
}
