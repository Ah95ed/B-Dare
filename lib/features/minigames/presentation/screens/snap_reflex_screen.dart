import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class SnapReflexScreen extends StatefulWidget {
  const SnapReflexScreen({super.key});

  @override
  State<SnapReflexScreen> createState() => _SnapReflexScreenState();
}

class _SnapReflexScreenState extends State<SnapReflexScreen> {
  static const _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  Color _targetColor = Colors.red;
  Color _currentColor = Colors.red;
  int _score = 0;
  int _round = 0;
  Timer? _timer;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextRound() {
    _timer?.cancel();
    final rnd = Random();
    setState(() {
      _round += 1;
      _locked = false;
      _targetColor = _colors[rnd.nextInt(_colors.length)];
      _currentColor = _colors[rnd.nextInt(_colors.length)];
    });
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!mounted) return;
      setState(() {
        _currentColor = _colors[rnd.nextInt(_colors.length)];
      });
    });
  }

  void _onTap() {
    if (_locked) return;
    setState(() {
      _locked = true;
      if (_currentColor == _targetColor) {
        _score += 10;
      } else {
        _score = (_score - 5).clamp(0, 9999);
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _nextRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snap Reflex'),
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
            const SizedBox(height: 32),
            Text(
              'Tap when the big circle matches the target color.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Target'),
                    const SizedBox(height: 8),
                    _ColorDot(color: _targetColor, size: 40),
                  ],
                ),
                const SizedBox(width: 48),
                Column(
                  children: [
                    const Text('Current'),
                    const SizedBox(height: 8),
                    _ColorDot(color: _currentColor, size: 80),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: _onTap,
                child: Text(
                  'SNAP',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final double size;

  const _ColorDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

