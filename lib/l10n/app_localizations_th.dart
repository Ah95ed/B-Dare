// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'ลิงก์ลึกลับ';

  @override
  String get soloMode => 'โหมดเดี่ยว';

  @override
  String get groupMode => 'โหมดกลุ่ม';

  @override
  String get practiceMode => 'โหมดฝึกซ้อม';

  @override
  String get startGame => 'เริ่มเกม';

  @override
  String get selectDifficulty => 'เลือกความยาก';

  @override
  String get selectRepresentation => 'เลือกประเภทการแสดง';

  @override
  String get text => 'ข้อความ';

  @override
  String get icon => 'ไอคอน';

  @override
  String get image => 'รูปภาพ';

  @override
  String get event => 'เหตุการณ์';

  @override
  String get links => 'ลิงก์';

  @override
  String get timeRemaining => 'เวลาที่เหลือ';

  @override
  String get step => 'ขั้นตอน';

  @override
  String get ofLabel => 'ของ';

  @override
  String get correct => 'ถูกต้อง!';

  @override
  String get wrong => 'ผิด!';

  @override
  String get timeOut => 'หมดเวลา!';

  @override
  String get score => 'คะแนน';

  @override
  String get timeSpent => 'เวลาที่ใช้';

  @override
  String get correctChain => 'โซ่ที่ถูกต้อง';

  @override
  String get yourChoices => 'ตัวเลือกของคุณ';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get share => 'แชร์';

  @override
  String get backToHome => 'กลับหน้าหลัก';

  @override
  String get selectPlayers => 'เลือกจำนวนผู้เล่น';

  @override
  String get player => 'ผู้เล่น';

  @override
  String get points => 'คะแนน';

  @override
  String get nextPlayer => 'ผู้เล่นคนถัดไป';

  @override
  String get gameOver => 'เกมจบ';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get perfectWin => 'สมบูรณ์แบบ! คุณทำโซ่เสร็จถูกต้องแล้ว!';

  @override
  String get timeUpMessage => 'หมดเวลาแล้ว! ไม่ต้องกังวล คุณลองใหม่ได้';

  @override
  String get tieMessage => 'เสมอกัน! เกมที่ยอดเยี่ยมทุกคน!';

  @override
  String get helpText =>
      'ค้นหาลิงก์ที่เชื่อมต่อการ์ดปัจจุบันกับเป้าหมาย คิดถึงความสัมพันธ์ระหว่างพวกมัน';

  @override
  String get guidedModeHint =>
      'อ่านคำใบ้ก่อนเลือก: ค้นหาลิงก์ที่เชื่อมต่อการ์ดปัจจุบันกับเป้าหมาย';

  @override
  String get wellDone => 'ทำได้ดี!';

  @override
  String get keepTrying => 'พยายามต่อไป! คุณกำลังดีขึ้น!';

  @override
  String get excellent => 'ยอดเยี่ยม!';

  @override
  String get goodJob => 'ทำได้ดี!';

  @override
  String get almostThere => 'เกือบถึงแล้ว!';

  @override
  String get thinkAgain => 'คิดอีกครั้ง อะไรที่เชื่อมสองสิ่งนี้?';

  @override
  String get accessibilityAndLanguage => 'การเข้าถึงและภาษา';

  @override
  String get language => 'ภาษา';

  @override
  String get textSize => 'ขนาดข้อความ';

  @override
  String get themeMode => 'โหมดธีม';

  @override
  String get systemTheme => 'ระบบ';

  @override
  String get lightThemeOption => 'สว่าง';

  @override
  String get darkThemeOption => 'มืด';

  @override
  String get dynamicColors => 'สีแบบไดนามิก';

  @override
  String get dynamicColorsSubtitle =>
      'ผสมผสานอินเทอร์เฟซด้วยการไล่ระดับสีและไฮไลต์แบบปรับตัว';

  @override
  String get motionEffects => 'การเคลื่อนไหวและแอนิเมชัน';

  @override
  String get motionEffectsSubtitle =>
      'ปิดการใช้งานแอนิเมชันหากคุณต้องการ UI ที่สงบกว่า';

  @override
  String get liveTournamentFeed => 'ฟีดการแข่งขันสด';

  @override
  String get liveTournamentFeedEmpty =>
      'ตารางการแข่งขันสดและประกายไฟการแข่งขันจะปรากฏที่นี่เมื่อการแข่งขันเริ่มต้น';

  @override
  String get futurePlaybook => 'คู่มือการเล่นในอนาคต';

  @override
  String get futurePlaybookSubtitle =>
      'เทรนด์ที่กำลังจะมาถึงที่เตรียมไว้สำหรับทศวรรษหน้า';

  @override
  String get levelsChallenges => 'ระดับและความท้าทาย';

  @override
  String get levelsChallengesSubtitle =>
      'เรียกดูระดับที่มีโครงสร้างและความท้าทายของพวกมัน';

  @override
  String get close => 'ปิด';

  @override
  String dailySessionStatusCompleted(int streak) {
    return 'You finished today’s session! $streak day streak';
  }

  @override
  String dailySessionStatusNotStarted(int streak) {
    return 'You haven’t started today’s session yet · Current streak: $streak days';
  }

  @override
  String dailySessionTotalSessions(int count) {
    return 'Total sessions: $count';
  }

  @override
  String get brainGymStartNow => 'Start Brain Gym now';

  @override
  String familySessionsTitleWithProfile(String profile) {
    return '$profile sessions';
  }

  @override
  String get familySessionsTitleDefault => 'Family sessions';

  @override
  String get sessionsLabel => 'Sessions';

  @override
  String get winsLabel => 'Wins';

  @override
  String get lastSessionLabel => 'Last session';

  @override
  String familyWeeklyGoal(int wins) {
    return 'This week’s goal: win 3 family sessions. Current progress $wins/3.';
  }

  @override
  String familyWinsSessionsSummary(int wins, int sessions) {
    return 'Wins: $wins / Sessions: $sessions';
  }

  @override
  String get familyNoSessionYet => 'Start your first family session today!';

  @override
  String get familyStartNewSession => 'Start new session';

  @override
  String get keepPlayingToMaintainProgress =>
      'Keep playing to maintain your progress!';

  @override
  String get guidedModeTitle => 'Guided Mode';

  @override
  String get guidedModeDescription =>
      'Simplified steps and hints for younger players and beginners.';

  @override
  String get soloModeDescription => 'Play alone and challenge yourself';

  @override
  String get createGroupTitle => 'Create Group';

  @override
  String get createGroupDescription => 'Create a group game with friends';

  @override
  String get globalTournamentsTitle => 'Global Tournaments';

  @override
  String get globalTournamentsDescription =>
      'Join global tournaments and become world champion';

  @override
  String get progressKeepPlayingHint => 'Keep playing to keep your momentum!';

  @override
  String get brainGymSessionCompletedFinal =>
      '🎯 You finished your Brain Gym session!';

  @override
  String get brainGymPerfectRoundHeadline => '💪 Perfect round!';

  @override
  String get brainGymNewRoundHeadline => 'Great! New Brain Gym round';

  @override
  String brainGymCurrentStreak(int streak) {
    return 'Your current streak: $streak days';
  }

  @override
  String get brainGymStartNewStreak => 'Start a new streak today';

  @override
  String brainGymRoundProgress(int current, int total, int score) {
    return 'Round $current of $total · Session score: $score';
  }

  @override
  String brainGymTotalSessions(int total) {
    return 'Total training sessions: $total';
  }

  @override
  String get guidedModeIntroStep1 =>
      'Listen to the short instructions, then read the start and end points.';

  @override
  String get guidedModeIntroStep2 =>
      'Choose the correct link from three simplified options.';

  @override
  String get guidedModeIntroStep3 =>
      'If you make a mistake, you will get an instant hint to help next time.';

  @override
  String get guidedModeLongDescription =>
      'An experience suitable for younger players and new users. This mode focuses on short chains with visual and audio hints.';

  @override
  String get guidedModeStartSession => 'Start guided session';

  @override
  String get selectGameTypeTitle => 'Choose game type';

  @override
  String familySessionTitleWithProfileInGame(String profile) {
    return '$profile team';
  }

  @override
  String get familySessionTitleInGame => 'Family session';

  @override
  String get sessionsShortLabel => 'Sessions';

  @override
  String get winsShortLabel => 'Wins';

  @override
  String get lossesShortLabel => 'Losses';

  @override
  String get lastSessionShort => 'Last session';

  @override
  String relativeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String relativeHours(int hours) {
    return '$hours h';
  }

  @override
  String relativeDays(int days) {
    return '$days d';
  }

  @override
  String get matchNotReady => 'Match is not ready yet';

  @override
  String matchStartFailed(String error) {
    return 'Failed to start match: $error';
  }

  @override
  String matchJoinFailed(String error) {
    return 'Failed to join match: $error';
  }

  @override
  String get tournamentGlobalTitle => 'Global Tournaments';

  @override
  String get tournamentNoTournaments => 'No tournaments';

  @override
  String get tournamentFilterLabel => 'Filter:';

  @override
  String get tournamentFilterAll => 'All';

  @override
  String get tournamentFilterRegistration => 'Registration';

  @override
  String get tournamentFilterQualifiers => 'Qualifiers';

  @override
  String get tournamentFilterFinal => 'Final';

  @override
  String get tournamentFilterCompleted => 'Completed';

  @override
  String get tournamentEmptyTitle => 'No tournaments at the moment';

  @override
  String get tournamentCreateNew => 'Create new tournament';

  @override
  String get tournamentStagesSectionTitle => 'Stages';

  @override
  String tournamentTeamsSectionTitle(int count, int max) {
    return 'Teams ($count/$max)';
  }

  @override
  String tournamentViewAllTeams(int count) {
    return 'View all teams ($count)';
  }

  @override
  String get tournamentBracketTitle => 'Bracket';

  @override
  String get tournamentBracketUnavailable => 'Bracket is not available yet';

  @override
  String get tournamentViewBracket => 'View bracket';

  @override
  String get tournamentStart => 'Start tournament';

  @override
  String get back => 'Back';

  @override
  String get tournamentStatusRegistration => 'Registration';

  @override
  String get tournamentStatusQualifiers => 'Qualifiers';

  @override
  String get tournamentStatusPlayoffs => 'Playoffs';

  @override
  String get tournamentStatusFinal => 'Final';

  @override
  String get tournamentStatusCompleted => 'Completed';

  @override
  String get tournamentStatusCancelled => 'Cancelled';

  @override
  String get tournamentMatchStatusScheduled => 'Scheduled';

  @override
  String get tournamentMatchStatusInProgress => 'In progress';

  @override
  String get tournamentMatchStatusCompleted => 'Completed';

  @override
  String get tournamentMatchStatusForfeit => 'Forfeit';

  @override
  String get tournamentMatchStatusCancelled => 'Cancelled';

  @override
  String get tournamentStatsTeams => 'Teams';

  @override
  String get tournamentStatsStages => 'Stages';

  @override
  String get tournamentStatsType => 'Type';

  @override
  String get tournamentTypeSingleElimination => 'Single Elimination';

  @override
  String get tournamentTypeDoubleElimination => 'Double Elimination';

  @override
  String get tournamentTypeSwiss => 'Swiss';

  @override
  String get tournamentTypeRoundRobin => 'Round Robin';

  @override
  String stageRoundProgress(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get matchesLabel => 'Matches';

  @override
  String get stageStatusNotStarted => 'Not started';

  @override
  String get stageStatusInProgress => 'In progress';

  @override
  String get stageStatusCompleted => 'Completed';

  @override
  String relativeInDays(int days) {
    return 'In $days days';
  }

  @override
  String relativeInHours(int hours) {
    return 'In $hours hours';
  }

  @override
  String relativeInMinutes(int minutes) {
    return 'In $minutes minutes';
  }

  @override
  String get relativeStarted => 'Started';

  @override
  String get relativeNow => 'Now';

  @override
  String get matchTitle => 'Match';

  @override
  String get matchStart => 'Start match';

  @override
  String get matchJoin => 'Join match';

  @override
  String get samplePuzzleLoaded => 'Loaded a practice puzzle';
}
