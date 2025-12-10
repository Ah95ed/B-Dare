import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/puzzle_step.dart';
import '../../domain/entities/custom_puzzle.dart';

class CreateCustomPuzzleScreen extends StatefulWidget {
  final RepresentationType representationType;
  final Function(CustomPuzzle) onPuzzleCreated;

  const CreateCustomPuzzleScreen({
    super.key,
    required this.representationType,
    required this.onPuzzleCreated,
  });

  @override
  State<CreateCustomPuzzleScreen> createState() =>
      _CreateCustomPuzzleScreenState();
}

class _CreateCustomPuzzleScreenState extends State<CreateCustomPuzzleScreen> {
  // Start and End nodes
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  // Steps
  final List<CustomStepData> _steps = [];

  // Time limit
  int _timeLimit = 12;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      _steps.add(CustomStepData(
        order: _steps.length + 1,
        timeLimit: _timeLimit,
      ));
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      // Reorder steps
      for (int i = 0; i < _steps.length; i++) {
        _steps[i].order = i + 1;
      }
    });
  }

  void _createPuzzle() {
    if (_startController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a start node')),
      );
      return;
    }

    if (_endController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an end node')),
      );
      return;
    }

    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step')),
      );
      return;
    }

    // Validate all steps
    for (final step in _steps) {
      if (step.options.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Step ${step.order} must have at least one option')),
        );
        return;
      }

      final hasCorrect = step.options.any((opt) => opt.isCorrect);
      if (!hasCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Step ${step.order} must have at least one correct answer')),
        );
        return;
      }
    }

    // Create puzzle
    final puzzle = CustomPuzzle(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      creatorId: 'host', // In real implementation, use actual user ID
      start: LinkNode(
        id: 'start',
        label: _startController.text.trim(),
        representationType: widget.representationType,
        labels: {
          'en': _startController.text.trim(),
          'ar': _startController.text.trim()
        },
      ),
      end: LinkNode(
        id: 'end',
        label: _endController.text.trim(),
        representationType: widget.representationType,
        labels: {
          'en': _endController.text.trim(),
          'ar': _endController.text.trim()
        },
      ),
      steps: _steps.map((stepData) {
        return PuzzleStep(
          order: stepData.order,
          timeLimit: stepData.timeLimit,
          options: stepData.options.map((opt) {
            return StepOption(
              node: LinkNode(
                id: 'step_${stepData.order}_opt_${opt.index}',
                label: opt.text,
                representationType: widget.representationType,
                labels: {'en': opt.text, 'ar': opt.text},
              ),
              isCorrect: opt.isCorrect,
            );
          }).toList(),
        );
      }).toList(),
      type: widget.representationType,
      timeLimit: _timeLimit,
    );

    widget.onPuzzleCreated(puzzle);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Puzzle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info),
                        const SizedBox(width: 8),
                        Text(
                          'Create Your Puzzle',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the start and end nodes, then add steps with options. Mark the correct answer for each step.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Start Node
              Text(
                'Start Node',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _startController,
                decoration: InputDecoration(
                  hintText: 'Enter start node (e.g., "Apple")',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.play_arrow),
                ),
              ),
              const SizedBox(height: 24),

              // End Node
              Text(
                'End Node',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _endController,
                decoration: InputDecoration(
                  hintText: 'Enter end node (e.g., "Tree")',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.flag),
                ),
              ),
              const SizedBox(height: 24),

              // Time Limit
              Text(
                'Time Limit (seconds per step)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _timeLimit.toDouble(),
                min: 5.0,
                max: 30.0,
                divisions: 25,
                label: '$_timeLimit seconds',
                onChanged: (value) {
                  setState(() {
                    _timeLimit = value.toInt();
                    // Update all steps
                    for (final step in _steps) {
                      step.timeLimit = _timeLimit;
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('5'),
                  Text('$_timeLimit seconds',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Text('30'),
                ],
              ),
              const SizedBox(height: 24),

              // Steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Steps (${_steps.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: _addStep,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Step'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Steps List
              ..._steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                return _buildStepCard(step, index);
              }),

              const SizedBox(height: 32),

              // Create Button
              ElevatedButton(
                onPressed: _createPuzzle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Puzzle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(CustomStepData step, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${step.order}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () => _removeStep(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Options (mark the correct one):',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ...step.options.asMap().entries.map((entry) {
              final optIndex = entry.key;
              final option = entry.value;
              return _buildOptionRow(step, optIndex, option);
            }),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  step.addOption();
                });
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Option'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(
      CustomStepData step, int optIndex, CustomOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: option.controller,
              decoration: InputDecoration(
                hintText: 'Option ${optIndex + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: option.isCorrect,
                fillColor: option.isCorrect
                    ? AppColors.success.withValues(alpha: 0.1)
                    : null,
              ),
              onChanged: (value) {
                option.text = value;
              },
            ),
          ),
          const SizedBox(width: 8),
          Checkbox(
            value: option.isCorrect,
            onChanged: (value) {
              setState(() {
                // Uncheck all other options
                for (final opt in step.options) {
                  opt.isCorrect = false;
                }
                option.isCorrect = value ?? false;
              });
            },
            activeColor: AppColors.success,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: AppColors.error,
            onPressed: () {
              setState(() {
                step.removeOption(optIndex);
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomStepData {
  int order;
  int timeLimit;
  List<CustomOption> options = [];

  CustomStepData({
    required this.order,
    required this.timeLimit,
  });

  void addOption() {
    options.add(CustomOption(
      index: options.length,
      controller: TextEditingController(),
    ));
  }

  void removeOption(int index) {
    options[index].controller.dispose();
    options.removeAt(index);
    // Reindex
    for (int i = 0; i < options.length; i++) {
      options[i].index = i;
    }
  }

  void dispose() {
    for (final option in options) {
      option.controller.dispose();
    }
  }
}

class CustomOption {
  int index;
  String text = '';
  bool isCorrect = false;
  TextEditingController controller;

  CustomOption({
    required this.index,
    required this.controller,
  });
}
