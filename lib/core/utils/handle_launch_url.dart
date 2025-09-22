import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HandleLaunchUrl {
  static Future<void> launchUrls(
    BuildContext context, {
    required String url,
  }) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // CustomToastification(context, message: "Could not launch $url");
      throw 'Could not launch $url';
    }
  }
}
