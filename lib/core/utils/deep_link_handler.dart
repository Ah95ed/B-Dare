import 'package:url_launcher/url_launcher.dart';

class DeepLinkHandler {
  /// Generate a deep link for joining a game
  static String generateJoinLink(String inviteCode) {
    return 'mysterylink://join?code=$inviteCode';
  }

  /// Generate a web link (for sharing when app is not installed)
  static String generateWebLink(String inviteCode) {
    // In production, this would be your website URL
    return 'https://mysterylink.app/join?code=$inviteCode';
  }

  /// Handle incoming deep link
  static Future<Map<String, String>?> handleDeepLink(String link) async {
    try {
      final uri = Uri.parse(link);
      
      if (uri.scheme == 'mysterylink' && uri.host == 'join') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          return {'action': 'join', 'code': code};
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if a URL can be launched
  static Future<bool> canLaunchUrlString(String url) async {
    try {
      final uri = Uri.parse(url);
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launch a URL
  static Future<bool> launchUrlString(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

