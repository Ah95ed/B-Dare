import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/game_constants.dart';
import '../widgets/qr_code_dialog.dart';

class PlayerInfo {
  final String id;
  String name;
  final bool isHost;

  PlayerInfo({
    required this.id,
    required this.name,
    this.isHost = false,
  });

  PlayerInfo copyWith({
    String? name,
    bool? isHost,
  }) {
    return PlayerInfo(
      id: id,
      name: name ?? this.name,
      isHost: isHost ?? this.isHost,
    );
  }
}

class PlayerManagementScreen extends StatefulWidget {
  final List<PlayerInfo> initialPlayers;
  final Function(List<PlayerInfo>) onPlayersConfirmed;

  const PlayerManagementScreen({
    super.key,
    required this.initialPlayers,
    required this.onPlayersConfirmed,
  });

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  late List<PlayerInfo> _players;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _players = List.from(widget.initialPlayers);
    for (final player in _players) {
      _controllers[player.id] = TextEditingController(text: player.name);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    // No limit on number of players
    final newId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    final newPlayer = PlayerInfo(
      id: newId,
      name: 'Player ${_players.length + 1}',
    );

    setState(() {
      _players.add(newPlayer);
      _controllers[newId] = TextEditingController(text: newPlayer.name);
    });

    // Show invite options after adding a player
    if (_players.length >= GameConstants.minPlayers) {
      _showInviteOptionsAfterAdd();
    }
  }

  void _showInviteOptionsAfterAdd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
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
                'Invite More Players',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share the invite code or link with players to join',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 20),

              // Quick invite options
              _buildQuickInviteOption(
                icon: Icons.qr_code,
                title: 'Show QR Code',
                subtitle: 'Let players scan to join',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  _shareInviteLink();
                },
              ),
              const SizedBox(height: 12),
              _buildQuickInviteOption(
                icon: Icons.share,
                title: 'Share Invite',
                subtitle: 'Share via WhatsApp, Telegram, etc.',
                color: AppColors.secondary,
                onTap: () {
                  Navigator.pop(context);
                  _shareInviteLink();
                },
              ),
              const SizedBox(height: 12),
              _buildQuickInviteOption(
                icon: Icons.vpn_key,
                title: 'Copy Invite Code',
                subtitle: 'Code: ${_generateInviteCode()}',
                color: AppColors.accent,
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
                color: AppColors.info,
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
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

  void _copyInviteCode() async {
    final inviteCode = _generateInviteCode();
    try {
      await FlutterClipboard.copy(inviteCode);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invite code copied: $inviteCode'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.success,
          ),
        );
      }
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

  void _copyInviteLink() async {
    final inviteCode = _generateInviteCode();
    final deepLink = _generateDeepLink(inviteCode);
    try {
      await FlutterClipboard.copy(deepLink);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invite link copied to clipboard'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.success,
          ),
        );
      }
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

  void _removePlayer(String playerId) {
    if (_players.length <= GameConstants.minPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Minimum ${GameConstants.minPlayers} players required',
          ),
        ),
      );
      return;
    }

    final player = _players.firstWhere((p) => p.id == playerId);
    if (player.isHost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot remove the host'),
        ),
      );
      return;
    }

    setState(() {
      _players.removeWhere((p) => p.id == playerId);
      _controllers[playerId]?.dispose();
      _controllers.remove(playerId);
    });
  }

  void _updatePlayerName(String playerId, String newName) {
    setState(() {
      final index = _players.indexWhere((p) => p.id == playerId);
      if (index != -1) {
        _players[index] = _players[index].copyWith(
            name: newName.trim().isEmpty
                ? 'Player ${index + 1}'
                : newName.trim());
        _controllers[playerId]?.text = _players[index].name;
      }
    });
  }

  void _confirmPlayers() {
    // Update all player names from controllers
    for (final player in _players) {
      final controller = _controllers[player.id];
      if (controller != null && controller.text.trim().isNotEmpty) {
        _updatePlayerName(player.id, controller.text);
      }
    }

    widget.onPlayersConfirmed(_players);
    Navigator.pop(context, _players);
  }

  void _shareInviteLink() {
    // Generate a simple invite code (in real implementation, this would be a server-generated code)
    final inviteCode = _generateInviteCode();

    // Generate deep link
    final deepLink = _generateDeepLink(inviteCode);

    showDialog(
      context: context,
      builder: (context) => QRCodeDialog(
        inviteCode: inviteCode,
        deepLink: deepLink,
      ),
    );
  }

  String _generateDeepLink(String inviteCode) {
    // Generate deep link for the app
    // Format: mysterylink://join?code=1234
    return 'mysterylink://join?code=$inviteCode';
  }

  String _generateInviteCode() {
    // Simple code generation (in real implementation, use server-generated codes)
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return random.toString().padLeft(4, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Players'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Invite Players',
            onPressed: _shareInviteLink,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add players manually or invite them using the invite code',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            // Players List
            Expanded(
              child: _players.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No players added yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add players',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        final player = _players[index];
                        return _buildPlayerCard(player, index);
                      },
                    ),
            ),

            // Invite Section
            if (_players.length >= GameConstants.minPlayers)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_add, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Invite Players',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Share the invite code or link with players to join your game',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInviteButton(
                          icon: Icons.qr_code,
                          label: 'QR Code',
                          onTap: _shareInviteLink,
                          color: AppColors.primary,
                        ),
                        _buildInviteButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: _shareInviteLink,
                          color: AppColors.secondary,
                        ),
                        _buildInviteButton(
                          icon: Icons.vpn_key,
                          label: 'Copy Code',
                          onTap: _copyInviteCode,
                          color: AppColors.accent,
                        ),
                        _buildInviteButton(
                          icon: Icons.link,
                          label: 'Copy Link',
                          onTap: _copyInviteLink,
                          color: AppColors.info,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Add Player Button (always visible, no limit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: _addPlayer,
                icon: const Icon(Icons.add),
                label: const Text('Add Player'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _players.length >= GameConstants.minPlayers
                    ? _confirmPlayers
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Confirm Players (${_players.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(PlayerInfo player, int index) {
    final controller = _controllers[player.id] ?? TextEditingController();
    final isHost = player.isHost;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isHost ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isHost ? AppColors.accent.withValues(alpha: 0.3) : Colors.transparent,
          width: isHost ? 1.5 : 0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isHost
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: isHost ? AppColors.accent : AppColors.primary,
            child: Icon(
              isHost ? Icons.star : Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Player ${index + 1}',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isHost ? FontWeight.bold : FontWeight.w500,
                  color: isHost ? AppColors.accent : null,
                ),
            onChanged: (value) {
              _updatePlayerName(player.id, value);
            },
            onSubmitted: (value) {
              _updatePlayerName(player.id, value);
            },
          ),
          subtitle: isHost
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Host',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                )
              : null,
          trailing: isHost
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: AppColors.accent,
                    size: 20,
                  ),
                )
              : IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                    ),
                  ),
                  color: AppColors.error,
                  tooltip: 'Remove Player',
                  onPressed: () => _removePlayer(player.id),
                ),
        ),
      ),
    );
  }

  Widget _buildInviteButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
