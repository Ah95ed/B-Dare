import 'package:flutter/material.dart';
import 'package:mystery_link/core/constants/game_constants.dart';
import 'package:mystery_link/core/router/app_router.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import '../../../../l10n/app_localizations.dart';

class GuidedModeScreen extends StatelessWidget {
  const GuidedModeScreen({super.key});

  void _startGuidedSession(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRouter.game,
      arguments: {
        'representationType': RepresentationType.text,
        'linksCount': 3,
        'gameMode': 'guided',
        'category': GameConstants.linkCategoryAny,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      l10n.guidedModeIntroStep1,
      l10n.guidedModeIntroStep2,
      l10n.guidedModeIntroStep3,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.guidedModeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.guidedModeLongDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ...steps.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _startGuidedSession(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text(
                l10n.guidedModeStartSession,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
