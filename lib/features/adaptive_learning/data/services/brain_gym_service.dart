import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BrainGymStatus {
  final DateTime? lastSessionDate;
  final int streak;
  final int totalSessions;

  const BrainGymStatus({
    this.lastSessionDate,
    this.streak = 0,
    this.totalSessions = 0,
  });

  factory BrainGymStatus.initial() => const BrainGymStatus();

  bool get completedToday {
    if (lastSessionDate == null) return false;
    final now = DateTime.now();
    return _isSameDay(now, lastSessionDate!);
  }

  BrainGymStatus copyWith({
    DateTime? lastSessionDate,
    int? streak,
    int? totalSessions,
  }) {
    return BrainGymStatus(
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      streak: streak ?? this.streak,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastSessionDate': lastSessionDate?.millisecondsSinceEpoch,
      'streak': streak,
      'totalSessions': totalSessions,
    };
  }

  factory BrainGymStatus.fromJson(Map<String, dynamic> json) {
    return BrainGymStatus(
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSessionDate'] as int)
          : null,
      streak: json['streak'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
    );
  }
}

class BrainGymService {
  static const _statusKey = 'brain_gym_status_v1';

  Future<BrainGymStatus> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statusKey);
    if (raw == null) return BrainGymStatus.initial();
    try {
      return BrainGymStatus.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return BrainGymStatus.initial();
    }
  }

  Future<BrainGymStatus> recordSessionCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final previous = await getStatus();
    final now = DateTime.now();
    int streak = 1;
    if (previous.lastSessionDate != null) {
      if (_isSameDay(previous.lastSessionDate!, now)) {
        streak = previous.streak;
      } else if (_isYesterday(previous.lastSessionDate!, now)) {
        streak = previous.streak + 1;
      }
    }
    final updated = previous.copyWith(
      lastSessionDate: now,
      streak: streak,
      totalSessions: previous.totalSessions + 1,
    );
    await prefs.setString(_statusKey, json.encode(updated.toJson()));
    return updated;
  }
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _isYesterday(DateTime date, DateTime now) {
  final diff =
      DateTime(now.year, now.month, now.day).difference(DateTime(date.year, date.month, date.day));
  return diff.inDays == 1;
}
