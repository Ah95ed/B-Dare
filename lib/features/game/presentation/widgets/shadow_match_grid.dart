import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض شبكة Shadow Match
class ShadowMatchGrid extends StatelessWidget {
  final GameInProgress state;

  const ShadowMatchGrid({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final shape = state.puzzle.gameTypeData?['shape'] as Map<String, dynamic>?;
    final shadows = state.puzzle.gameTypeData?['shadows'] as List?;

    if (shape == null || shadows == null) {
      return const Center(child: Text('No shape or shadows available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final selectedShadowId = gameData['selectedShadowId'] as String?;

    return Column(
      children: [
        // الشكل الأصلي
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            shape['label'] as String? ?? 'Shape',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        // الظلال
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: shadows.length,
          itemBuilder: (context, index) {
            final shadow = shadows[index] as Map<String, dynamic>;
            final shadowId = shadow['id'] as String;
            final label = shadow['label'] as String? ?? '';
            final isSelected = selectedShadowId == shadowId;

            return _ShadowCard(
              shadowId: shadowId,
              label: label,
              isSelected: isSelected,
              onTap: () {
                context.read<BaseGameBloc>().add(
                      ItemSelected(
                        itemId: shadowId,
                      ),
                    );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ShadowCard extends StatelessWidget {
  final String shadowId;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShadowCard({
    required this.shadowId,
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
          color: isSelected ? Colors.purple.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

