import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض لوحة Story Tiles
class StoryTilesBoard extends StatelessWidget {
  final GameInProgress state;

  const StoryTilesBoard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = state.puzzle.gameTypeData?['tiles'] as List?;
    if (tiles == null || tiles.isEmpty) {
      return const Center(child: Text('No tiles available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final currentOrder = (gameData['currentOrder'] as List?)?.cast<String>() ?? [];

    final displayOrder = currentOrder.isEmpty
        ? tiles.map((tile) => (tile as Map)['id'] as String).toList()
        : currentOrder;

    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        final tileId = displayOrder[oldIndex];
        context.read<BaseGameBloc>().add(
              TileArranged(
                tileId: tileId,
                newPosition: newIndex,
              ),
            );
      },
      children: displayOrder.map((tileId) {
        final matchingTiles = tiles.where((t) => (t as Map)['id'] == tileId);
        if (matchingTiles.isEmpty) return const SizedBox.shrink();
        
        final tile = matchingTiles.first as Map<String, dynamic>;

        return _StoryTile(
          key: ValueKey(tileId),
          tileId: tileId,
          label: tile['label'] as String? ?? '',
        );
      }).toList(),
    );
  }
}

class _StoryTile extends StatelessWidget {
  final String tileId;
  final String label;

  const _StoryTile({
    super.key,
    required this.tileId,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

