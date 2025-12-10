import 'package:flutter/material.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض لوحة Memory Flip
class MemoryFlipBoard extends StatelessWidget {
  final GameInProgress state;

  const MemoryFlipBoard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cards = state.puzzle.gameTypeData?['cards'] as List?;
    if (cards == null || cards.isEmpty) {
      return const Center(child: Text('No cards available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final flippedCards = (gameData['flippedCards'] as List?)?.cast<String>() ?? [];
    final matchedPairs = (gameData['matchedPairs'] as List?)?.cast<String>() ?? [];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index] as Map<String, dynamic>;
        final cardId = card['id'] as String;
        final isFlipped = flippedCards.contains(cardId);
        final isMatched = matchedPairs.contains(card['pairId']);

        return _MemoryCard(
          cardId: cardId,
          label: card['label'] as String? ?? '',
          isFlipped: isFlipped,
          isMatched: isMatched,
          onTap: () {
            if (!isFlipped && !isMatched) {
              context.read<BaseGameBloc>().add(
                    CardFlipped(
                      cardId: cardId,
                      gameSpecificData: {'pairId': card['pairId']},
                    ),
                  );
            }
          },
        );
      },
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final String cardId;
  final String label;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback onTap;

  const _MemoryCard({
    required this.cardId,
    required this.label,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isMatched
              ? Colors.green.withValues(alpha: 0.3)
              : isFlipped
                  ? Colors.blue.shade100
                  : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMatched ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: isFlipped || isMatched
              ? Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              : const Icon(Icons.help_outline, size: 40),
        ),
      ),
    );
  }
}

