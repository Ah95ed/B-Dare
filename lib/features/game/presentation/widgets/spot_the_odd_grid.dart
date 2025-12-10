import 'package:flutter/material.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض شبكة Spot the Odd
class SpotTheOddGrid extends StatelessWidget {
  final GameInProgress state;

  const SpotTheOddGrid({
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
    final selectedItemId = gameData['selectedItemId'] as String?;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index] as Map<String, dynamic>;
        final itemId = item['id'] as String;
        final label = item['label'] as String? ?? '';
        final isSelected = selectedItemId == itemId;

        return _OddItemCard(
          itemId: itemId,
          label: label,
          isSelected: isSelected,
          onTap: () {
            context.read<BaseGameBloc>().add(
                  ItemSelected(
                    itemId: itemId,
                  ),
                );
          },
        );
      },
    );
  }
}

class _OddItemCard extends StatelessWidget {
  final String itemId;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OddItemCard({
    required this.itemId,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.shade100
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

