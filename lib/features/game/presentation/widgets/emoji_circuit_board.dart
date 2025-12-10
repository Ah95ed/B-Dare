import 'package:flutter/material.dart';
import '../bloc/game_state.dart';

/// Widget لعرض لوحة Emoji Circuit
class EmojiCircuitBoard extends StatelessWidget {
  final GameInProgress state;

  const EmojiCircuitBoard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final emojis = state.puzzle.gameTypeData?['emojis'] as List?;
    if (emojis == null || emojis.isEmpty) {
      return const Center(child: Text('No emojis available'));
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: emojis.map((emoji) {
        final emojiData = emoji as Map<String, dynamic>;
        final emojiId = emojiData['id'] as String;
        final emojiChar = emojiData['emoji'] as String? ?? '😀';
        final label = emojiData['label'] as String? ?? '';

        return _EmojiNode(
          emojiId: emojiId,
          emoji: emojiChar,
          label: label,
          onTap: () {
            // TODO: معالجة الاتصال
          },
        );
      }).toList(),
    );
  }
}

class _EmojiNode extends StatelessWidget {
  final String emojiId;
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _EmojiNode({
    required this.emojiId,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.yellow.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.yellow),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

