import 'package:hive_flutter/hive_flutter.dart';
import 'package:mama_kris/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String _boxName = 'notifications';

  Future<Box<NotificationModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<NotificationModel>(_boxName);
    }
    return Hive.box<NotificationModel>(_boxName);
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final box = await _getBox();
    return box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by newest first
  }

  @override
  Future<NotificationModel?> getNotificationById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    final box = await _getBox();
    await box.put(notification.id, notification);
  }

  @override
  Future<void> markAsRead(String id) async {
    final box = await _getBox();
    final notification = box.get(id);
    if (notification != null) {
      final updatedNotification = notification.copyWith(isRead: true);
      await box.put(id, updatedNotification);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final box = await _getBox();
    final notifications = box.values.toList();
    for (final notification in notifications) {
      if (!notification.isRead) {
        final updatedNotification = notification.copyWith(isRead: true);
        await box.put(notification.id, updatedNotification);
      }
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  @override
  Future<void> clearAllNotifications() async {
    final box = await _getBox();
    await box.clear();
  }
}