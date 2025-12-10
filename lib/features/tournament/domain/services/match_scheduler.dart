import 'package:timezone/timezone.dart' as tz;
import '../entities/match.dart';
import '../entities/team.dart';
import '../entities/tournament_stage.dart';

/// Time Zone Manager
class TimeZoneManager {
  /// تحويل DateTime من timezone إلى UTC
  static DateTime toUTC(DateTime localTime, String timeZone) {
    try {
      final location = tz.getLocation(timeZone);
      final localTZ = tz.TZDateTime.from(localTime, location);
      return localTZ.toUtc();
    } catch (e) {
      // Fallback: افترض أن الوقت بالفعل UTC
      return localTime.toUtc();
    }
  }

  /// تحويل DateTime من UTC إلى timezone محلي
  static DateTime toLocal(DateTime utcTime, String timeZone) {
    try {
      final location = tz.getLocation(timeZone);
      return tz.TZDateTime.from(utcTime, location);
    } catch (e) {
      // Fallback: ارجع UTC
      return utcTime;
    }
  }

  /// الحصول على timezone من country code
  static String getTimeZoneFromCountry(String countryCode) {
    // TODO: Map country codes to timezones
    // مثال: 'SA' -> 'Asia/Riyadh', 'US' -> 'America/New_York'
    return 'UTC'; // Default
  }
}

/// Match Scheduler - جدولة المباريات مع إدارة التوقيتات
class MatchScheduler {
  /// جدولة مباراة بين فريقين
  static Match scheduleMatch({
    required String matchId,
    required String tournamentId,
    required String stageId,
    required Team team1,
    required Team team2,
    required MatchFormat format,
    DateTime? preferredTime,
  }) {
    // محاولة إيجاد وقت مشترك بين الفريقين
    final scheduledTime = _findCommonTimeSlot(
      team1: team1,
      team2: team2,
      preferredTime: preferredTime,
    );

    // تحديد timezone للمباراة (استخدام timezone الفريق الأول كافتراضي)
    final matchTimeZone = team1.timeZone;

    return Match(
      id: matchId,
      tournamentId: tournamentId,
      stageId: stageId,
      team1: team1,
      team2: team2,
      scheduledTime: scheduledTime,
      format: format,
      timeZone: matchTimeZone,
      preferredTimeSlots: [
        ...team1.preferredTimeSlots,
        ...team2.preferredTimeSlots,
      ],
    );
  }

  /// إيجاد وقت مشترك بين فريقين
  static DateTime _findCommonTimeSlot({
    required Team team1,
    required Team team2,
    DateTime? preferredTime,
  }) {
    // محاولة إيجاد وقت مشترك في preferredTimeSlots
    for (final slot1 in team1.preferredTimeSlots) {
      for (final slot2 in team2.preferredTimeSlots) {
        // إذا كان الفرق أقل من ساعة، اعتبره وقت مشترك
        if ((slot1.difference(slot2).abs().inHours) < 1) {
          // استخدم الوقت الأوسط
          return slot1.add(slot2.difference(slot1) ~/ 2);
        }
      }
    }

    // إذا لم يوجد وقت مشترك، استخدم preferredTime أو الوقت الحالي + 24 ساعة
    return preferredTime ?? DateTime.now().add(const Duration(days: 1));
  }

  /// إعادة جدولة مباراة
  static Match rescheduleMatch({
    required Match match,
    required DateTime newTime,
    required String reason,
  }) {
    if (!match.canReschedule(newTime)) {
      throw Exception('Cannot reschedule match: too close to scheduled time');
    }

    return match.copyWith(
      scheduledTime: newTime,
      isRescheduled: true,
      rescheduleReason: reason,
    );
  }

  /// جدولة جميع مباريات جولة
  static List<Match> scheduleRound({
    required String tournamentId,
    required String stageId,
    required List<Team> teams,
    required MatchFormat format,
    required DateTime roundStartDate,
    required Duration timeBetweenMatches,
  }) {
    final matches = <Match>[];
    var currentTime = roundStartDate;

    // جدولة مباريات الجولة
    for (int i = 0; i < teams.length; i += 2) {
      if (i + 1 < teams.length) {
        final match = scheduleMatch(
          matchId: 'match_${tournamentId}_${DateTime.now().millisecondsSinceEpoch}_$i',
          tournamentId: tournamentId,
          stageId: stageId,
          team1: teams[i],
          team2: teams[i + 1],
          format: format,
          preferredTime: currentTime,
        );

        matches.add(match);
        currentTime = currentTime.add(timeBetweenMatches);
      }
    }

    return matches;
  }
}

