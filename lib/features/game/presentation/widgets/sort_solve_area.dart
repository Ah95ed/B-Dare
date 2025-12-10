import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض منطقة Sort & Solve
class SortSolveArea extends StatelessWidget {
  final GameInProgress state;

  const SortSolveArea({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final items = state.puzzle.gameTypeData?['items'] as List?;
    if (items == null || items.isEmpty) {
      return const Center(child: Text('No items available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final currentOrder = (gameData['currentOrder'] as List?)?.cast<String>() ?? [];

    // إذا لم يكن هناك ترتيب، استخدم الترتيب الأصلي
    final displayOrder = currentOrder.isEmpty
        ? items.map((item) => (item as Map)['id'] as String).toList()
        : currentOrder;

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        final itemId = displayOrder[oldIndex];
        context.read<BaseGameBloc>().add(
              ItemMoved(
                itemId: itemId,
                newPosition: newIndex,
              ),
            );
      },
      children: displayOrder.map((itemId) {
        final matchingItems = items.where((i) => (i as Map)['id'] == itemId);
        if (matchingItems.isEmpty) return const SizedBox.shrink();
        
        final item = matchingItems.first as Map<String, dynamic>;

        return _SortableItem(
          key: ValueKey(itemId),
          itemId: itemId,
          label: item['label'] as String? ?? '',
        );
      }).toList(),
    );
  }
}

class _SortableItem extends StatelessWidget {
  final String itemId;
  final String label;

  const _SortableItem({
    super.key,
    required this.itemId,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.drag_handle),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

