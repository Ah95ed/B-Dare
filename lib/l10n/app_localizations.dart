import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Mystery Link'**
  String get appName;

  /// No description provided for @soloMode.
  ///
  /// In en, this message translates to:
  /// **'Solo Mode'**
  String get soloMode;

  /// No description provided for @groupMode.
  ///
  /// In en, this message translates to:
  /// **'Group Mode'**
  String get groupMode;

  /// No description provided for @practiceMode.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get practiceMode;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @selectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get selectDifficulty;

  /// No description provided for @selectRepresentation.
  ///
  /// In en, this message translates to:
  /// **'Select Representation Type'**
  String get selectRepresentation;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong!'**
  String get wrong;

  /// No description provided for @timeOut.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get timeOut;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// No description provided for @correctChain.
  ///
  /// In en, this message translates to:
  /// **'Correct Chain'**
  String get correctChain;

  /// No description provided for @yourChoices.
  ///
  /// In en, this message translates to:
  /// **'Your Choices'**
  String get yourChoices;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @selectPlayers.
  ///
  /// In en, this message translates to:
  /// **'Select Number of Players'**
  String get selectPlayers;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @nextPlayer.
  ///
  /// In en, this message translates to:
  /// **'Next Player'**
  String get nextPlayer;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Message shown when player completes puzzle with all correct answers
  ///
  /// In en, this message translates to:
  /// **'Perfect! You completed the chain correctly!'**
  String get perfectWin;

  /// Message shown when time runs out
  ///
  /// In en, this message translates to:
  /// **'Time\'s up! Don\'t worry, you can try again.'**
  String get timeUpMessage;

  /// Message shown when players tie in group mode
  ///
  /// In en, this message translates to:
  /// **'It\'s a tie! Great game everyone!'**
  String get tieMessage;

  /// Help text for beginners
  ///
  /// In en, this message translates to:
  /// **'Find the link that connects the current card to the goal. Think about the relationship between them.'**
  String get helpText;

  /// Hint shown in guided mode
  ///
  /// In en, this message translates to:
  /// **'Read the hint before choosing: Look for the link that connects the current card to the target.'**
  String get guidedModeHint;

  /// Encouragement message
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get wellDone;

  /// Encouragement message after wrong answer
  ///
  /// In en, this message translates to:
  /// **'Keep trying! You\'re getting better!'**
  String get keepTrying;

  /// Praise message
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get excellent;

  /// Praise message
  ///
  /// In en, this message translates to:
  /// **'Good job!'**
  String get goodJob;

  /// Encouragement when close to correct answer
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get almostThere;

  /// Hint when answer is wrong
  ///
  /// In en, this message translates to:
  /// **'Think again. What connects these two?'**
  String get thinkAgain;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Accessibility & Language'**
  String get accessibilityAndLanguage;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for text size
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// Theme selection label
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Light theme option label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightThemeOption;

  /// Dark theme option label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkThemeOption;

  /// Label for dynamic color setting
  ///
  /// In en, this message translates to:
  /// **'Dynamic Colors'**
  String get dynamicColors;

  /// Subtitle for dynamic color setting
  ///
  /// In en, this message translates to:
  /// **'Blend the interface with adaptive gradients and highlights.'**
  String get dynamicColorsSubtitle;

  /// Label for motion effects toggle
  ///
  /// In en, this message translates to:
  /// **'Motion & Animations'**
  String get motionEffects;

  /// Subtitle for motion effects toggle
  ///
  /// In en, this message translates to:
  /// **'Disable animations if you prefer a calmer UI.'**
  String get motionEffectsSubtitle;

  /// Title for live tournament ticker
  ///
  /// In en, this message translates to:
  /// **'Live Tournament Feed'**
  String get liveTournamentFeed;

  /// Empty state message for live ticker
  ///
  /// In en, this message translates to:
  /// **'Live brackets and match sparks will appear here once tournaments start.'**
  String get liveTournamentFeedEmpty;

  /// Title for future trends card
  ///
  /// In en, this message translates to:
  /// **'Future Playbook'**
  String get futurePlaybook;

  /// Subtitle for future trends card
  ///
  /// In en, this message translates to:
  /// **'Upcoming trends prepared for the next decade'**
  String get futurePlaybookSubtitle;

  /// No description provided for @levelsChallenges.
  ///
  /// In en, this message translates to:
  /// **'Levels & Challenges'**
  String get levelsChallenges;

  /// No description provided for @levelsChallengesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse structured levels and their challenges'**
  String get levelsChallengesSubtitle;

  /// Button to close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Status text when daily session is completed
  ///
  /// In en, this message translates to:
  /// **'You finished today’s session! {streak} day streak'**
  String dailySessionStatusCompleted(int streak);

  /// Status text when daily session not started
  ///
  /// In en, this message translates to:
  /// **'You haven’t started today’s session yet · Current streak: {streak} days'**
  String dailySessionStatusNotStarted(int streak);

  /// Total number of sessions played
  ///
  /// In en, this message translates to:
  /// **'Total sessions: {count}'**
  String dailySessionTotalSessions(int count);

  /// CTA button to start Brain Gym session
  ///
  /// In en, this message translates to:
  /// **'Start Brain Gym now'**
  String get brainGymStartNow;

  /// Title for family sessions card with profile name
  ///
  /// In en, this message translates to:
  /// **'{profile} sessions'**
  String familySessionsTitleWithProfile(String profile);

  /// Default title for family sessions card
  ///
  /// In en, this message translates to:
  /// **'Family sessions'**
  String get familySessionsTitleDefault;

  /// Label for sessions count
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsLabel;

  /// Label for wins count
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsLabel;

  /// Label for last session date
  ///
  /// In en, this message translates to:
  /// **'Last session'**
  String get lastSessionLabel;

  /// Weekly family goal text
  ///
  /// In en, this message translates to:
  /// **'This week’s goal: win 3 family sessions. Current progress {wins}/3.'**
  String familyWeeklyGoal(int wins);

  /// Summary of wins and sessions for family stats
  ///
  /// In en, this message translates to:
  /// **'Wins: {wins} / Sessions: {sessions}'**
  String familyWinsSessionsSummary(int wins, int sessions);

  /// Message shown when no family session yet
  ///
  /// In en, this message translates to:
  /// **'Start your first family session today!'**
  String get familyNoSessionYet;

  /// Button label to start a new family session
  ///
  /// In en, this message translates to:
  /// **'Start new session'**
  String get familyStartNewSession;

  /// Encouragement text when progression goals are clear
  ///
  /// In en, this message translates to:
  /// **'Keep playing to maintain your progress!'**
  String get keepPlayingToMaintainProgress;

  /// Title for guided mode item
  ///
  /// In en, this message translates to:
  /// **'Guided Mode'**
  String get guidedModeTitle;

  /// Description for guided mode
  ///
  /// In en, this message translates to:
  /// **'Simplified steps and hints for younger players and beginners.'**
  String get guidedModeDescription;

  /// Description under Solo mode
  ///
  /// In en, this message translates to:
  /// **'Play alone and challenge yourself'**
  String get soloModeDescription;

  /// Title for create group mode
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupTitle;

  /// Description for create group mode
  ///
  /// In en, this message translates to:
  /// **'Create a group game with friends'**
  String get createGroupDescription;

  /// Title for global tournaments section
  ///
  /// In en, this message translates to:
  /// **'Global Tournaments'**
  String get globalTournamentsTitle;

  /// Description for global tournaments CTA
  ///
  /// In en, this message translates to:
  /// **'Join global tournaments and become world champion'**
  String get globalTournamentsDescription;

  /// Hint encouraging user to keep playing to progress
  ///
  /// In en, this message translates to:
  /// **'Keep playing to keep your momentum!'**
  String get progressKeepPlayingHint;

  /// Headline when Brain Gym session is finished
  ///
  /// In en, this message translates to:
  /// **'🎯 You finished your Brain Gym session!'**
  String get brainGymSessionCompletedFinal;

  /// Headline when the last round was perfect
  ///
  /// In en, this message translates to:
  /// **'💪 Perfect round!'**
  String get brainGymPerfectRoundHeadline;

  /// Headline for a regular Brain Gym round
  ///
  /// In en, this message translates to:
  /// **'Great! New Brain Gym round'**
  String get brainGymNewRoundHeadline;

  /// Text showing current Brain Gym streak
  ///
  /// In en, this message translates to:
  /// **'Your current streak: {streak} days'**
  String brainGymCurrentStreak(int streak);

  /// Text inviting user to start a new streak
  ///
  /// In en, this message translates to:
  /// **'Start a new streak today'**
  String get brainGymStartNewStreak;

  /// Round progress text for Brain Gym
  ///
  /// In en, this message translates to:
  /// **'Round {current} of {total} · Session score: {score}'**
  String brainGymRoundProgress(int current, int total, int score);

  /// Total Brain Gym sessions completed
  ///
  /// In en, this message translates to:
  /// **'Total training sessions: {total}'**
  String brainGymTotalSessions(int total);

  /// Guided mode step 1
  ///
  /// In en, this message translates to:
  /// **'Listen to the short instructions, then read the start and end points.'**
  String get guidedModeIntroStep1;

  /// Guided mode step 2
  ///
  /// In en, this message translates to:
  /// **'Choose the correct link from three simplified options.'**
  String get guidedModeIntroStep2;

  /// Guided mode step 3
  ///
  /// In en, this message translates to:
  /// **'If you make a mistake, you will get an instant hint to help next time.'**
  String get guidedModeIntroStep3;

  /// Long description for guided mode intro screen
  ///
  /// In en, this message translates to:
  /// **'An experience suitable for younger players and new users. This mode focuses on short chains with visual and audio hints.'**
  String get guidedModeLongDescription;

  /// Button label to start guided session
  ///
  /// In en, this message translates to:
  /// **'Start guided session'**
  String get guidedModeStartSession;

  /// Title above game type selector
  ///
  /// In en, this message translates to:
  /// **'Choose game type'**
  String get selectGameTypeTitle;

  /// Title in game screen when playing family session with profile name
  ///
  /// In en, this message translates to:
  /// **'{profile} team'**
  String familySessionTitleWithProfileInGame(String profile);

  /// Default family session title in game screen
  ///
  /// In en, this message translates to:
  /// **'Family session'**
  String get familySessionTitleInGame;

  /// Short label for sessions (stats chips)
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsShortLabel;

  /// Short label for wins (stats chips)
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get winsShortLabel;

  /// Short label for losses (stats chips)
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get lossesShortLabel;

  /// Short label for last session in game screen
  ///
  /// In en, this message translates to:
  /// **'Last session'**
  String get lastSessionShort;

  /// Relative time in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String relativeMinutes(int minutes);

  /// Relative time in hours
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String relativeHours(int hours);

  /// Relative time in days
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String relativeDays(int days);

  /// Error when match is not ready
  ///
  /// In en, this message translates to:
  /// **'Match is not ready yet'**
  String get matchNotReady;

  /// Error when starting match fails
  ///
  /// In en, this message translates to:
  /// **'Failed to start match: {error}'**
  String matchStartFailed(String error);

  /// Error when joining match fails
  ///
  /// In en, this message translates to:
  /// **'Failed to join match: {error}'**
  String matchJoinFailed(String error);

  /// App bar title for tournament dashboard
  ///
  /// In en, this message translates to:
  /// **'Global Tournaments'**
  String get tournamentGlobalTitle;

  /// Message when there are no tournaments in builder
  ///
  /// In en, this message translates to:
  /// **'No tournaments'**
  String get tournamentNoTournaments;

  /// Label before tournament filter chips
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get tournamentFilterLabel;

  /// Filter chip - all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tournamentFilterAll;

  /// Filter chip - registration
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get tournamentFilterRegistration;

  /// Filter chip - qualifiers
  ///
  /// In en, this message translates to:
  /// **'Qualifiers'**
  String get tournamentFilterQualifiers;

  /// Filter chip - final
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get tournamentFilterFinal;

  /// Filter chip - completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tournamentFilterCompleted;

  /// Title when tournaments list is empty
  ///
  /// In en, this message translates to:
  /// **'No tournaments at the moment'**
  String get tournamentEmptyTitle;

  /// Button label to create new tournament
  ///
  /// In en, this message translates to:
  /// **'Create new tournament'**
  String get tournamentCreateNew;

  /// Title for stages section
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get tournamentStagesSectionTitle;

  /// Title for teams section with counts
  ///
  /// In en, this message translates to:
  /// **'Teams ({count}/{max})'**
  String tournamentTeamsSectionTitle(int count, int max);

  /// Button text to view all teams
  ///
  /// In en, this message translates to:
  /// **'View all teams ({count})'**
  String tournamentViewAllTeams(int count);

  /// Title for bracket section
  ///
  /// In en, this message translates to:
  /// **'Bracket'**
  String get tournamentBracketTitle;

  /// Message when bracket is unavailable
  ///
  /// In en, this message translates to:
  /// **'Bracket is not available yet'**
  String get tournamentBracketUnavailable;

  /// Button to view bracket
  ///
  /// In en, this message translates to:
  /// **'View bracket'**
  String get tournamentViewBracket;

  /// Button to start tournament
  ///
  /// In en, this message translates to:
  /// **'Start tournament'**
  String get tournamentStart;

  /// Generic back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Status label for registration
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get tournamentStatusRegistration;

  /// Status label for qualifiers
  ///
  /// In en, this message translates to:
  /// **'Qualifiers'**
  String get tournamentStatusQualifiers;

  /// Status label for playoffs/final stage
  ///
  /// In en, this message translates to:
  /// **'Playoffs'**
  String get tournamentStatusPlayoffs;

  /// Status label for final stage
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get tournamentStatusFinal;

  /// Status label for completed tournaments
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tournamentStatusCompleted;

  /// Status label for cancelled tournaments
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tournamentStatusCancelled;

  /// Match status scheduled
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get tournamentMatchStatusScheduled;

  /// Match status in progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tournamentMatchStatusInProgress;

  /// Match status completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tournamentMatchStatusCompleted;

  /// Match status forfeit
  ///
  /// In en, this message translates to:
  /// **'Forfeit'**
  String get tournamentMatchStatusForfeit;

  /// Match status cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tournamentMatchStatusCancelled;

  /// Label for teams stat
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get tournamentStatsTeams;

  /// Label for stages stat
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get tournamentStatsStages;

  /// Label for type stat
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tournamentStatsType;

  /// Tournament type single elimination
  ///
  /// In en, this message translates to:
  /// **'Single Elimination'**
  String get tournamentTypeSingleElimination;

  /// Tournament type double elimination
  ///
  /// In en, this message translates to:
  /// **'Double Elimination'**
  String get tournamentTypeDoubleElimination;

  /// Tournament type Swiss
  ///
  /// In en, this message translates to:
  /// **'Swiss'**
  String get tournamentTypeSwiss;

  /// Tournament type round robin
  ///
  /// In en, this message translates to:
  /// **'Round Robin'**
  String get tournamentTypeRoundRobin;

  /// Stage round progress label
  ///
  /// In en, this message translates to:
  /// **'Round {current}/{total}'**
  String stageRoundProgress(int current, int total);

  /// Label for number of matches
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matchesLabel;

  /// Stage status not started
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get stageStatusNotStarted;

  /// Stage status in progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get stageStatusInProgress;

  /// Stage status completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get stageStatusCompleted;

  /// Relative time in days (future)
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String relativeInDays(int days);

  /// Relative time in hours (future)
  ///
  /// In en, this message translates to:
  /// **'In {hours} hours'**
  String relativeInHours(int hours);

  /// Relative time in minutes (future)
  ///
  /// In en, this message translates to:
  /// **'In {minutes} minutes'**
  String relativeInMinutes(int minutes);

  /// Label when event has started
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get relativeStarted;

  /// Label for now
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get relativeNow;

  /// Title for match screen
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchTitle;

  /// Button label to start match
  ///
  /// In en, this message translates to:
  /// **'Start match'**
  String get matchStart;

  /// Button label to join match
  ///
  /// In en, this message translates to:
  /// **'Join match'**
  String get matchJoin;

  /// Message shown when a practice puzzle is loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded a practice puzzle'**
  String get samplePuzzleLoaded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'pl',
        'pt',
        'ru',
        'th',
        'tr',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
