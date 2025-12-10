// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Liên Kết Bí Ẩn';

  @override
  String get soloMode => 'Chế Độ Đơn';

  @override
  String get groupMode => 'Chế Độ Nhóm';

  @override
  String get practiceMode => 'Chế Độ Luyện Tập';

  @override
  String get startGame => 'Bắt Đầu Trò Chơi';

  @override
  String get selectDifficulty => 'Chọn Độ Khó';

  @override
  String get selectRepresentation => 'Chọn Loại Biểu Diễn';

  @override
  String get text => 'Văn Bản';

  @override
  String get icon => 'Biểu Tượng';

  @override
  String get image => 'Hình Ảnh';

  @override
  String get event => 'Sự Kiện';

  @override
  String get links => 'Liên Kết';

  @override
  String get timeRemaining => 'Thời Gian Còn Lại';

  @override
  String get step => 'Bước';

  @override
  String get ofLabel => 'của';

  @override
  String get correct => 'Đúng!';

  @override
  String get wrong => 'Sai!';

  @override
  String get timeOut => 'Hết Giờ!';

  @override
  String get score => 'Điểm';

  @override
  String get timeSpent => 'Thời Gian Đã Dùng';

  @override
  String get correctChain => 'Chuỗi Đúng';

  @override
  String get yourChoices => 'Lựa Chọn Của Bạn';

  @override
  String get playAgain => 'Chơi Lại';

  @override
  String get share => 'Chia Sẻ';

  @override
  String get backToHome => 'Về Trang Chủ';

  @override
  String get selectPlayers => 'Chọn Số Người Chơi';

  @override
  String get player => 'Người Chơi';

  @override
  String get points => 'Điểm';

  @override
  String get nextPlayer => 'Người Chơi Tiếp Theo';

  @override
  String get gameOver => 'Trò Chơi Kết Thúc';

  @override
  String get loading => 'Đang Tải...';

  @override
  String get error => 'Lỗi';

  @override
  String get retry => 'Thử Lại';

  @override
  String get perfectWin =>
      'Hoàn Hảo! Bạn đã hoàn thành chuỗi một cách chính xác!';

  @override
  String get timeUpMessage => 'Hết giờ! Đừng lo lắng, bạn có thể thử lại.';

  @override
  String get tieMessage => 'Hòa! Trò chơi tuyệt vời mọi người!';

  @override
  String get helpText =>
      'Tìm liên kết kết nối thẻ hiện tại với mục tiêu. Hãy suy nghĩ về mối quan hệ giữa chúng.';

  @override
  String get guidedModeHint =>
      'Đọc gợi ý trước khi chọn: Tìm liên kết kết nối thẻ hiện tại với mục tiêu.';

  @override
  String get wellDone => 'Làm tốt lắm!';

  @override
  String get keepTrying => 'Tiếp tục cố gắng! Bạn đang tiến bộ!';

  @override
  String get excellent => 'Xuất sắc!';

  @override
  String get goodJob => 'Làm tốt!';

  @override
  String get almostThere => 'Sắp xong rồi!';

  @override
  String get thinkAgain => 'Hãy suy nghĩ lại. Điều gì kết nối hai cái này?';

  @override
  String get accessibilityAndLanguage => 'Khả Năng Truy Cập và Ngôn Ngữ';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get textSize => 'Cỡ Chữ';

  @override
  String get themeMode => 'Chế Độ Giao Diện';

  @override
  String get systemTheme => 'Hệ Thống';

  @override
  String get lightThemeOption => 'Sáng';

  @override
  String get darkThemeOption => 'Tối';

  @override
  String get dynamicColors => 'Màu Sắc Động';

  @override
  String get dynamicColorsSubtitle =>
      'Trộn giao diện với gradient và điểm nổi bật thích ứng.';

  @override
  String get motionEffects => 'Chuyển Động và Hoạt Hình';

  @override
  String get motionEffectsSubtitle =>
      'Tắt hoạt hình nếu bạn thích giao diện yên tĩnh hơn.';

  @override
  String get liveTournamentFeed => 'Nguồn Cấp Giải Đấu Trực Tiếp';

  @override
  String get liveTournamentFeedEmpty =>
      'Bảng đấu trực tiếp và tia lửa trận đấu sẽ xuất hiện ở đây khi giải đấu bắt đầu.';

  @override
  String get futurePlaybook => 'Sách Hướng Dẫn Tương Lai';

  @override
  String get futurePlaybookSubtitle =>
      'Xu hướng sắp tới được chuẩn bị cho thập kỷ tới';

  @override
  String get levelsChallenges => 'Cấp Độ và Thử Thách';

  @override
  String get levelsChallengesSubtitle =>
      'Duyệt các cấp độ có cấu trúc và thử thách của chúng';

  @override
  String get close => 'Đóng';

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
