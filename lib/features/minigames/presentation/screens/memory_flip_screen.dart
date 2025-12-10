import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class MemoryFlipScreen extends StatefulWidget {
  const MemoryFlipScreen({super.key});

  @override
  State<MemoryFlipScreen> createState() => _MemoryFlipScreenState();
}

class _MemoryFlipScreenState extends State<MemoryFlipScreen> {
  late List<_CardModel> _cards;
  int _flippedIndex = -1;
  int _moves = 0;
  int _matches = 0;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    const icons = [
      Icons.lightbulb_outline,
      Icons.polyline,
      Icons.science,
      Icons.eco,
      Icons.public,
      Icons.bolt,
    ];
    final pairs = [
      for (final icon in icons) _CardModel(icon: icon),
      for (final icon in icons) _CardModel(icon: icon),
    ];
    pairs.shuffle(Random());
    setState(() {
      _cards = pairs;
      _flippedIndex = -1;
      _moves = 0;
      _matches = 0;
    });
  }

  void _onCardTapped(int index) {
    if (_cards[index].isMatched || _cards[index].isFaceUp) return;
    setState(() {
      _cards[index] = _cards[index].copyWith(isFaceUp: true);
      if (_flippedIndex == -1) {
        _flippedIndex = index;
      } else {
        _moves += 1;
        final previous = _flippedIndex;
        _flippedIndex = -1;
        if (_cards[previous].icon == _cards[index].icon) {
          _cards[previous] = _cards[previous].copyWith(isMatched: true);
          _cards[index] = _cards[index].copyWith(isMatched: true);
          _matches += 1;
        } else {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            setState(() {
              _cards[previous] =
                  _cards[previous].copyWith(isFaceUp: false);
              _cards[index] = _cards[index].copyWith(isFaceUp: false);
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allMatched = _matches == _cards.where((c) => c.isMatched).length &&
        _matches == _cards.length ~/ 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Flip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Moves: $_moves'),
                Text('Matches: $_matches'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: card.isMatched || card.isFaceUp
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: card.isFaceUp || card.isMatched
                            ? Icon(
                                card.icon,
                                size: 32,
                                color: AppColors.primaryDark,
                              )
                            : const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (allMatched) ...[
              const SizedBox(height: 12),
              Text(
                'Great memory! Try again with fewer moves.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardModel {
  final IconData icon;
  final bool isFaceUp;
  final bool isMatched;

  _CardModel({
    required this.icon,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  _CardModel copyWith({
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return _CardModel(
      icon: icon,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

