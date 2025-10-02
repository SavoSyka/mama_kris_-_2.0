import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<NotificationModel?> getNotificationById(String id);
  Future<void> saveNotification(NotificationModel notification);
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> clearAllNotifications();
}