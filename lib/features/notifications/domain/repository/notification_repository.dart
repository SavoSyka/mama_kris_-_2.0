import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
  Future<Either<Failure, NotificationModel>> getNotificationById(String id);
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, void>> saveNotification(NotificationModel notification);
}