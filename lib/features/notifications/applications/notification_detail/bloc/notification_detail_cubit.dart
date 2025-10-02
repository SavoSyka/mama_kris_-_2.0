import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/notifications/domain/models/notification_model.dart';
import 'package:mama_kris/features/notifications/domain/repository/notification_repository.dart';

part 'notification_detail_state.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  final NotificationRepository repository;

  NotificationDetailCubit(this.repository) : super(NotificationDetailInitial());

  Future<void> loadNotification(String id) async {
    emit(NotificationDetailLoading());
    final result = await repository.getNotificationById(id);
    result.fold(
      (failure) => emit(NotificationDetailError(failure.message)),
      (notification) => emit(NotificationDetailLoaded(notification)),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await repository.markAsRead(id);
    result.fold(
      (failure) => emit(NotificationDetailError(failure.message)),
      (_) {
        // If currently loaded, update the state to reflect read status
        if (state is NotificationDetailLoaded) {
          final currentNotification = (state as NotificationDetailLoaded).notification;
          if (currentNotification.id == id) {
            final updatedNotification = currentNotification.copyWith(isRead: true);
            emit(NotificationDetailLoaded(updatedNotification));
          }
        }
      },
    );
  }
}