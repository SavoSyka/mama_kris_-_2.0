import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';
import 'package:mama_kris/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final notifications = await localDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(CacheFailure('Failed to get notifications: $e'));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> getNotificationById(String id) async {
    try {
      final notification = await localDataSource.getNotificationById(id);
      if (notification != null) {
        return Right(notification);
      } else {
        return const Left(CacheFailure('Notification not found'));
      }
    } catch (e) {
      return Left(CacheFailure('Failed to get notification: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await localDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to mark notification as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await localDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to mark all notifications as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await localDataSource.deleteNotification(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete notification: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveNotification(NotificationModel notification) async {
    try {
      await localDataSource.saveNotification(notification);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save notification: $e'));
    }
  }
}