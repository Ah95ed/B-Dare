import '../../domain/entities/family_session_stats.dart';

class FamilySessionTracker {
  FamilySessionStats _stats = FamilySessionStats.initial();
  DateTime? _sessionStartedAt;
  int _turnsInSession = 0;
  String? _activeProfile;

  FamilySessionStats get currentStats => _stats;

  void hydrate(FamilySessionStats stats) {
    _stats = stats;
    _activeProfile = stats.groupProfile;
  }

  void startSession(String? profile) {
    _sessionStartedAt = DateTime.now();
    _turnsInSession = 0;
    _activeProfile = profile ?? _activeProfile;
  }

  void recordTurn() {
    _turnsInSession += 1;
  }

  FamilySessionStats? completeSession({required bool isWin}) {
    if (_sessionStartedAt == null) {
      return null;
    }
    final duration = DateTime.now().difference(_sessionStartedAt!);
    _stats = _stats.recordSession(
      isWin: isWin,
      turnsInSession: _turnsInSession,
      duration: duration,
      profile: _activeProfile,
    );
    _sessionStartedAt = null;
    _turnsInSession = 0;
    return _stats;
  }

  void reset() {
    _sessionStartedAt = null;
    _turnsInSession = 0;
  }
}
