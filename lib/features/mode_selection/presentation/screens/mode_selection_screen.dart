import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/link_node.dart';
import '../../../game/domain/entities/game_type.dart';
import '../widgets/game_type_selector.dart';
import '../../../group/presentation/screens/player_management_screen.dart';
import '../../../adaptive_learning/presentation/bloc/adaptive_learning_bloc.dart';
import '../../../adaptive_learning/presentation/widgets/difficulty_indicator.dart';
import '../../../adaptive_learning/domain/entities/difficulty_prediction.dart';
import '../../../adaptive_learning/domain/entities/player_cognitive_profile.dart';

class ModeSelectionScreen extends StatefulWidget {
  final String gameMode;
  final int maxLinksAllowed;

  const ModeSelectionScreen({
    super.key,
    required this.gameMode,
    required this.maxLinksAllowed,
  });

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  GameType _selectedGameType = GameConstants.defaultGameType;
  RepresentationType _selectedType = RepresentationType.text;
  late int _selectedLinks;
  int? _selectedPlayers;
  String _selectedCategory = GameConstants.linkCategoryAny;
  String _selectedGroupProfile = GameConstants.groupProfiles.first;
  List<PlayerInfo> _customPlayers = [];

  @override
  void initState() {
    super.initState();
    final cappedDefault = widget.gameMode == 'practice'
        ? widget.maxLinksAllowed.clamp(GameConstants.minLinks, 5)
        : widget.maxLinksAllowed;
    _selectedLinks = GameConstants.defaultLinks.clamp(
      GameConstants.minLinks,
      cappedDefault,
    );
    if (widget.gameMode == 'group') {
      _selectedPlayers = GameConstants.minPlayers;
      // Initialize with default players
      _customPlayers = List.generate(
        GameConstants.minPlayers,
        (index) => PlayerInfo(
          id: 'player_$index',
          name: 'Player ${index + 1}',
          isHost: index == 0,
        ),
      );
    }
  }

  int get _effectiveMaxLinks {
    if (widget.gameMode == 'practice') {
      return widget.maxLinksAllowed.clamp(GameConstants.minLinks, 5);
    }
    return widget.maxLinksAllowed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getModeTitle()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Game Type Selection
              GameTypeSelector(
                selectedGameType: _selectedGameType,
                onGameTypeSelected: (gameType) {
                  setState(() {
                    _selectedGameType = gameType;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Representation Type Selection
              Text(
                'Select Representation Type',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              _buildRepresentationTypeSelector(),
              const SizedBox(height: 32),

              // Link Theme Selection
              if (widget.gameMode == 'solo' || widget.gameMode == 'group') ...[
                Text(
                  'Choose Link Theme',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                _buildCategorySelector(),
                const SizedBox(height: 32),
              ],

              // Difficulty Selection
              Text(
                'Select Difficulty (Number of Links)',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'Current phase allows up to $_effectiveMaxLinks links',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              BlocBuilder<AdaptiveLearningBloc, AdaptiveLearningState>(
                builder: (context, adaptiveState) {
                  final profile = adaptiveState.profile;
                  final prediction = adaptiveState.prediction;
                  if (adaptiveState.status != AdaptiveLearningStatus.ready ||
                      profile == null ||
                      prediction == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DifficultyIndicator(
                        profile: profile,
                        prediction: prediction,
                        learningPath: adaptiveState.learningPath,
                        onApplyRecommendation: () {
                          setState(() {
                            _selectedLinks = prediction.recommendedLinks.clamp(
                              GameConstants.minLinks,
                              _effectiveMaxLinks,
                            );
                          });
                        },
                      ),
                      if (widget.gameMode == 'solo') ...[
                        const SizedBox(height: 12),
                        _buildBrainGymQuickStart(
                          context,
                          prediction,
                          profile,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildDifficultySelector(),
              const SizedBox(height: 32),

              // Players Selection (for group mode)
              if (widget.gameMode == 'group') ...[
                Text(
                  'Group Identity',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                _buildGroupProfileSelector(),
                const SizedBox(height: 32),
                Text(
                  'Players',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                _buildPlayersManagementSection(),
                const SizedBox(height: 32),
              ],

              const SizedBox(height: 32),

              // Start Button
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Start Game',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getModeTitle() {
    switch (widget.gameMode) {
      case 'solo':
        return 'Solo Mode';
      case 'group':
        return 'Group Mode';
      case 'practice':
        return 'Practice Mode';
      default:
        return 'Select Mode';
    }
  }

  Widget _buildRepresentationTypeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildTypeChip('Text', RepresentationType.text, Icons.text_fields),
        _buildTypeChip('Icon', RepresentationType.icon, Icons.tag),
        _buildTypeChip('Image', RepresentationType.image, Icons.image),
        _buildTypeChip('Event', RepresentationType.event, Icons.event),
      ],
    );
  }

  Widget _buildTypeChip(String label, RepresentationType type, IconData icon) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = type;
        });
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      children: [
        Slider(
          value: _selectedLinks.toDouble(),
          min: GameConstants.minLinks.toDouble(),
          max: _effectiveMaxLinks.toDouble(),
          divisions: (_effectiveMaxLinks - GameConstants.minLinks)
              .clamp(1, 50)
              .toInt(),
          label: '$_selectedLinks links',
          onChanged: (value) {
            setState(() {
              _selectedLinks = value.toInt().clamp(
                    GameConstants.minLinks,
                    _effectiveMaxLinks,
                  );
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('${GameConstants.minLinks}'),
            Text(
              '$_selectedLinks Links',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('$_effectiveMaxLinks'),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayersManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Quick count selector (for backward compatibility)
        Text(
          'Quick Select: Number of Players',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Generate options from minPlayers to 20 (or more)
            ...List.generate(
              20 - GameConstants.minPlayers + 1, // Show up to 20 players
              (index) {
                final count = GameConstants.minPlayers + index;
                final isSelected = _selectedPlayers == count;
                return ChoiceChip(
                  label: Text('$count'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPlayers = count;
                      // Update custom players list
                      _customPlayers = List.generate(
                        count,
                        (index) => PlayerInfo(
                          id: 'player_$index',
                          name: 'Player ${index + 1}',
                          isHost: index == 0,
                        ),
                      );
                    });
                  },
                  selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                );
              },
            ),
            // Custom option for unlimited players
            ChoiceChip(
              label: const Text('Custom'),
              selected: _selectedPlayers != null && _selectedPlayers! > 20,
              onSelected: (selected) {
                if (selected) {
                  // Open player management for custom number
                  _openPlayerManagement();
                }
              },
              selectedColor: AppColors.secondary.withValues(alpha: 0.2),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Current players preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Players (${_customPlayers.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: _openPlayerManagement,
                    icon: const Icon(Icons.edit),
                    label: const Text('Manage'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _customPlayers.map((player) {
                  return Chip(
                    avatar: player.isHost
                        ? const Icon(Icons.star,
                            size: 18, color: AppColors.accent)
                        : const Icon(Icons.person, size: 18),
                    label: Text(player.name),
                    backgroundColor: player.isHost
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openPlayerManagement() async {
    final result = await Navigator.push<List<PlayerInfo>>(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerManagementScreen(
          initialPlayers: _customPlayers,
          onPlayersConfirmed: (players) {
            // This will be called when players are confirmed
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _customPlayers = result;
        _selectedPlayers = result.length;
      });
    }
  }

  void _startGame() {
    if (widget.gameMode == 'group' && _customPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 2 players'),
        ),
      );
      return;
    }

    final links = _selectedLinks.clamp(
      GameConstants.minLinks,
      _effectiveMaxLinks,
    );
    Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {
        'gameType': _selectedGameType,
        'representationType': _selectedType,
        'linksCount': links,
        'gameMode': widget.gameMode,
        'playersCount': widget.gameMode == 'group'
            ? _customPlayers.length
            : _selectedPlayers,
        'category': _selectedCategory == GameConstants.linkCategoryAny
            ? null
            : _selectedCategory,
        'groupProfile':
            widget.gameMode == 'group' ? _selectedGroupProfile : null,
        'customPlayers': widget.gameMode == 'group'
            ? _customPlayers
                .map((p) => {'id': p.id, 'name': p.name, 'isHost': p.isHost})
                .toList()
            : null,
      },
    );
  }

  Widget _buildBrainGymQuickStart(
    BuildContext context,
    DifficultyPrediction prediction,
    PlayerCognitiveProfile profile,
  ) {
    final themeSuggestion = prediction.recommendedThemes.isNotEmpty
        ? prediction.recommendedThemes.first
        : null;
    return Card(
      color: AppColors.accent.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brain Gym (3-round sprint)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Recommended: ${prediction.recommendedLinks} links · ${prediction.suggestedTimePerStep.inSeconds}s/step'
              '${themeSuggestion != null ? ' · Theme: $themeSuggestion' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () =>
                  _startBrainGymQuick(prediction, profile, themeSuggestion),
              icon: const Icon(Icons.flash_on),
              label: const Text('Start Brain Gym now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startBrainGymQuick(
    DifficultyPrediction prediction,
    PlayerCognitiveProfile profile,
    String? category,
  ) async {
    await Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {
        'representationType': profile.preferredRepresentation,
        'linksCount': prediction.recommendedLinks,
        'gameMode': 'brainGym',
        'category': category,
        'brainGymTotalRounds': 3,
        'brainGymCurrentRound': 1,
        'brainGymAccumulatedScore': 0,
      },
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: GameConstants.linkCategories.map((category) {
        final isSelected = _selectedCategory == category;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              _selectedCategory = category;
            });
          },
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
        );
      }).toList(),
    );
  }

  Widget _buildGroupProfileSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: GameConstants.groupProfiles.map((profile) {
        final isSelected = _selectedGroupProfile == profile;
        return ChoiceChip(
          label: Text(profile),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              _selectedGroupProfile = profile;
            });
          },
          selectedColor: AppColors.secondary.withValues(alpha: 0.2),
        );
      }).toList(),
    );
  }
}
