import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import '../bloc/base_game_bloc.dart';

/// Widget لعرض Spot the Change
class SpotTheChangeViewer extends StatelessWidget {
  final GameInProgress state;

  const SpotTheChangeViewer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final image1 =
        state.puzzle.gameTypeData?['image1'] as Map<String, dynamic>?;
    final image2 =
        state.puzzle.gameTypeData?['image2'] as Map<String, dynamic>?;
    final options = state.puzzle.gameTypeData?['options'] as List?;

    if (image1 == null || image2 == null || options == null) {
      return const Center(child: Text('No images or options available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final selectedChangeType = gameData['selectedChangeType'] as String?;

    return Column(
      children: [
        // الصورتان
        Row(
          children: [
            Expanded(
              child: _ImageCard(
                label: image1['label'] as String? ?? 'Image 1',
                description: image1['description'] as String? ?? '',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ImageCard(
                label: image2['label'] as String? ?? 'Image 2',
                description: image2['description'] as String? ?? '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // الخيارات
        ...options.map((option) {
          final opt = option as Map<String, dynamic>;
          final optId = opt['id'] as String;
          final label = opt['label'] as String? ?? '';
          final isSelected = selectedChangeType == optId;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _ChangeOptionCard(
              optionId: optId,
              label: label,
              isSelected: isSelected,
              onTap: () {
                context.read<BaseGameBloc>().add(
                      ItemSelected(
                        itemId: optId,
                      ),
                    );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String label;
  final String description;

  const _ImageCard({
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class _ChangeOptionCard extends StatelessWidget {
  final String optionId;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChangeOptionCard({
    required this.optionId,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
