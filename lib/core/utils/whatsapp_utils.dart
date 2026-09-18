import 'package:url_launcher/url_launcher.dart';

abstract final class WhatsAppUtils {
  /// Opens WhatsApp directed to [phone] with a prefilled [message].
  ///
  /// The [phone] is stripped of its leading `+` as required by the `wa.me` API.
  static Future<bool> sendLink(String phone, String message) async {
    // URL-encode the message
    final encodedMessage = Uri.encodeComponent(message);
    // Remove the leading '+' for wa.me format
    final cleanPhone = phone.startsWith('+') ? phone.substring(1) : phone;

    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMessage');
    
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
