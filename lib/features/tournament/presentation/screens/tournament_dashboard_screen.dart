import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tournament.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';
import '../widgets/tournament_card.dart';
import '../widgets/tournament_stats.dart';
import '../widgets/stage_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import 'create_tournament_screen.dart';
import 'tournament_registration_screen.dart';
import 'match_screen.dart';
import '../../domain/entities/match.dart';
import '../widgets/bracket_viewer.dart';
import '../widgets/tournament_live_ticker.dart';
import '../../../../l10n/app_localizations.dart';

/// شاشة لوحة تحكم المسابقات
class TournamentDashboardScreen extends StatefulWidget {
  const TournamentDashboardScreen({super.key});

  @override
  State<TournamentDashboardScreen> createState() => _TournamentDashboardScreenState();
}

class _TournamentDashboardScreenState extends State<TournamentDashboardScreen> {
  TournamentStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // جلب جميع البطولات عند فتح الشاشة
    context.read<TournamentBloc>().add(const FetchTournaments());
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsCubit>().state;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tournamentGlobalTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final tournamentBloc = context.read<TournamentBloc>();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: tournamentBloc,
                    child: const CreateTournamentScreen(),
                  ),
                ),
              );
              if (result != null) {
                // Refresh tournaments list
                context.read<TournamentBloc>().add(
                      FetchTournaments(status: _selectedFilter),
                    );
              }
            },
          ),
        ],
      ),
      body: Column(
      children: [
        // Filter Section
        _buildFilterSection(context),
        // Content
        Expanded(
            child: BlocBuilder<TournamentBloc, TournamentState>(
              builder: (context, state) {
                if (state is TournamentLoading) {
                  return const LoadingWidget();
                } else if (state is TournamentError) {
                  return ErrorDisplayWidget(message: state.message);
                } else if (state is TournamentsLoaded) {
                  return _buildTournamentsList(context, state.tournaments, appSettings);
                } else if (state is TournamentLoaded) {
                  return _buildTournamentDetails(context, state, appSettings);
                } else {
                  return Center(
                    child: Text(l10n.tournamentNoTournaments),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
           Text(
             l10n.tournamentFilterLabel,
             style: const TextStyle(fontWeight: FontWeight.bold),
           ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   _buildFilterChip(
                     l10n.tournamentFilterAll,
                     null,
                   ),
                  const SizedBox(width: 8),
                   _buildFilterChip(
                     l10n.tournamentFilterRegistration,
                     TournamentStatus.registration,
                   ),
                  const SizedBox(width: 8),
                   _buildFilterChip(
                     l10n.tournamentFilterQualifiers,
                     TournamentStatus.qualifiers,
                   ),
                  const SizedBox(width: 8),
                   _buildFilterChip(
                     l10n.tournamentFilterFinal,
                     TournamentStatus.finalStage,
                   ),
                  const SizedBox(width: 8),
                   _buildFilterChip(
                     l10n.tournamentFilterCompleted,
                     TournamentStatus.completed,
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, TournamentStatus? status) {
    final isSelected = _selectedFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? status : null;
        });
        context.read<TournamentBloc>().add(
              FetchTournaments(status: _selectedFilter),
            );
      },
      selectedColor: AppColors.accent.withValues(alpha: 0.2),
      checkmarkColor: AppColors.accent,
    );
  }

  Widget _buildTournamentsList(
    BuildContext context,
    List<Tournament> tournaments,
    AppSettingsState appSettings,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (tournaments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.accent.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
             Text(
               l10n.tournamentEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 8),
             ElevatedButton.icon(
              onPressed: () async {
                final tournamentBloc = context.read<TournamentBloc>();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: tournamentBloc,
                      child: const CreateTournamentScreen(),
                    ),
                  ),
                );
                if (result != null && mounted) {
                  // Refresh tournaments list
                  context.read<TournamentBloc>().add(
                        FetchTournaments(status: _selectedFilter),
                      );
                }
              },
               icon: const Icon(Icons.add),
               label: Text(l10n.tournamentCreateNew),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TournamentBloc>().add(
              FetchTournaments(status: _selectedFilter),
            );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TournamentCard(
              tournament: tournament,
              enableMotion: appSettings.enableMotion,
              enableDynamicColors: appSettings.enableDynamicColors,
              onTap: () {
                context.read<TournamentBloc>().add(
                      FetchTournament(tournament.id),
                    );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTournamentDetails(
    BuildContext context,
    TournamentLoaded state,
    AppSettingsState appSettings,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final tournament = state.tournament;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tournament Header
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tournament.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                        ),
                      ),
                      _buildStatusBadge(context, tournament.status),
                    ],
                  ),
                  if (tournament.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      tournament.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 16),
                  TournamentStats(tournament: tournament),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          TournamentLiveTicker(tournamentId: tournament.id),
          const SizedBox(height: 16),
          
          // Stages Section
          if (state.stages != null && state.stages!.isNotEmpty) ...[
            Text(
              l10n.tournamentStagesSectionTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...state.stages!.map((stage) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      // عرض المباريات في هذه المرحلة
                      if (stage.matches.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.8,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        stage.name,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: stage.matches.length,
                                      itemBuilder: (context, index) {
                                        final match = stage.matches[index];
                                        return ListTile(
                                          title: Text('${match.team1.name} vs ${match.team2.name}'),
                                          subtitle: Text(_formatMatchStatus(context, match.status)),
                                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                          onTap: () {
                                            final tournamentBloc = context.read<TournamentBloc>();
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BlocProvider.value(
                                                  value: tournamentBloc,
                                                  child: MatchScreen(
                                                    tournamentId: tournament.id,
                                                    matchId: match.id,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: StageIndicator(stage: stage),
                  ),
                )),
            const SizedBox(height: 16),
          ],
          
          // Teams Section
          if (state.teams != null && state.teams!.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text(
              l10n.tournamentTeamsSectionTitle(
                state.teams!.length,
                tournament.maxTeams,
              ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (tournament.isRegistrationOpen)
                  TextButton.icon(
                    onPressed: () {
                      final tournamentBloc = context.read<TournamentBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: tournamentBloc,
                            child: TournamentRegistrationScreen(
                              tournamentId: tournament.id,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('تسجيل فريق'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ...state.teams!.take(10).map((team) => ListTile(
                  leading: CircleAvatar(
                    child: Text(team.name[0]),
                  ),
                  title: Text(team.name),
                  subtitle: Text(
                    '${team.memberCount}',
                  ),
                  trailing: team.seed != null
                      ? Chip(
                          label: Text('#${team.seed}'),
                          backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                        )
                      : null,
                )),
            if (state.teams!.length > 10)
              TextButton(
                onPressed: () {
                  // TODO: Show all teams
                },
                child: Text(
                  l10n.tournamentViewAllTeams(state.teams!.length),
                ),
              ),
          ],
          
          const SizedBox(height: 16),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (state.bracket != null) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.8,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
            Text(
              l10n.tournamentBracketTitle,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: BracketViewer(bracket: state.bracket!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text(l10n.tournamentBracketUnavailable),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.account_tree),
                  label: Text(l10n.tournamentViewBracket),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (tournament.canStart)
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TournamentBloc>().add(
                          StartTournament(tournament.id),
                        );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.tournamentStart),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.accent,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Back Button
          TextButton.icon(
            onPressed: () {
              context.read<TournamentBloc>().add(const ResetTournamentState());
              context.read<TournamentBloc>().add(const FetchTournaments());
            },
            icon: const Icon(Icons.arrow_back),
            label: Text(l10n.back),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, TournamentStatus status) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case TournamentStatus.registration:
        color = Colors.blue;
        label = l10n.tournamentStatusRegistration;
        icon = Icons.how_to_reg;
        break;
      case TournamentStatus.qualifiers:
        color = Colors.orange;
        label = l10n.tournamentStatusQualifiers;
        icon = Icons.tour;
        break;
      case TournamentStatus.playoffs:
        color = Colors.purple;
        label = l10n.tournamentStatusPlayoffs;
        icon = Icons.emoji_events;
        break;
      case TournamentStatus.finalStage:
        color = Colors.amber;
        label = l10n.tournamentStatusFinal;
        icon = Icons.stars;
        break;
      case TournamentStatus.completed:
        color = Colors.green;
        label = l10n.tournamentStatusCompleted;
        icon = Icons.check_circle;
        break;
      case TournamentStatus.cancelled:
        color = Colors.red;
        label = l10n.tournamentStatusCancelled;
        icon = Icons.cancel;
        break;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  String _formatMatchStatus(BuildContext context, MatchStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case MatchStatus.scheduled:
        return l10n.tournamentMatchStatusScheduled;
      case MatchStatus.inProgress:
        return l10n.tournamentMatchStatusInProgress;
      case MatchStatus.completed:
        return l10n.tournamentMatchStatusCompleted;
      case MatchStatus.forfeited:
        return l10n.tournamentMatchStatusForfeit;
      case MatchStatus.cancelled:
        return l10n.tournamentMatchStatusCancelled;
    }
  }
}

