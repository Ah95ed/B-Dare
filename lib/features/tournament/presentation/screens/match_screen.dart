import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';
import '../widgets/match_card.dart';
import '../widgets/game_score_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../features/multiplayer/data/services/cloudflare_multiplayer_service.dart';
import '../../data/services/tournament_service.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../l10n/app_localizations.dart';

/// شاشة المباراة
class MatchScreen extends StatelessWidget {
  final String tournamentId;
  final String matchId;

  const MatchScreen({
    super.key,
    required this.tournamentId,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // جلب المباراة عند فتح الشاشة
    context.read<TournamentBloc>().add(
          FetchMatch(
            tournamentId: tournamentId,
            matchId: matchId,
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.matchTitle),
      ),
      body: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          if (state is TournamentLoading) {
            return const LoadingWidget();
          } else if (state is TournamentError) {
            return ErrorDisplayWidget(message: state.message);
          } else if (state is MatchLoaded) {
            return _buildMatchContent(context, state.match);
          } else {
             return Center(
               child: Text(l10n.loading),
             );
          }
        },
      ),
    );
  }

  Widget _buildMatchContent(BuildContext context, Match match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Header
          MatchCard(
            match: match,
            showDetails: true,
          ),
          
          const SizedBox(height: 24),
          
          // Game Results
          if (match.gameResults.isNotEmpty) ...[
            Text(
              'نتائج الجولات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...match.gameResults.map((result) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GameScoreCard(result: result),
                )),
          ],
          
          const SizedBox(height: 24),
          
          // Actions
          if (match.status == MatchStatus.scheduled) ...[
            ElevatedButton.icon(
              onPressed: () => _startMatch(context, match),
              icon: const Icon(Icons.play_arrow),
              label: Text(AppLocalizations.of(context)!.matchStart),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ] else if (match.status == MatchStatus.inProgress) ...[
            ElevatedButton.icon(
              onPressed: () => _joinMatch(context, match),
              icon: const Icon(Icons.login),
              label: Text(AppLocalizations.of(context)!.matchJoin),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startMatch(BuildContext context, Match match) async {
    try {
      // إظهار loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // بدء المباراة في Cloudflare
      final tournamentService = TournamentService();
      final updatedMatch = await tournamentService.startMatch(tournamentId, matchId);

      if (updatedMatch.roomId == null) {
        throw Exception('Failed to create game room');
      }

      // إنشاء CloudflareMultiplayerService
      final multiplayerService = CloudflareMultiplayerService(
        baseUrl: AppConstants.cloudflareWorkerUrl,
      );

      // الحصول على team info (سيتم من context أو state)
      // TODO: الحصول على team ID و name من context
      final teamId = match.team1.id; // أو team2 حسب المستخدم
      final teamName = match.team1.name;

      // الاتصال بـ GameRoom
      await multiplayerService.connectToRoom(
        roomId: updatedMatch.roomId!,
        playerId: teamId,
        playerName: teamName,
      );

      // إغلاق loading
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Navigate to game
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRouter.game,
          arguments: {
            'gameMode': 'group',
            'gameType': null, // سيتم تحديده من الخادم
            'representationType': null,
            'linksCount': 3,
            'playersCount': 2, // فريقين
            'cloudflareRoomId': updatedMatch.roomId,
            'multiplayerService': multiplayerService,
            'tournamentId': tournamentId,
            'matchId': matchId,
          },
        );
      }
    } catch (e) {
      // إغلاق loading
      if (context.mounted) {
        Navigator.pop(context);
      }

      // إظهار error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.matchStartFailed(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _joinMatch(BuildContext context, Match match) async {
    if (match.roomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.matchNotReady),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      // إنشاء CloudflareMultiplayerService
      final multiplayerService = CloudflareMultiplayerService(
        baseUrl: AppConstants.cloudflareWorkerUrl,
      );

      // الحصول على team info
      final teamId = match.team1.id; // أو team2 حسب المستخدم
      final teamName = match.team1.name;

      // الاتصال بـ GameRoom
      await multiplayerService.connectToRoom(
        roomId: match.roomId!,
        playerId: teamId,
        playerName: teamName,
      );

      // Navigate to game
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRouter.game,
          arguments: {
            'gameMode': 'group',
            'gameType': null,
            'representationType': null,
            'linksCount': 3,
            'playersCount': 2,
            'cloudflareRoomId': match.roomId,
            'multiplayerService': multiplayerService,
            'tournamentId': tournamentId,
            'matchId': matchId,
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.matchJoinFailed(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
