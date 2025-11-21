import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

// class HandleLaunchUrl {
//   static Future<void> launchUrls(
//     BuildContext context, {
//     required String url,
//   }) async {
//     final uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       // CustomToastification(context, message: "Could not launch $url");
//       throw 'Could not launch $url';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HandleLaunchUrl {
  // * ────────────── Default Launch ───────────────────────
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

  // * ────────────── Generic URL launcher (fallback) ───────────────────────

  //
  static Future<bool> launchUrlGeneric(
    BuildContext context, {
    required String url,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: mode);
    } else {
      _showError(context, "Could not open: $url");
      return false;
    }
  }

  // * ────────────── VK URL launcher ───────────────────────

  // Launch VK profile or group
  static Future<bool> launchVK(
    BuildContext context, {
    required String vkId, // e.g., "id123456" or "club123456"
  }) async {
    final url = 'https://vk.com/$vkId';
    return await launchUrlGeneric(context, url: url);
  }

  // * ────────────── Launch Telegram user, bot, or chat ───────────────────────

  static Future<bool> launchTelegram(
    BuildContext context, {
    required String username,
    String? message,
  }) async {
    if (username.startsWith('@')) {
      username = username.substring(1);
    }
    String url = 'https://t.me/$username';
    if (message != null && message.isNotEmpty) {
      url += '?start=${Uri.encodeComponent(message)}';
    }
    return await launchUrlGeneric(context, url: url);
  }

  // * ──────────────  Launch WhatsApp chat ───────────────────────

  static Future<bool> launchWhatsApp(
    BuildContext context, {
    required String phone, // international format: "79161234567"
    String message = 'Hell', // optional message
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/$phone?text=$encodedMessage';
    return await launchUrlGeneric(context, url: url);
  }

  // * ──────────────  Make a phone call ───────────────────────
  static Future<bool> launchPhoneCall(
    BuildContext context, {
    required String phone, // e.g., "+79161234567"
  }) async {
    final url = 'tel:$phone';
    return await launchUrlGeneric(
      context,
      url: url,
      mode: LaunchMode.externalApplication,
    );
  }

  // * ──────────────  Email ───────────────────────

  static Future<bool> launchEmail(
    BuildContext context, {
    required String email,
    String subject = '',
    String body = '',
  }) async {
    final params = <String, String>{};
    if (subject.isNotEmpty) params['subject'] = subject;
    if (body.isNotEmpty) params['body'] = body;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: params.isNotEmpty ? params : null,
    );

    return await launchUrlGeneric(context, url: uri.toString());
  }

  // * ──────────────  Show error toast ───────────────────────

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
