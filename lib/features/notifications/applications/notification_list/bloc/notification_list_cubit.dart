import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';
import 'package:mama_kris/features/notifications/domain/repository/notification_repository.dart';

part 'notification_list_state.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  final NotificationRepository repository;

  NotificationListCubit(this.repository) : super(NotificationListInitial());

  Future<void> loadNotifications() async {
    emit(NotificationListLoading());
    final result = await repository.getNotifications();
    result.fold(
      (failure) => emit(NotificationListError(failure.message)),
      (notifications) => emit(NotificationListLoaded(notifications)),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await repository.markAsRead(id);
    result.fold(
      (failure) => emit(NotificationListError(failure.message)),
      (_) => loadNotifications(), // Reload to update the list
    );
  }

  Future<void> markAllAsRead() async {
    final result = await repository.markAllAsRead();
    result.fold(
      (failure) => emit(NotificationListError(failure.message)),
      (_) => loadNotifications(), // Reload to update the list
    );
  }

  Future<void> deleteNotification(String id) async {
    final result = await repository.deleteNotification(id);
    result.fold(
      (failure) => emit(NotificationListError(failure.message)),
      (_) => loadNotifications(), // Reload to update the list
    );
  }
}