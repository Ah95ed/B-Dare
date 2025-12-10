import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services/tournament_live_service.dart';

class TournamentLiveTicker extends StatefulWidget {
  final String? tournamentId;

  const TournamentLiveTicker({super.key, this.tournamentId});

  @override
  State<TournamentLiveTicker> createState() => _TournamentLiveTickerState();
}

class _TournamentLiveTickerState extends State<TournamentLiveTicker> {
  late final TournamentLiveService _liveService;
  StreamSubscription<TournamentLiveUpdate>? _subscription;
  final List<TournamentLiveUpdate> _events = [];
  bool _connecting = true;

  @override
  void initState() {
    super.initState();
    _liveService = TournamentLiveService();
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    final stream = _liveService.watch(tournamentId: widget.tournamentId);
    _subscription = stream.listen(
      (event) {
        setState(() {
          _connecting = false;
          _events.insert(0, event);
          if (_events.length > 8) {
            _events.removeLast();
          }
        });
      },
      onError: (_) {
        if (mounted) {
          setState(() => _connecting = true);
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant TournamentLiveTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tournamentId != widget.tournamentId) {
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _liveService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<AppSettingsCubit>().state;
    final bool hasEvents = _events.isNotEmpty;
    final duration = settings.enableMotion
        ? const Duration(milliseconds: 350)
        : Duration.zero;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.broadcast_on_home, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.liveTournamentFeed,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (_connecting)
                  const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: duration,
              child: hasEvents
                  ? Column(
                      children: _events
                          .map(
                            (event) => _LiveUpdateTile(
                              update: event,
                              enableMotion: settings.enableMotion,
                            ),
                          )
                          .toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.liveTournamentFeedEmpty,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveUpdateTile extends StatelessWidget {
  final TournamentLiveUpdate update;
  final bool enableMotion;

  const _LiveUpdateTile({required this.update, required this.enableMotion});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final timestampText = TimeOfDay.fromDateTime(update.timestamp).format(context);
    return AnimatedContainer(
      duration: enableMotion ? const Duration(milliseconds: 300) : Duration.zero,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.08),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.bolt, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatHeadline(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timestampText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatHeadline() {
    final tournamentName = update.payload['tournament']?['name'];
    final type = update.eventType;
    if (tournamentName is String && tournamentName.isNotEmpty) {
      return '$type · $tournamentName';
    }
    return type;
  }
}
