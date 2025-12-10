import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/settings/app_settings_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/bloc/base_game_bloc.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/game/data/repositories/puzzle_repository.dart';
import 'features/game/data/datasources/local_puzzle_datasource.dart';
import 'features/progression/data/services/progression_service.dart';
import 'l10n/app_localizations.dart';
import 'features/adaptive_learning/data/repositories/adaptive_learning_repository.dart';
import 'features/adaptive_learning/domain/repositories/adaptive_learning_repository_interface.dart';
import 'features/adaptive_learning/presentation/bloc/adaptive_learning_bloc.dart';
import 'features/adaptive_learning/data/services/brain_gym_service.dart';
import 'features/group/data/services/family_session_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Map<String, List<String>> _phaseCulturePacks = {
    'phase_1': ['History & Heritage'],
    'phase_2': ['Science & Technology'],
  };

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PuzzleRepository>(
          create: (_) => PuzzleRepository(
            LocalPuzzleDatasource(),
          ),
        ),
        RepositoryProvider<ProgressionService>(
          create: (_) => ProgressionService(),
        ),
        RepositoryProvider<AdaptiveLearningRepositoryInterface>(
          create: (_) => AdaptiveLearningRepository(),
        ),
        RepositoryProvider<BrainGymService>(
          create: (_) => BrainGymService(),
        ),
        RepositoryProvider<FamilySessionStorage>(
          create: (_) => FamilySessionStorage(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BaseGameBloc>(
            create: (context) => GameBloc(
              puzzleRepository: context.read<PuzzleRepository>(),
              progressionService: context.read<ProgressionService>(),
              adaptiveLearningRepository:
                  context.read<AdaptiveLearningRepositoryInterface>(),
              phasePacks: _phaseCulturePacks,
            ),
          ),
          BlocProvider<AppSettingsCubit>(
            create: (_) => AppSettingsCubit(),
          ),
          BlocProvider<AdaptiveLearningBloc>(
            create: (context) => AdaptiveLearningBloc(
              repository: context.read<AdaptiveLearningRepositoryInterface>(),
            )..add(const AdaptiveLearningProfileRequested()),
          ),
        ],
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          builder: (context, appSettings) {
            return MaterialApp(
              title: 'Mystery Link',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(
                dynamicColors: appSettings.enableDynamicColors,
                locale: appSettings.locale,
              ),
              darkTheme: AppTheme.darkTheme(
                dynamicColors: appSettings.enableDynamicColors,
                locale: appSettings.locale,
              ),
              themeMode: appSettings.themeMode,
              locale: appSettings.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                final mediaQuery = MediaQuery.of(context);
                final adjustedMediaQuery = mediaQuery.copyWith(
                  textScaler: TextScaler.linear(appSettings.textScale),
                  disableAnimations: appSettings.enableMotion
                      ? mediaQuery.disableAnimations
                      : true,
                );
                return MediaQuery(
                  data: adjustedMediaQuery,
                  child: child ?? const SizedBox.shrink(),
                );
              },
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: AppRouter.home,
            );
          },
        ),
      ),
    );
  }
}
