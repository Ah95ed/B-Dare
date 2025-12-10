import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import 'memory_flip_screen.dart';
import 'snap_reflex_screen.dart';
import 'spot_the_odd_screen.dart';

class MinigameHubScreen extends StatelessWidget {
  const MinigameHubScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Mini-Games'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Quick brain warmups for all ages.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _MinigameCard(
              title: 'Memory Flip',
              description: 'Flip cards and match pairs as fast as you can.',
              icon: Icons.grid_view,
              color: AppColors.modePractice,
              onTap: () => _open(context, const MemoryFlipScreen()),
            ),
            const SizedBox(height: 12),
            _MinigameCard(
              title: 'Snap Reflex',
              description: 'Tap the matching color before time runs out.',
              icon: Icons.bolt,
              color: AppColors.modeDaily,
              onTap: () => _open(context, const SnapReflexScreen()),
            ),
            const SizedBox(height: 12),
            _MinigameCard(
              title: 'Spot the Odd',
              description: 'Find the odd-one-out in each set of icons.',
              icon: Icons.search,
              color: AppColors.modeSolo,
              onTap: () => _open(context, const SpotTheOddScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinigameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MinigameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
