import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';

class QRCodeDialog extends StatelessWidget {
  final String inviteCode;
  final String? deepLink;

  const QRCodeDialog({
    super.key,
    required this.inviteCode,
    this.deepLink,
  });

  void _copyToClipboard(BuildContext context, String text) {
    FlutterClipboard.copy(text).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _shareCode(BuildContext context) {
    final message = deepLink != null
        ? 'Join my Mystery Link game! Use code: $inviteCode\nOr click: $deepLink'
        : 'Join my Mystery Link game! Use code: $inviteCode';

    Share.share(
      message,
      subject: 'Join Mystery Link Game',
    );
  }

  void _shareViaWhatsApp(BuildContext context) {
    final message = deepLink != null
        ? 'Join my Mystery Link game! Use code: $inviteCode\nOr click: $deepLink'
        : 'Join my Mystery Link game! Use code: $inviteCode';

    // WhatsApp share URL format
    // Note: For direct WhatsApp sharing, url_launcher would be used
    // For now, we use Share which will show WhatsApp if available
    Share.share(message);
  }

  void _shareViaTelegram(BuildContext context) {
    final message = deepLink != null
        ? 'Join my Mystery Link game! Use code: $inviteCode\nOr click: $deepLink'
        : 'Join my Mystery Link game! Use code: $inviteCode';

    // Telegram share URL format
    // Note: For direct Telegram sharing, url_launcher would be used
    // For now, we use Share which will show Telegram if available
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final qrData = deepLink ?? inviteCode;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Invite Players',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Invite Code
              Text(
                'Invite Code',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      inviteCode,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(context, inviteCode),
                      tooltip: 'Copy code',
                    ),
                  ],
                ),
              ),

              // Deep Link (if available)
              if (deepLink != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Or share this link:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          deepLink!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () => _copyToClipboard(context, deepLink!),
                        tooltip: 'Copy link',
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Share Options
              Text(
                'Share via:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // Share Buttons Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildShareButton(
                    context,
                    icon: Icons.share,
                    label: 'Share',
                    color: AppColors.primary,
                    onTap: () => _shareCode(context),
                  ),
                  _buildShareButton(
                    context,
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: () => _shareViaWhatsApp(context),
                  ),
                  _buildShareButton(
                    context,
                    icon: Icons.send,
                    label: 'Telegram',
                    color: const Color(0xFF0088CC),
                    onTap: () => _shareViaTelegram(context),
                  ),
                  _buildShareButton(
                    context,
                    icon: Icons.email,
                    label: 'Email',
                    color: AppColors.textSecondary,
                    onTap: () {
                      const emailSubject = 'Join Mystery Link Game';
                      final emailBody = deepLink != null
                          ? 'Join my Mystery Link game! Use code: $inviteCode\nOr click: $deepLink'
                          : 'Join my Mystery Link game! Use code: $inviteCode';
                      Share.share(emailBody, subject: emailSubject);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Close Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
