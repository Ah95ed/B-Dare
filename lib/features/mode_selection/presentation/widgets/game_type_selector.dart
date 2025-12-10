import 'package:flutter/material.dart';
import '../../../../features/game/domain/entities/game_type.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../l10n/app_localizations.dart';

class GameTypeSelector extends StatelessWidget {
  final GameType? selectedGameType;
  final ValueChanged<GameType> onGameTypeSelected;
  final bool enabled;

  const GameTypeSelector({
    super.key,
    this.selectedGameType,
    required this.onGameTypeSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectGameTypeTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          itemCount: GameConstants.availableGameTypes.length,
          itemBuilder: (context, index) {
            final gameType = GameConstants.availableGameTypes[index];
            final isSelected = selectedGameType == gameType;

            return _GameTypeCard(
              gameType: gameType,
              isSelected: isSelected,
              enabled: enabled,
              onTap: () => onGameTypeSelected(gameType),
            );
          },
        ),
      ],
    );
  }
}

class _GameTypeCard extends StatelessWidget {
  final GameType gameType;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _GameTypeCard({
    required this.gameType,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gameType.icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              gameType.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

