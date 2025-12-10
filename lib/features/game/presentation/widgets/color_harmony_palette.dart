import 'package:flutter/material.dart';
import '../bloc/game_state.dart';

/// Widget لعرض لوحة Color Harmony
class ColorHarmonyPalette extends StatelessWidget {
  final GameInProgress state;

  const ColorHarmonyPalette({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colors = state.puzzle.gameTypeData?['colors'] as List?;
    final targetColor = state.puzzle.gameTypeData?['targetColor'] as Map<String, dynamic>?;

    if (colors == null || targetColor == null) {
      return const Center(child: Text('No colors available'));
    }

    final gameData = state.gameSpecificData ?? {};
    final mixedColor1 = gameData['mixedColor1'] as String?;
    final mixedColor2 = gameData['mixedColor2'] as String?;

    return Column(
      children: [
        // Target Color
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hexToColor(targetColor['hex'] as String? ?? '#000000'),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            targetColor['label'] as String? ?? 'Target',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Available Colors
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((color) {
            final colorData = color as Map<String, dynamic>;
            final colorId = colorData['id'] as String;
            final hex = colorData['hex'] as String? ?? '#000000';
            final label = colorData['label'] as String? ?? '';

            final isSelected1 = mixedColor1 == colorId;
            final isSelected2 = mixedColor2 == colorId;

            return _ColorCard(
              colorId: colorId,
              hex: hex,
              label: label,
              isSelected: isSelected1 || isSelected2,
              onTap: () {
                // TODO: معالجة اختيار اللون للمزج
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class _ColorCard extends StatelessWidget {
  final String colorId;
  final String hex;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorCard({
    required this.colorId,
    required this.hex,
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
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _hexToColor(hex),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey,
            width: isSelected ? 4 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

