import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../game/domain/entities/link_node.dart';
import '../../../game/domain/entities/game_type.dart';
import '../../../mode_selection/presentation/widgets/game_type_selector.dart';
import '../../../multiplayer/data/services/cloudflare_multiplayer_service.dart';
import 'player_management_screen.dart';
import '../widgets/qr_code_dialog.dart';
import '../../domain/entities/custom_puzzle.dart';
import 'create_custom_puzzle_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  final int maxLinksAllowed;

  const CreateGroupScreen({
    super.key,
    required this.maxLinksAllowed,
  });

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  // Group Profile
  String _selectedGroupProfile = GameConstants.groupProfiles.first;

  // Players
  List<PlayerInfo> _players = [];

  // Game Settings
  GameType _selectedGameType = GameConstants.defaultGameType;
  RepresentationType _selectedType = RepresentationType.text;
  int _selectedLinks = GameConstants.defaultLinks;
  String _selectedCategory = GameConstants.linkCategoryAny;

  // Puzzle Mode
  String _puzzleMode = 'auto'; // 'auto' or 'manual'
  CustomPuzzle? _customPuzzle;

  // Invite Settings
  String? _inviteCode;
  String? _deepLink;

  // Cloudflare Multiplayer
  // Note: These are set in _createCloudflareRoom() and used in _startGame()
  String? _cloudflareRoomId;
  CloudflareMultiplayerService? _multiplayerService;

  @override
  void initState() {
    super.initState();
    _selectedLinks = GameConstants.defaultLinks.clamp(
      GameConstants.minLinks,
      widget.maxLinksAllowed,
    );
    // Initialize with minimum players
    _players = List.generate(
      GameConstants.minPlayers,
      (index) => PlayerInfo(
        id: 'player_$index',
        name: 'Player ${index + 1}',
        isHost: index == 0,
      ),
    );
    _generateInviteCode();
  }

  void _generateInviteCode() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    _inviteCode = random.toString().padLeft(4, '0');
    _deepLink = 'mysterylink://join?code=$_inviteCode';
  }

  void _openPlayerManagement() async {
    final result = await Navigator.push<List<PlayerInfo>>(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerManagementScreen(
          initialPlayers: _players,
          onPlayersConfirmed: (players) {},
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _players = result;
      });
    }
  }

  void _showInviteOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text(
                'Invite Players',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Quick invite options
              _buildQuickInviteOption(
                icon: Icons.qr_code,
                title: 'Show QR Code',
                subtitle: 'Let players scan to join',
                onTap: () {
                  Navigator.pop(context);
                  _showQRCode();
                },
              ),
              const SizedBox(height: 12),
              _buildQuickInviteOption(
                icon: Icons.share,
                title: 'Share Invite',
                subtitle: 'Share via WhatsApp, Telegram, etc.',
                onTap: () {
                  Navigator.pop(context);
                  _showQRCode();
                },
              ),
              const SizedBox(height: 12),
              _buildQuickInviteOption(
                icon: Icons.vpn_key,
                title: 'Copy Invite Code',
                subtitle: 'Code: $_inviteCode',
                onTap: () {
                  Navigator.pop(context);
                  _copyInviteCode();
                },
              ),
              const SizedBox(height: 12),
              _buildQuickInviteOption(
                icon: Icons.link,
                title: 'Copy Invite Link',
                subtitle: 'Direct link to join',
                onTap: () {
                  Navigator.pop(context);
                  _copyInviteLink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInviteOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => QRCodeDialog(
        inviteCode: _inviteCode ?? '0000',
        deepLink: _deepLink,
      ),
    );
  }

  void _copyInviteCode() async {
    if (_inviteCode != null) {
      await _copyToClipboard(_inviteCode!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invite code copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _copyInviteLink() async {
    if (_deepLink != null) {
      await _copyToClipboard(_deepLink!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invite link copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await FlutterClipboard.copy(text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _createCloudflareRoom() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.cloudflareWorkerHttpUrl}/api/create-room'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _cloudflareRoomId = data['roomId'] as String;

        // إنشاء CloudflareMultiplayerService
        _multiplayerService = CloudflareMultiplayerService(
          baseUrl: AppConstants.cloudflareWorkerUrl,
        );

        // الاتصال بالغرفة (سيتم الاتصال الفعلي في AppRouter)
        return;
      } else {
        throw Exception('Failed to create room: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating Cloudflare room: $e');
      // في حالة الفشل، نستمر بدون multiplayer
      _cloudflareRoomId = null;
      _multiplayerService = null;
    }
  }

  Future<void> _startGame() async {
    if (_players.length < GameConstants.minPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least ${GameConstants.minPlayers} players',
          ),
        ),
      );
      return;
    }

    if (_puzzleMode == 'manual' && _customPuzzle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please create a custom puzzle first'),
        ),
      );
      return;
    }

    // إنشاء Cloudflare room
    await _createCloudflareRoom();

    final links = _puzzleMode == 'auto'
        ? _selectedLinks.clamp(
            GameConstants.minLinks,
            widget.maxLinksAllowed,
          )
        : _customPuzzle!.steps.length;

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRouter.game,
      arguments: {
        'gameType': _selectedGameType,
        'representationType': _selectedType,
        'linksCount': links,
        'gameMode': 'group',
        'playersCount': _players.length,
        'category': _puzzleMode == 'auto' &&
                _selectedCategory != GameConstants.linkCategoryAny
            ? _selectedCategory
            : null,
        'groupProfile': _selectedGroupProfile,
        'customPlayers': _players
            .map((p) => {
                  'id': p.id,
                  'name': p.name,
                  'isHost': p.isHost,
                })
            .toList(),
        'customPuzzle':
            _puzzleMode == 'manual' ? _customPuzzle!.toJson() : null,
        'puzzleMode': _puzzleMode,
        'roomId':
            _cloudflareRoomId, // Pass Cloudflare room ID (for backward compatibility)
        'cloudflareRoomId': _cloudflareRoomId, // Pass Cloudflare room ID
        'multiplayerService': _multiplayerService, // Pass the service instance
      },
    );
  }

  Widget _buildPuzzleModeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Auto',
                subtitle: 'App selects puzzle',
                icon: Icons.auto_awesome,
                isSelected: _puzzleMode == 'auto',
                onTap: () {
                  setState(() {
                    _puzzleMode = 'auto';
                    _customPuzzle = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModeCard(
                title: 'Manual',
                subtitle: 'Create your own',
                icon: Icons.edit,
                isSelected: _puzzleMode == 'manual',
                onTap: () {
                  _openCustomPuzzleCreator();
                },
              ),
            ),
          ],
        ),
        if (_puzzleMode == 'manual' && _customPuzzle == null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ElevatedButton.icon(
              onPressed: _openCustomPuzzleCreator,
              icon: const Icon(Icons.add),
              label: const Text('Create Custom Puzzle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.textSecondary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : null,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openCustomPuzzleCreator() async {
    final puzzle = await Navigator.push<CustomPuzzle>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCustomPuzzleScreen(
          representationType: _selectedType,
          onPuzzleCreated: (puzzle) {
            Navigator.pop(context, puzzle);
          },
        ),
      ),
    );

    if (puzzle != null) {
      setState(() {
        _customPuzzle = puzzle;
        _puzzleMode = 'manual';
      });
    }
  }

  Widget _buildCustomPuzzlePreview() {
    if (_customPuzzle == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                'Custom Puzzle Created',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _openCustomPuzzleCreator,
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Start: ${_customPuzzle!.start.label}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'End: ${_customPuzzle!.end.label}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'Steps: ${_customPuzzle!.steps.length}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Invite Players',
            onPressed: _showInviteOptions,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group Profile Selection
              _buildSection(
                title: 'Group Identity',
                subtitle: 'Choose the type of your group',
                child: _buildGroupProfileSelector(),
              ),

              const SizedBox(height: 32),

              // Players Management
              _buildSection(
                title: 'Players',
                subtitle: '${_players.length} players added',
                child: _buildPlayersSection(),
              ),

              const SizedBox(height: 32),

              // Game Type Selection
              _buildSection(
                title: 'Game Type',
                subtitle: 'Choose the type of game to play',
                child: GameTypeSelector(
                  selectedGameType: _selectedGameType,
                  onGameTypeSelected: (gameType) {
                    setState(() {
                      _selectedGameType = gameType;
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Puzzle Mode
              _buildSection(
                title: 'Puzzle Mode',
                subtitle: 'Choose how puzzles are selected',
                child: _buildPuzzleModeSelector(),
              ),

              const SizedBox(height: 32),

              // Custom Puzzle Preview (if manual mode)
              if (_puzzleMode == 'manual' && _customPuzzle != null)
                _buildCustomPuzzlePreview(),

              if (_puzzleMode == 'manual' && _customPuzzle != null)
                const SizedBox(height: 32),

              // Representation Type
              _buildSection(
                title: 'Representation Type',
                subtitle: 'How should puzzles be displayed?',
                child: _buildRepresentationTypeSelector(),
              ),

              const SizedBox(height: 32),

              // Category Selection (only for auto mode)
              if (_puzzleMode == 'auto') ...[
                _buildSection(
                  title: 'Puzzle Category',
                  subtitle: 'Choose a theme for puzzles',
                  child: _buildCategorySelector(),
                ),
                const SizedBox(height: 32),

                // Difficulty Selection (only for auto mode)
                _buildSection(
                  title: 'Difficulty',
                  subtitle:
                      'Number of links (${GameConstants.minLinks}-${widget.maxLinksAllowed})',
                  child: _buildDifficultySelector(),
                ),
              ],

              const SizedBox(height: 32),

              // Start Game Button
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start Group Game',
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

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildGroupProfileSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: GameConstants.groupProfiles.map((profile) {
        final isSelected = _selectedGroupProfile == profile;
        return FilterChip(
          label: Text(profile),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedGroupProfile = profile;
            });
          },
          selectedColor: AppColors.secondary.withValues(alpha: 0.2),
          checkmarkColor: AppColors.secondary,
          avatar: Icon(
            _getProfileIcon(profile),
            size: 18,
            color: isSelected ? AppColors.secondary : AppColors.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  IconData _getProfileIcon(String profile) {
    switch (profile.toLowerCase()) {
      case 'students':
        return Icons.school;
      case 'school':
        return Icons.business;
      case 'friends':
        return Icons.people;
      case 'family':
        return Icons.family_restroom;
      case 'colleagues':
        return Icons.work;
      case 'club':
        return Icons.group;
      case 'community':
        return Icons.public;
      default:
        return Icons.group;
    }
  }

  Widget _buildPlayersSection() {
    return Column(
      children: [
        // Players Preview
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
                    'Current Players',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: _openPlayerManagement,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Manage'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _players.map((player) {
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

  Widget _buildDifficultySelector() {
    return Column(
      children: [
        Slider(
          value: _selectedLinks.toDouble(),
          min: GameConstants.minLinks.toDouble(),
          max: widget.maxLinksAllowed.toDouble(),
          divisions: (widget.maxLinksAllowed - GameConstants.minLinks)
              .clamp(1, 50)
              .toInt(),
          label: '$_selectedLinks links',
          onChanged: (value) {
            setState(() {
              _selectedLinks = value.toInt().clamp(
                    GameConstants.minLinks,
                    widget.maxLinksAllowed,
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
            Text('${widget.maxLinksAllowed}'),
          ],
        ),
      ],
    );
  }
}
