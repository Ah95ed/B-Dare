import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/family_session_stats.dart';

class FamilySessionStorage {
  static const _storageKey = 'family_session_stats_v1';

  Future<FamilySessionStats> loadStats(String? profile) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _normalizeProfile(profile);
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return FamilySessionStats(groupProfile: profile);
    }
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      final entry = map[key];
      if (entry is Map<String, dynamic>) {
        final loaded = FamilySessionStats.fromJson(entry);
        final normalizedProfile = profile ?? loaded.groupProfile;
        return loaded.copyWith(groupProfile: normalizedProfile);
      }
      return FamilySessionStats(groupProfile: profile);
    } catch (_) {
      return FamilySessionStats(groupProfile: profile);
    }
  }

  Future<void> saveStats(
    String? profile,
    FamilySessionStats stats,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _normalizeProfile(profile);
    Map<String, dynamic> map = {};
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        map = json.decode(raw) as Map<String, dynamic>;
      } catch (_) {
        map = {};
      }
    }
    final toStore = stats.copyWith(
      groupProfile: profile ?? stats.groupProfile,
    );
    map[key] = toStore.toJson();
    await prefs.setString(_storageKey, json.encode(map));
  }

  Future<FamilySessionStats?> loadMostRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return null;
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      FamilySessionStats? latest;
      for (final entry in map.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          final stats = FamilySessionStats.fromJson(value);
          final enriched =
              stats.copyWith(groupProfile: stats.groupProfile ?? entry.key);
          if (latest == null ||
              (enriched.lastSessionAt != null &&
                  (latest.lastSessionAt == null ||
                      enriched.lastSessionAt!
                          .isAfter(latest.lastSessionAt!)))) {
            latest = enriched;
          }
        }
      }
      return latest;
    } catch (_) {
      return null;
    }
  }

  String _normalizeProfile(String? profile) {
    final normalized = profile?.trim().toLowerCase();
    return normalized?.isNotEmpty == true ? normalized! : '__default';
  }
}
