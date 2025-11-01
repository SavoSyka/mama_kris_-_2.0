import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mama_kris/core/services/firebase/local_notification_service.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';
import 'package:mama_kris/features/notifications/domain/repository/notification_repository.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

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

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await FirebaseMessaging.instance.getToken();
    print('Push notifications token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('FCM token refreshed: $fcmToken');
      // TODO: optionally send token to your server for targeting this device
    }).onError((error) {
      // Handle errors during token refresh
      print('Error refreshing FCM token: $error');
    });
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Save notification to local storage
      await _saveNotificationFromMessage(message);

      // Display a local notification using the service
      _localNotificationsService?.showNotification(
          notificationData.title, notificationData.body, message.data.toString());
    }
  }

  /// Saves notification from FCM message to local storage
  Future<void> _saveNotificationFromMessage(RemoteMessage message) async {
    try {
      final notificationData = message.notification;
      if (notificationData != null) {
        final notification = NotificationModel(
          id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: notificationData.title ?? 'Notification',
          body: notificationData.body ?? '',
          imageUrl: notificationData.android?.imageUrl ?? notificationData.apple?.imageUrl,
          timestamp: message.sentTime ?? DateTime.now(),
          data: message.data,
        );

        final repository = sl<NotificationRepository>();
        await repository.saveNotification(notification);
        print('Notification saved: ${notification.id}');
      }
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data.toString()}');
    // Save notification if not already saved
    _saveNotificationFromMessage(message);

    // Navigate to notification detail if notification ID is provided
    final notificationId = message.messageId ?? message.data['notificationId'];
    if (notificationId != null && notificationId.isNotEmpty) {
      // For now, we'll print and assume navigation is handled elsewhere
      // In a real app, you'd use a navigation service or global key
      print('Should navigate to notification detail: $notificationId');
    }
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}