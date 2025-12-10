// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'ミステリーリンク';

  @override
  String get soloMode => 'ソロモード';

  @override
  String get groupMode => 'グループモード';

  @override
  String get practiceMode => '練習モード';

  @override
  String get startGame => 'ゲーム開始';

  @override
  String get selectDifficulty => '難易度を選択';

  @override
  String get selectRepresentation => '表現タイプを選択';

  @override
  String get text => 'テキスト';

  @override
  String get icon => 'アイコン';

  @override
  String get image => '画像';

  @override
  String get event => 'イベント';

  @override
  String get links => 'リンク';

  @override
  String get timeRemaining => '残り時間';

  @override
  String get step => 'ステップ';

  @override
  String get ofLabel => 'の';

  @override
  String get correct => '正解！';

  @override
  String get wrong => '不正解！';

  @override
  String get timeOut => '時間切れ！';

  @override
  String get score => 'スコア';

  @override
  String get timeSpent => '経過時間';

  @override
  String get correctChain => '正しいチェーン';

  @override
  String get yourChoices => 'あなたの選択';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get share => '共有';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get selectPlayers => 'プレイヤー数を選択';

  @override
  String get player => 'プレイヤー';

  @override
  String get points => 'ポイント';

  @override
  String get nextPlayer => '次のプレイヤー';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get retry => '再試行';

  @override
  String get perfectWin => '完璧！チェーンを正しく完成させました！';

  @override
  String get timeUpMessage => '時間切れです！心配しないで、もう一度試すことができます。';

  @override
  String get tieMessage => '引き分けです！みんな素晴らしいゲームでした！';

  @override
  String get helpText => '現在のカードを目標に接続するリンクを見つけてください。それらの関係について考えてください。';

  @override
  String get guidedModeHint =>
      '選択する前にヒントを読んでください：現在のカードをターゲットに接続するリンクを探してください。';

  @override
  String get wellDone => 'よくできました！';

  @override
  String get keepTrying => '頑張り続けてください！上達しています！';

  @override
  String get excellent => '素晴らしい！';

  @override
  String get goodJob => 'いい仕事！';

  @override
  String get almostThere => 'もう少し！';

  @override
  String get thinkAgain => 'もう一度考えてください。これら2つを接続するものは何ですか？';

  @override
  String get accessibilityAndLanguage => 'アクセシビリティと言語';

  @override
  String get language => '言語';

  @override
  String get textSize => 'テキストサイズ';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get systemTheme => 'システム';

  @override
  String get lightThemeOption => 'ライト';

  @override
  String get darkThemeOption => 'ダーク';

  @override
  String get dynamicColors => '動的カラー';

  @override
  String get dynamicColorsSubtitle => '適応的なグラデーションとハイライトでインターフェースをブレンドします。';

  @override
  String get motionEffects => 'モーションとアニメーション';

  @override
  String get motionEffectsSubtitle => 'より落ち着いたUIを好む場合は、アニメーションを無効にしてください。';

  @override
  String get liveTournamentFeed => 'ライブトーナメントフィード';

  @override
  String get liveTournamentFeedEmpty =>
      'トーナメントが開始されると、ライブブラケットとマッチスパークがここに表示されます。';

  @override
  String get futurePlaybook => '未来のプレイブック';

  @override
  String get futurePlaybookSubtitle => '次の10年間に向けて準備された今後のトレンド';

  @override
  String get levelsChallenges => 'レベルとチャレンジ';

  @override
  String get levelsChallengesSubtitle => '構造化されたレベルとそのチャレンジを閲覧';

  @override
  String get close => '閉じる';

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
