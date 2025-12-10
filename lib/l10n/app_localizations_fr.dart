// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Lien Mystère';

  @override
  String get soloMode => 'Mode Solo';

  @override
  String get groupMode => 'Mode Groupe';

  @override
  String get practiceMode => 'Mode Pratique';

  @override
  String get startGame => 'Démarrer le Jeu';

  @override
  String get selectDifficulty => 'Sélectionner la Difficulté';

  @override
  String get selectRepresentation => 'Sélectionner le Type de Représentation';

  @override
  String get text => 'Texte';

  @override
  String get icon => 'Icône';

  @override
  String get image => 'Image';

  @override
  String get event => 'Événement';

  @override
  String get links => 'Liens';

  @override
  String get timeRemaining => 'Temps Restant';

  @override
  String get step => 'Étape';

  @override
  String get ofLabel => 'de';

  @override
  String get correct => 'Correct !';

  @override
  String get wrong => 'Incorrect !';

  @override
  String get timeOut => 'Le Temps est Écoulé !';

  @override
  String get score => 'Score';

  @override
  String get timeSpent => 'Temps Passé';

  @override
  String get correctChain => 'Chaîne Correcte';

  @override
  String get yourChoices => 'Vos Choix';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get share => 'Partager';

  @override
  String get backToHome => 'Retour à l\'Accueil';

  @override
  String get selectPlayers => 'Sélectionner le Nombre de Joueurs';

  @override
  String get player => 'Joueur';

  @override
  String get points => 'Points';

  @override
  String get nextPlayer => 'Joueur Suivant';

  @override
  String get gameOver => 'Jeu Terminé';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get perfectWin =>
      'Parfait ! Vous avez complété la chaîne correctement !';

  @override
  String get timeUpMessage =>
      'Le temps est écoulé ! Ne vous inquiétez pas, vous pouvez réessayer.';

  @override
  String get tieMessage => 'C\'est une égalité ! Excellent jeu à tous !';

  @override
  String get helpText =>
      'Trouvez le lien qui connecte la carte actuelle à l\'objectif. Pensez à la relation entre eux.';

  @override
  String get guidedModeHint =>
      'Lisez l\'indice avant de choisir : Cherchez le lien qui connecte la carte actuelle à la cible.';

  @override
  String get wellDone => 'Bien joué !';

  @override
  String get keepTrying => 'Continuez d\'essayer ! Vous vous améliorez !';

  @override
  String get excellent => 'Excellent !';

  @override
  String get goodJob => 'Bon travail !';

  @override
  String get almostThere => 'Presque là !';

  @override
  String get thinkAgain =>
      'Réfléchissez à nouveau. Qu\'est-ce qui connecte ces deux ?';

  @override
  String get accessibilityAndLanguage => 'Accessibilité et Langue';

  @override
  String get language => 'Langue';

  @override
  String get textSize => 'Taille du Texte';

  @override
  String get themeMode => 'Mode d’apparence';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightThemeOption => 'Clair';

  @override
  String get darkThemeOption => 'Sombre';

  @override
  String get dynamicColors => 'Couleurs dynamiques';

  @override
  String get dynamicColorsSubtitle =>
      'Fusionnez l’interface avec des dégradés adaptatifs.';

  @override
  String get motionEffects => 'Mouvement et animations';

  @override
  String get motionEffectsSubtitle =>
      'Désactivez les animations si vous préférez une interface calme.';

  @override
  String get liveTournamentFeed => 'Flux de tournois en direct';

  @override
  String get liveTournamentFeedEmpty =>
      'Les tableaux et matchs en direct apparaîtront ici lorsque les tournois commenceront.';

  @override
  String get futurePlaybook => 'Carnet du futur';

  @override
  String get futurePlaybookSubtitle =>
      'Tendances prévues pour la prochaine décennie';

  @override
  String get levelsChallenges => 'Niveaux et défis';

  @override
  String get levelsChallengesSubtitle =>
      'Parcourez les niveaux structurés avant de jouer';

  @override
  String get close => 'Fermer';

  @override
  String dailySessionStatusCompleted(int streak) {
    return 'Vous avez terminé la session d\'aujourd\'hui ! Série de $streak jours';
  }

  @override
  String dailySessionStatusNotStarted(int streak) {
    return 'Vous n\'avez pas encore commencé la session d\'aujourd\'hui · Série actuelle : $streak jours';
  }

  @override
  String dailySessionTotalSessions(int count) {
    return 'Total de sessions : $count';
  }

  @override
  String get brainGymStartNow => 'Démarrer Brain Gym maintenant';

  @override
  String familySessionsTitleWithProfile(String profile) {
    return 'Sessions $profile';
  }

  @override
  String get familySessionsTitleDefault => 'Sessions familiales';

  @override
  String get sessionsLabel => 'Sessions';

  @override
  String get winsLabel => 'Victoires';

  @override
  String get lastSessionLabel => 'Dernière session';

  @override
  String familyWeeklyGoal(int wins) {
    return 'Objectif de cette semaine : gagner 3 sessions familiales. Progrès actuel $wins/3.';
  }

  @override
  String familyWinsSessionsSummary(int wins, int sessions) {
    return 'Victoires : $wins / Sessions : $sessions';
  }

  @override
  String get familyNoSessionYet =>
      'Commencez votre première session familiale aujourd\'hui !';

  @override
  String get familyStartNewSession => 'Démarrer une nouvelle session';

  @override
  String get keepPlayingToMaintainProgress =>
      'Continuez à jouer pour maintenir votre progression !';

  @override
  String get guidedModeTitle => 'Mode Guidé';

  @override
  String get guidedModeDescription =>
      'Étapes simplifiées et indices pour les joueurs plus jeunes et les débutants.';

  @override
  String get soloModeDescription => 'Jouez seul et défiez-vous';

  @override
  String get createGroupTitle => 'Créer un Groupe';

  @override
  String get createGroupDescription => 'Créez un jeu de groupe avec des amis';

  @override
  String get globalTournamentsTitle => 'Tournois Mondiaux';

  @override
  String get globalTournamentsDescription =>
      'Rejoignez les tournois mondiaux et devenez champion du monde';

  @override
  String get progressKeepPlayingHint =>
      'Continuez à jouer pour maintenir votre élan !';

  @override
  String get brainGymSessionCompletedFinal =>
      '🎯 Vous avez terminé votre session Brain Gym !';

  @override
  String get brainGymPerfectRoundHeadline => '💪 Ronde parfaite !';

  @override
  String get brainGymNewRoundHeadline => 'Super ! Nouvelle ronde Brain Gym';

  @override
  String brainGymCurrentStreak(int streak) {
    return 'Votre série actuelle : $streak jours';
  }

  @override
  String get brainGymStartNewStreak =>
      'Commencez une nouvelle série aujourd\'hui';

  @override
  String brainGymRoundProgress(int current, int total, int score) {
    return 'Ronde $current sur $total · Score de session : $score';
  }

  @override
  String brainGymTotalSessions(int total) {
    return 'Total de sessions d\'entraînement : $total';
  }

  @override
  String get guidedModeIntroStep1 =>
      'Écoutez les instructions courtes, puis lisez les points de départ et d\'arrivée.';

  @override
  String get guidedModeIntroStep2 =>
      'Choisissez le bon lien parmi trois options simplifiées.';

  @override
  String get guidedModeIntroStep3 =>
      'Si vous faites une erreur, vous obtiendrez un indice instantané pour vous aider la prochaine fois.';

  @override
  String get guidedModeLongDescription =>
      'Une expérience adaptée aux joueurs plus jeunes et aux nouveaux utilisateurs. Ce mode se concentre sur des chaînes courtes avec des indices visuels et audio.';

  @override
  String get guidedModeStartSession => 'Démarrer la session guidée';

  @override
  String get selectGameTypeTitle => 'Choisir le type de jeu';

  @override
  String familySessionTitleWithProfileInGame(String profile) {
    return 'Équipe $profile';
  }

  @override
  String get familySessionTitleInGame => 'Session familiale';

  @override
  String get sessionsShortLabel => 'Sessions';

  @override
  String get winsShortLabel => 'Victoires';

  @override
  String get lossesShortLabel => 'Défaites';

  @override
  String get lastSessionShort => 'Dernière session';

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
    return '$days j';
  }

  @override
  String get matchNotReady => 'Le match n\'est pas encore prêt';

  @override
  String matchStartFailed(String error) {
    return 'Échec du démarrage du match : $error';
  }

  @override
  String matchJoinFailed(String error) {
    return 'Échec de la jonction au match : $error';
  }

  @override
  String get tournamentGlobalTitle => 'Tournois Mondiaux';

  @override
  String get tournamentNoTournaments => 'Aucun tournoi';

  @override
  String get tournamentFilterLabel => 'Filtre :';

  @override
  String get tournamentFilterAll => 'Tous';

  @override
  String get tournamentFilterRegistration => 'Inscription';

  @override
  String get tournamentFilterQualifiers => 'Qualifications';

  @override
  String get tournamentFilterFinal => 'Finale';

  @override
  String get tournamentFilterCompleted => 'Terminés';

  @override
  String get tournamentEmptyTitle => 'Aucun tournoi pour le moment';

  @override
  String get tournamentCreateNew => 'Créer un nouveau tournoi';

  @override
  String get tournamentStagesSectionTitle => 'Étapes';

  @override
  String tournamentTeamsSectionTitle(int count, int max) {
    return 'Équipes ($count/$max)';
  }

  @override
  String tournamentViewAllTeams(int count) {
    return 'Voir toutes les équipes ($count)';
  }

  @override
  String get tournamentBracketTitle => 'Tableau';

  @override
  String get tournamentBracketUnavailable =>
      'Le tableau n\'est pas encore disponible';

  @override
  String get tournamentViewBracket => 'Voir le tableau';

  @override
  String get tournamentStart => 'Démarrer le tournoi';

  @override
  String get back => 'Retour';

  @override
  String get tournamentStatusRegistration => 'Inscription';

  @override
  String get tournamentStatusQualifiers => 'Qualifications';

  @override
  String get tournamentStatusPlayoffs => 'Playoffs';

  @override
  String get tournamentStatusFinal => 'Finale';

  @override
  String get tournamentStatusCompleted => 'Terminés';

  @override
  String get tournamentStatusCancelled => 'Annulés';

  @override
  String get tournamentMatchStatusScheduled => 'Programmé';

  @override
  String get tournamentMatchStatusInProgress => 'En cours';

  @override
  String get tournamentMatchStatusCompleted => 'Terminé';

  @override
  String get tournamentMatchStatusForfeit => 'Forfait';

  @override
  String get tournamentMatchStatusCancelled => 'Annulé';

  @override
  String get tournamentStatsTeams => 'Équipes';

  @override
  String get tournamentStatsStages => 'Étapes';

  @override
  String get tournamentStatsType => 'Type';

  @override
  String get tournamentTypeSingleElimination => 'Élimination Simple';

  @override
  String get tournamentTypeDoubleElimination => 'Élimination Double';

  @override
  String get tournamentTypeSwiss => 'Suisse';

  @override
  String get tournamentTypeRoundRobin => 'Round Robin';

  @override
  String stageRoundProgress(int current, int total) {
    return 'Ronde $current/$total';
  }

  @override
  String get matchesLabel => 'Matchs';

  @override
  String get stageStatusNotStarted => 'Non démarré';

  @override
  String get stageStatusInProgress => 'En cours';

  @override
  String get stageStatusCompleted => 'Terminé';

  @override
  String relativeInDays(int days) {
    return 'Dans $days jours';
  }

  @override
  String relativeInHours(int hours) {
    return 'Dans $hours heures';
  }

  @override
  String relativeInMinutes(int minutes) {
    return 'Dans $minutes minutes';
  }

  @override
  String get relativeStarted => 'Démarré';

  @override
  String get relativeNow => 'Maintenant';

  @override
  String get matchTitle => 'Match';

  @override
  String get matchStart => 'Démarrer le match';

  @override
  String get matchJoin => 'Rejoindre le match';

  @override
  String get samplePuzzleLoaded => 'Un puzzle d\'entraînement a été chargé';
}
