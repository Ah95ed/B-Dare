import 'package:flutter/material.dart';
import '../bloc/game_state.dart';

/// Widget لعرض لوحة Cipher Tiles
class CipherTilesBoard extends StatelessWidget {
  final GameInProgress state;

  const CipherTilesBoard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cipher = state.puzzle.gameTypeData?['cipher'] as String?;
    final encodedWord = state.puzzle.gameTypeData?['encodedWord'] as String?;
    final gameData = state.gameSpecificData ?? {};
    final decodedWord = gameData['decodedWord'] as String? ?? '';

    return Column(
      children: [
        // Cipher Rule
        if (cipher != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Cipher: $cipher',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        const SizedBox(height: 24),
        // Encoded Word
        Text(
          'Encoded: $encodedWord',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        // Decoded Word
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            decodedWord.isEmpty ? '___' : decodedWord,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        // Input buttons (A-Z)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(26, (index) {
            final char = String.fromCharCode(65 + index); // A-Z
            return ElevatedButton(
              onPressed: () {
                // TODO: إرسال decode character
              },
              child: Text(char),
            );
          }),
        ),
      ],
    );
  }
}

