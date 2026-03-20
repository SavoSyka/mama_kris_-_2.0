import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:mama_kris/core/services/firebase/local_notification_service.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/utils/get_platform_type.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';
import 'package:mama_kris/features/notifications/domain/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._internal();

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService.instance() => _instance;

  LocalNotificationsService? _localNotificationsService;

  static const _fcmTokenKey = 'fcm_device_token';

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init(
      {required LocalNotificationsService localNotificationsService}) async {
    _localNotificationsService = localNotificationsService;

    // Request user permission for notifications
    await _requestPermission();

    // Handle FCM token
    await _handlePushNotificationsToken();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Retrieves FCM token and saves it locally.
  /// Does NOT register on server — that happens after login via [registerTokenAfterLogin].
  Future<void> _handlePushNotificationsToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $token');

    if (token != null) {
      await _saveTokenLocally(token);
    }

    // Listen for token refresh — save locally, register only if authenticated
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      debugPrint('FCM token refreshed: $fcmToken');
      await _saveTokenLocally(fcmToken);
      // Re-register on server only if user is already logged in
      final authToken = await sl<AuthLocalDataSource>().getToken();
      if (authToken.isNotEmpty) {
        _registerTokenOnServer(fcmToken);
      }
    }).onError((error) {
      debugPrint('Error refreshing FCM token: $error');
    });
  }

  /// Registers the FCM token with the backend server
  Future<void> _registerTokenOnServer(String fcmToken) async {
    try {
      // Check if user is authenticated before sending token
      final authToken = await sl<AuthLocalDataSource>().getToken();
      if (authToken.isEmpty) {
        debugPrint('User not authenticated, skipping FCM token registration');
        // Save token locally so we can register it after login
        await _saveTokenLocally(fcmToken);
        return;
      }

      final dio = sl<Dio>();
      await dio.post(
        'notifications/register-token',
        data: {
          'token': fcmToken,
          'platform': platformType,
        },
      );
      debugPrint('FCM token registered on server');

      // Save token locally for later revocation
      await _saveTokenLocally(fcmToken);
    } catch (e) {
      debugPrint('Error registering FCM token on server: $e');
    }
  }

  /// Registers any saved FCM token after user logs in.
  /// Call this after successful authentication.
  Future<void> registerTokenAfterLogin() async {
    try {
      final token = await _getSavedToken();
      if (token != null && token.isNotEmpty) {
        await _registerTokenOnServer(token);
      } else {
        // If no saved token, get a fresh one
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _registerTokenOnServer(fcmToken);
        }
      }
    } catch (e) {
      debugPrint('Error registering token after login: $e');
    }
  }

  /// Revokes the FCM token from the backend server.
  /// Call this before logout.
  Future<void> revokeToken() async {
    try {
      final token = await _getSavedToken();
      if (token == null || token.isEmpty) {
        debugPrint('No FCM token to revoke');
        return;
      }

      final dio = sl<Dio>();
      await dio.delete(
        'notifications/revoke-token',
        data: {'token': token},
      );
      debugPrint('FCM token revoked on server');
    } catch (e) {
      debugPrint('Error revoking FCM token: $e');
    }
  }

  Future<void> _saveTokenLocally(String token) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setString(_fcmTokenKey, token);
  }

  Future<String?> _getSavedToken() async {
    final prefs = sl<SharedPreferences>();
    return prefs.getString(_fcmTokenKey);
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      await _saveNotificationFromMessage(message);

      // Show local notification for in-app display
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Saves notification from FCM message to local storage
  Future<void> _saveNotificationFromMessage(RemoteMessage message) async {
    try {
      final notificationData = message.notification;
      if (notificationData != null) {
        final notification = NotificationModel(
          id: message.messageId ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          title: notificationData.title ?? 'Notification',
          body: notificationData.body ?? '',
          imageUrl: notificationData.android?.imageUrl ??
              notificationData.apple?.imageUrl,
          timestamp: message.sentTime ?? DateTime.now(),
          data: message.data,
        );

        final repository = sl<NotificationRepository>();
        await repository.saveNotification(notification);
      }
    } catch (e) {
      debugPrint('Error saving notification: $e');
    }
  }

  /// Handles notification taps when app is opened from background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint(
        'Notification caused the app to open: ${message.data.toString()}');
    _saveNotificationFromMessage(message);
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.data.toString()}');
}
