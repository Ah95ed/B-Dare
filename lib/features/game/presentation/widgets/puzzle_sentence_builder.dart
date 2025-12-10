import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض Puzzle Sentence Builder
class PuzzleSentenceBuilder extends StatelessWidget {
  final GameInProgress state;

  const PuzzleSentenceBuilder({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final words = state.puzzle.gameTypeData?['words'] as List?;
    if (words == null || words.isEmpty) {
      return const Center(child: Text('No words available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final currentOrder = (gameData['currentOrder'] as List?)?.cast<String>() ?? [];
    final sentence = gameData['sentence'] as String? ?? '';

    final displayOrder = currentOrder.isEmpty
        ? words.map((word) => (word as Map)['id'] as String).toList()
        : currentOrder;

    return Column(
      children: [
        // الجملة المبنية
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Text(
            sentence.isEmpty ? 'Build your sentence...' : sentence,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: sentence.isEmpty ? Colors.grey : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        // الكلمات
        ReorderableListView(
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final wordId = displayOrder[oldIndex];
            context.read<BaseGameBloc>().add(
                  ItemMoved(
                    itemId: wordId,
                    newPosition: newIndex,
                  ),
                );
          },
          children: displayOrder.map((wordId) {
            final matchingWords = words.where((w) => (w as Map)['id'] == wordId);
            if (matchingWords.isEmpty) return const SizedBox.shrink();
            
            final word = matchingWords.first as Map<String, dynamic>;

            return _WordCard(
              key: ValueKey(wordId),
              wordId: wordId,
              label: word['label'] as String? ?? '',
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _WordCard extends StatelessWidget {
  final String wordId;
  final String label;

  const _WordCard({
    super.key,
    required this.wordId,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.drag_handle),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

