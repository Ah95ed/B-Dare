import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class SpotTheOddScreen extends StatefulWidget {
  const SpotTheOddScreen({super.key});

  @override
  State<SpotTheOddScreen> createState() => _SpotTheOddScreenState();
}

class _SpotTheOddScreenState extends State<SpotTheOddScreen> {
  static const _iconGroups = [
    [Icons.star, Icons.star_border],
    [Icons.circle, Icons.circle_outlined],
    [Icons.square, Icons.crop_square],
  ];

  late List<_OddItem> _items;
  int _score = 0;
  int _round = 0;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    final rnd = Random();
    final baseGroup = _iconGroups[rnd.nextInt(_iconGroups.length)];
    final baseIcon = baseGroup[0];
    final oddIcon = baseGroup[1];
    const count = 6;
    final oddIndex = rnd.nextInt(count);
    final items = <_OddItem>[];
    for (var i = 0; i < count; i++) {
      items.add(
        _OddItem(
          icon: i == oddIndex ? oddIcon : baseIcon,
          isOdd: i == oddIndex,
        ),
      );
    }
    items.shuffle(rnd);

    setState(() {
      _round += 1;
      _items = items;
    });
  }

  void _onTap(_OddItem item) {
    setState(() {
      if (item.isOdd) {
        _score += 10;
      } else {
        _score = (_score - 5).clamp(0, 9999);
      }
    });
    _nextRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot the Odd'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Round: $_round'),
                Text('Score: $_score'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the icon that looks different from the others.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: _items
                    .map(
                      (item) => GestureDetector(
                        onTap: () => _onTap(item),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 40,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OddItem {
  final IconData icon;
  final bool isOdd;

  _OddItem({required this.icon, required this.isOdd});
}
