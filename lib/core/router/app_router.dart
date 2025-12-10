import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/game_constants.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/guided_mode_screen.dart';
import '../../features/mode_selection/presentation/screens/mode_selection_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';
import '../../features/game/presentation/bloc/base_game_bloc.dart';
import '../../features/game/presentation/bloc/group_game_bloc.dart';
import '../../features/game/data/repositories/puzzle_repository.dart';
import '../../features/progression/data/services/progression_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/game/domain/entities/link_node.dart';
import '../../features/game/domain/entities/game_type.dart';
import '../../features/result/presentation/screens/result_screen.dart';
import '../../features/game/domain/entities/puzzle.dart';
import '../../features/progression/domain/entities/progression_summary.dart';
import '../../features/group/presentation/screens/join_game_screen.dart';
import '../../features/group/presentation/screens/create_group_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';
import '../../features/thinking_assistant/presentation/bloc/thinking_assistant_bloc.dart';
import '../../features/thinking_assistant/domain/services/hint_generator_service.dart';
import '../../features/group/data/services/family_session_storage.dart';
import '../../features/minigames/presentation/screens/minigame_hub_screen.dart';
import '../../features/tournament/presentation/screens/tournament_dashboard_screen.dart';
import '../../features/tournament/presentation/bloc/tournament_bloc.dart';
import '../../features/tournament/data/repositories/tournament_repository.dart';
import '../../features/multiplayer/data/services/cloudflare_multiplayer_service.dart';
import '../../features/game/presentation/screens/level_selection_screen.dart';

class AppRouter {
  static const Map<String, List<String>> _phaseCulturePacks = {
    'phase_1': ['History & Heritage'],
    'phase_2': ['Science & Technology'],
  };
  static const String home = AppConstants.routeHome;
  static const String modeSelection = AppConstants.routeModeSelection;
  static const String game = AppConstants.routeGame;
  static const String result = AppConstants.routeResult;
  static const String minigames = AppConstants.routeMinigames;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case modeSelection:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ModeSelectionScreen(
            gameMode: args?['gameMode'] ?? 'solo',
            maxLinksAllowed: args?['maxLinksAllowed'] ?? GameConstants.maxLinks,
          ),
        );
      case AppConstants.routeGuided:
        return MaterialPageRoute(
          builder: (_) => const GuidedModeScreen(),
        );
      case minigames:
        return MaterialPageRoute(
          builder: (_) => const MinigameHubScreen(),
        );

      case game:
        final args = settings.arguments as Map<String, dynamic>?;
        final gameMode = args?['gameMode'] ?? 'solo';
        return MaterialPageRoute(
          builder: (context) {
            // استخراج representationType بشكل صحيح
            RepresentationType representationType = RepresentationType.text;
            if (args?['representationType'] != null) {
              if (args!['representationType'] is RepresentationType) {
                representationType =
                    args['representationType'] as RepresentationType;
              } else if (args['representationType'] is String) {
                // تحويل من string إلى enum إذا لزم
                final typeStr = args['representationType'] as String;
                representationType = RepresentationType.values.firstWhere(
                  (e) => e.name == typeStr.toLowerCase(),
                  orElse: () => RepresentationType.text,
                );
              }
            }

            Widget screen = GameScreen(
              gameType: args?['gameType'] as GameType?,
              representationType: representationType,
              linksCount: args?['linksCount'] as int? ?? 3,
              gameMode: gameMode,
              playersCount: args?['playersCount'] as int?,
              category: args?['category'] as String?,
              groupProfile: args?['groupProfile'] as String?,
              customPlayers:
                  args?['customPlayers'] as List<Map<String, dynamic>>?,
              customPuzzle: args?['customPuzzle'] as Map<String, dynamic>?,
              brainGymTotalRounds: args?['brainGymTotalRounds'] as int?,
              brainGymCurrentRound: args?['brainGymCurrentRound'] as int?,
              brainGymAccumulatedScore:
                  args?['brainGymAccumulatedScore'] as int? ?? 0,
            );
            screen = BlocProvider(
              create: (_) => ThinkingAssistantBloc(
                service: const HintGeneratorService(),
              ),
              child: screen,
            );
            if (gameMode == 'group') {
              final repo = context.read<PuzzleRepository>();
              final progression = context.read<ProgressionService>();
              final adaptiveLearning =
                  context.read<AdaptiveLearningRepositoryInterface>();
              final playersCount =
                  (args?['playersCount'] as int?) ?? GameConstants.minPlayers;

              // استخراج Cloudflare multiplayer service و roomId
              CloudflareMultiplayerService? multiplayerService =
                  args?['multiplayerService'] as CloudflareMultiplayerService?;
              final String? roomId = args?['cloudflareRoomId'] as String?;

              // إذا كان هناك roomId لكن لا يوجد service، أنشئ service جديد
              if (roomId != null && multiplayerService == null) {
                multiplayerService = CloudflareMultiplayerService();
              }

              // إذا كان هناك service و roomId، اتصل بالغرفة
              if (multiplayerService != null && roomId != null) {
                // الحصول على player info من customPlayers
                final customPlayers =
                    args?['customPlayers'] as List<Map<String, dynamic>>?;
                if (customPlayers != null && customPlayers.isNotEmpty) {
                  final matchingHost = customPlayers.where((p) => p['isHost'] == true);
                  final hostPlayer = matchingHost.isNotEmpty
                      ? matchingHost.first
                      : customPlayers.first;

                  // الاتصال بالغرفة (async - سيتم في background)
                  multiplayerService
                      .connectToRoom(
                    roomId: roomId,
                    playerId: hostPlayer['id']?.toString() ?? '0',
                    playerName: hostPlayer['name']?.toString() ?? 'Player',
                  )
                      .catchError((error) {
                    debugPrint('Error connecting to Cloudflare room: $error');
                  });
                }
              }

              return BlocProvider<BaseGameBloc>(
                create: (_) => GroupGameBloc(
                  puzzleRepository: repo,
                  progressionService: progression,
                  playersCount: playersCount,
                  adaptiveLearningRepository: adaptiveLearning,
                  familySessionStorage: context.read<FamilySessionStorage>(),
                  phasePacks: _phaseCulturePacks,
                  multiplayerService: multiplayerService,
                ),
                child: screen,
              );
            }
            // Solo / other modes use the global GameBloc already provided.
            return screen;
          },
        );

      case result:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            puzzleId: args['puzzleId'],
            chosenNodes: args['chosenNodes'],
            score: args['score'],
            timeSpent: args['timeSpent'],
            isCompleted: args['isCompleted'],
            progression: args['progression'] as ProgressionSummary?,
            isDaily: args['isDaily'] as bool? ?? false,
            isBrainGym: args['isBrainGym'] as bool? ?? false,
            puzzle: args['puzzle'] as Puzzle?,
          ),
        );

      case AppConstants.routeJoinGame:
        return MaterialPageRoute(
          builder: (_) => const JoinGameScreen(),
        );

      case AppConstants.routeCreateGroup:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreateGroupScreen(
            maxLinksAllowed: args?['maxLinksAllowed'] ?? GameConstants.maxLinks,
          ),
        );

      case AppConstants.routeLeaderboard:
        return MaterialPageRoute(
          builder: (_) => const LeaderboardScreen(),
        );

      case AppConstants.routeTournaments:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TournamentBloc(
              repository: TournamentRepository(),
            ),
            child: const TournamentDashboardScreen(),
          ),
        );

      case AppConstants.routeLevelSelection:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final gameType = args['gameType'] as GameType? ?? GameType.mysteryLink;
        final title = args['title'] as String? ?? gameType.nameEn;
        return MaterialPageRoute(
          builder: (_) => LevelSelectionScreen(
            gameType: gameType,
            modeTitle: title,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
