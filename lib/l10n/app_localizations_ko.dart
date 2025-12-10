// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '미스터리 링크';

  @override
  String get soloMode => '솔로 모드';

  @override
  String get groupMode => '그룹 모드';

  @override
  String get practiceMode => '연습 모드';

  @override
  String get startGame => '게임 시작';

  @override
  String get selectDifficulty => '난이도 선택';

  @override
  String get selectRepresentation => '표현 유형 선택';

  @override
  String get text => '텍스트';

  @override
  String get icon => '아이콘';

  @override
  String get image => '이미지';

  @override
  String get event => '이벤트';

  @override
  String get links => '링크';

  @override
  String get timeRemaining => '남은 시간';

  @override
  String get step => '단계';

  @override
  String get ofLabel => '의';

  @override
  String get correct => '정답!';

  @override
  String get wrong => '오답!';

  @override
  String get timeOut => '시간 종료!';

  @override
  String get score => '점수';

  @override
  String get timeSpent => '소요 시간';

  @override
  String get correctChain => '정확한 체인';

  @override
  String get yourChoices => '당신의 선택';

  @override
  String get playAgain => '다시 플레이';

  @override
  String get share => '공유';

  @override
  String get backToHome => '홈으로 돌아가기';

  @override
  String get selectPlayers => '플레이어 수 선택';

  @override
  String get player => '플레이어';

  @override
  String get points => '포인트';

  @override
  String get nextPlayer => '다음 플레이어';

  @override
  String get gameOver => '게임 오버';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get perfectWin => '완벽합니다! 체인을 올바르게 완성했습니다!';

  @override
  String get timeUpMessage => '시간이 다 되었습니다! 걱정하지 마세요, 다시 시도할 수 있습니다.';

  @override
  String get tieMessage => '무승부입니다! 모두 훌륭한 게임이었습니다!';

  @override
  String get helpText => '현재 카드를 목표에 연결하는 링크를 찾으세요. 그들 사이의 관계를 생각해보세요.';

  @override
  String get guidedModeHint => '선택하기 전에 힌트를 읽으세요: 현재 카드를 목표에 연결하는 링크를 찾으세요.';

  @override
  String get wellDone => '잘했습니다!';

  @override
  String get keepTrying => '계속 노력하세요! 점점 나아지고 있습니다!';

  @override
  String get excellent => '훌륭합니다!';

  @override
  String get goodJob => '잘했어요!';

  @override
  String get almostThere => '거의 다 왔어요!';

  @override
  String get thinkAgain => '다시 생각해보세요. 이 둘을 연결하는 것은 무엇일까요?';

  @override
  String get accessibilityAndLanguage => '접근성 및 언어';

  @override
  String get language => '언어';

  @override
  String get textSize => '텍스트 크기';

  @override
  String get themeMode => '테마 모드';

  @override
  String get systemTheme => '시스템';

  @override
  String get lightThemeOption => '라이트';

  @override
  String get darkThemeOption => '다크';

  @override
  String get dynamicColors => '동적 색상';

  @override
  String get dynamicColorsSubtitle => '적응형 그라데이션과 하이라이트로 인터페이스를 혼합합니다.';

  @override
  String get motionEffects => '모션 및 애니메이션';

  @override
  String get motionEffectsSubtitle => '더 차분한 UI를 선호하는 경우 애니메이션을 비활성화하세요.';

  @override
  String get liveTournamentFeed => '라이브 토너먼트 피드';

  @override
  String get liveTournamentFeedEmpty =>
      '토너먼트가 시작되면 라이브 브래킷과 매치 스파크가 여기에 표시됩니다.';

  @override
  String get futurePlaybook => '미래 플레이북';

  @override
  String get futurePlaybookSubtitle => '다음 10년을 위해 준비된 향후 트렌드';

  @override
  String get levelsChallenges => '레벨 및 챌린지';

  @override
  String get levelsChallengesSubtitle => '구조화된 레벨과 그 챌린지를 탐색하세요';

  @override
  String get close => '닫기';

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
