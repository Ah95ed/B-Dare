// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'رابط الغموض';

  @override
  String get soloMode => 'وضع فردي';

  @override
  String get groupMode => 'وضع جماعي';

  @override
  String get practiceMode => 'وضع التدريب';

  @override
  String get startGame => 'بدء اللعبة';

  @override
  String get selectDifficulty => 'اختر الصعوبة';

  @override
  String get selectRepresentation => 'اختر نوع العرض';

  @override
  String get text => 'نص';

  @override
  String get icon => 'رمز';

  @override
  String get image => 'صورة';

  @override
  String get event => 'حدث';

  @override
  String get links => 'روابط';

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get step => 'خطوة';

  @override
  String get ofLabel => 'من';

  @override
  String get correct => 'صحيح!';

  @override
  String get wrong => 'خطأ!';

  @override
  String get timeOut => 'انتهى الوقت!';

  @override
  String get score => 'النقاط';

  @override
  String get timeSpent => 'الوقت المستغرق';

  @override
  String get correctChain => 'السلسلة الصحيحة';

  @override
  String get yourChoices => 'اختياراتك';

  @override
  String get playAgain => 'لعب مرة أخرى';

  @override
  String get share => 'مشاركة';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get selectPlayers => 'اختر عدد اللاعبين';

  @override
  String get player => 'لاعب';

  @override
  String get points => 'نقاط';

  @override
  String get nextPlayer => 'اللاعب التالي';

  @override
  String get gameOver => 'انتهت اللعبة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get perfectWin => 'ممتاز! أكملت السلسلة بشكل صحيح!';

  @override
  String get timeUpMessage => 'انتهى الوقت! لا تقلق، يمكنك المحاولة مرة أخرى.';

  @override
  String get tieMessage => 'تعادل! لعبة رائعة للجميع!';

  @override
  String get helpText =>
      'ابحث عن الرابط الذي يربط البطاقة الحالية بالهدف. فكر في العلاقة بينهما.';

  @override
  String get guidedModeHint =>
      'اقرأ التلميح قبل الاختيار: ابحث عن الرابط الذي يربط البطاقة الحالية بالهدف.';

  @override
  String get wellDone => 'أحسنت!';

  @override
  String get keepTrying => 'استمر في المحاولة! أنت تتحسن!';

  @override
  String get excellent => 'ممتاز!';

  @override
  String get goodJob => 'عمل جيد!';

  @override
  String get almostThere => 'أنت قريب!';

  @override
  String get thinkAgain => 'فكر مرة أخرى. ما الذي يربط بين هذين؟';

  @override
  String get accessibilityAndLanguage => 'إمكانية الوصول واللغة';

  @override
  String get language => 'اللغة';

  @override
  String get textSize => 'حجم النص';

  @override
  String get themeMode => 'مظهر التطبيق';

  @override
  String get systemTheme => 'النظام';

  @override
  String get lightThemeOption => 'فاتح';

  @override
  String get darkThemeOption => 'داكن';

  @override
  String get dynamicColors => 'ألوان ديناميكية';

  @override
  String get dynamicColorsSubtitle =>
      'ادمج الواجهة مع تدرجات وأضواء متغيرة حسب حالتك.';

  @override
  String get motionEffects => 'الحركة والمؤثرات';

  @override
  String get motionEffectsSubtitle =>
      'أوقف التحريكات إذا كنت تفضل تجربة أكثر هدوءًا.';

  @override
  String get liveTournamentFeed => 'بث البطولات الحي';

  @override
  String get liveTournamentFeedEmpty =>
      'سيظهر سير المباريات هنا فور انطلاق البطولات.';

  @override
  String get futurePlaybook => 'مفكرة المستقبل';

  @override
  String get futurePlaybookSubtitle =>
      'اتجاهات وتجارب جاهزة للعشر سنوات القادمة';

  @override
  String get levelsChallenges => 'المستويات والتحديات';

  @override
  String get levelsChallengesSubtitle => 'اختر المستوى والتحدي قبل بدء اللعب';

  @override
  String get close => 'إغلاق';

  @override
  String dailySessionStatusCompleted(int streak) {
    return 'أنهيت جلسة اليوم! سلسلة $streak يوم';
  }

  @override
  String dailySessionStatusNotStarted(int streak) {
    return 'لم تبدأ جلسة اليوم بعد · سلسلة حالية: $streak يوم';
  }

  @override
  String dailySessionTotalSessions(int count) {
    return 'إجمالي الجلسات: $count';
  }

  @override
  String get brainGymStartNow => 'ابدأ Brain Gym الآن';

  @override
  String familySessionsTitleWithProfile(String profile) {
    return 'جلسات $profile';
  }

  @override
  String get familySessionsTitleDefault => 'جلسات العائلة';

  @override
  String get sessionsLabel => 'الجلسات';

  @override
  String get winsLabel => 'الانتصارات';

  @override
  String get lastSessionLabel => 'آخر جلسة';

  @override
  String familyWeeklyGoal(int wins) {
    return 'هدف هذا الأسبوع: اربحوا 3 جلسات عائلية. التقدم الحالي $wins/3.';
  }

  @override
  String familyWinsSessionsSummary(int wins, int sessions) {
    return 'انتصارات: $wins / جلسات: $sessions';
  }

  @override
  String get familyNoSessionYet => 'ابدأوا أول جلسة لكم اليوم!';

  @override
  String get familyStartNewSession => 'ابدأ جلسة جديدة';

  @override
  String get keepPlayingToMaintainProgress =>
      'استمر في اللعب للحفاظ على تقدمك!';

  @override
  String get guidedModeTitle => 'الوضع الموجّه';

  @override
  String get guidedModeDescription =>
      'خطوات مبسّطة وتلميحات للأعمار الصغيرة والمبتدئين.';

  @override
  String get soloModeDescription => 'العب منفرداً وتحدَّ نفسك';

  @override
  String get createGroupTitle => 'إنشاء مجموعة';

  @override
  String get createGroupDescription => 'أنشئ لعبة جماعية مع الأصدقاء';

  @override
  String get globalTournamentsTitle => 'المسابقات العالمية';

  @override
  String get globalTournamentsDescription =>
      'شارك في المسابقات العالمية وكن بطل العالم';

  @override
  String get progressKeepPlayingHint =>
      'تابع التحديات اليومية والإنجازات الجديدة لتحافظ على حماسك.';

  @override
  String get brainGymSessionCompletedFinal => '🎯 انهيت جلسة Brain Gym!';

  @override
  String get brainGymPerfectRoundHeadline => '💪 جولة مثالية!';

  @override
  String get brainGymNewRoundHeadline => 'أحسنت! جولة Brain Gym جديدة';

  @override
  String brainGymCurrentStreak(int streak) {
    return 'سلسلتك الحالية: $streak يوم';
  }

  @override
  String get brainGymStartNewStreak => 'ابدأ سلسلة جديدة اليوم';

  @override
  String brainGymRoundProgress(int current, int total, int score) {
    return 'Round $current of $total · Session score: $score';
  }

  @override
  String brainGymTotalSessions(int total) {
    return 'إجمالي جلسات التدريب: $total';
  }

  @override
  String get guidedModeIntroStep1 =>
      'استمع للتعليمات القصيرة ثم اقرأ نقطة البداية والنهاية.';

  @override
  String get guidedModeIntroStep2 =>
      'اختر الرابط الصحيح من بين ثلاثة خيارات مبسّطة.';

  @override
  String get guidedModeIntroStep3 =>
      'إن أخطأت ستحصل على تلميح فوري يساعدك في المحاولة القادمة.';

  @override
  String get guidedModeLongDescription =>
      'تجربة مناسبة للأعمار الصغيرة والمستخدمين الجدد. يركّز هذا الوضع على سلاسل قصيرة مع تلميحات مرئية وصوتية.';

  @override
  String get guidedModeStartSession => 'ابدأ الجلسة الموجهة';

  @override
  String get selectGameTypeTitle => 'اختر نوع اللعبة';

  @override
  String familySessionTitleWithProfileInGame(String profile) {
    return 'فريق $profile';
  }

  @override
  String get familySessionTitleInGame => 'جلسة العائلة';

  @override
  String get sessionsShortLabel => 'جلسات';

  @override
  String get winsShortLabel => 'انتصارات';

  @override
  String get lossesShortLabel => 'خسائر';

  @override
  String get lastSessionShort => 'اخر جلسة';

  @override
  String relativeMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String relativeHours(int hours) {
    return '$hours ساعة';
  }

  @override
  String relativeDays(int days) {
    return '$days يوم';
  }

  @override
  String get matchNotReady => 'المباراة غير جاهزة بعد';

  @override
  String matchStartFailed(String error) {
    return 'فشل بدء المباراة: $error';
  }

  @override
  String matchJoinFailed(String error) {
    return 'فشل الانضمام للمباراة: $error';
  }

  @override
  String get tournamentGlobalTitle => 'المسابقات العالمية';

  @override
  String get tournamentNoTournaments => 'لا توجد مسابقات';

  @override
  String get tournamentFilterLabel => 'التصفية:';

  @override
  String get tournamentFilterAll => 'الكل';

  @override
  String get tournamentFilterRegistration => 'التسجيل';

  @override
  String get tournamentFilterQualifiers => 'التصفيات';

  @override
  String get tournamentFilterFinal => 'النهائي';

  @override
  String get tournamentFilterCompleted => 'مكتملة';

  @override
  String get tournamentEmptyTitle => 'لا توجد مسابقات حالياً';

  @override
  String get tournamentCreateNew => 'إنشاء بطولة جديدة';

  @override
  String get tournamentStagesSectionTitle => 'المراحل';

  @override
  String tournamentTeamsSectionTitle(int count, int max) {
    return 'الفرق ($count/$max)';
  }

  @override
  String tournamentViewAllTeams(int count) {
    return 'عرض جميع الفرق ($count)';
  }

  @override
  String get tournamentBracketTitle => 'شجرة التصفيات';

  @override
  String get tournamentBracketUnavailable => 'شجرة التصفيات غير متاحة بعد';

  @override
  String get tournamentViewBracket => 'عرض شجرة التصفيات';

  @override
  String get tournamentStart => 'بدء البطولة';

  @override
  String get back => 'رجوع';

  @override
  String get tournamentStatusRegistration => 'التسجيل';

  @override
  String get tournamentStatusQualifiers => 'التصفيات';

  @override
  String get tournamentStatusPlayoffs => 'التصفيات النهائية';

  @override
  String get tournamentStatusFinal => 'النهائي';

  @override
  String get tournamentStatusCompleted => 'مكتملة';

  @override
  String get tournamentStatusCancelled => 'ملغاة';

  @override
  String get tournamentMatchStatusScheduled => 'مجدولة';

  @override
  String get tournamentMatchStatusInProgress => 'قيد التقدم';

  @override
  String get tournamentMatchStatusCompleted => 'مكتملة';

  @override
  String get tournamentMatchStatusForfeit => 'إلغاء';

  @override
  String get tournamentMatchStatusCancelled => 'ملغاة';

  @override
  String get tournamentStatsTeams => 'الفرق';

  @override
  String get tournamentStatsStages => 'المراحل';

  @override
  String get tournamentStatsType => 'النوع';

  @override
  String get tournamentTypeSingleElimination => 'إقصاء فردي';

  @override
  String get tournamentTypeDoubleElimination => 'إقصاء مزدوج';

  @override
  String get tournamentTypeSwiss => 'سويسري';

  @override
  String get tournamentTypeRoundRobin => 'دوري';

  @override
  String stageRoundProgress(int current, int total) {
    return 'الجولة $current/$total';
  }

  @override
  String get matchesLabel => 'مباريات';

  @override
  String get stageStatusNotStarted => 'لم تبدأ';

  @override
  String get stageStatusInProgress => 'جارية';

  @override
  String get stageStatusCompleted => 'مكتملة';

  @override
  String relativeInDays(int days) {
    return 'بعد $days يوم';
  }

  @override
  String relativeInHours(int hours) {
    return 'بعد $hours ساعة';
  }

  @override
  String relativeInMinutes(int minutes) {
    return 'بعد $minutes دقيقة';
  }

  @override
  String get relativeStarted => 'بدأت';

  @override
  String get relativeNow => 'الآن';

  @override
  String get matchTitle => 'المباراة';

  @override
  String get matchStart => 'بدء المباراة';

  @override
  String get matchJoin => 'الانضمام للمباراة';

  @override
  String get samplePuzzleLoaded => 'تم تحميل لغز تدريبي';
}
