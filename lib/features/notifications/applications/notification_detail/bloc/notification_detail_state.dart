part of 'notification_detail_cubit.dart';

abstract class NotificationDetailState extends Equatable {
  const NotificationDetailState();

  @override
  List<Object?> get props => [];
}

class NotificationDetailInitial extends NotificationDetailState {}

class NotificationDetailLoading extends NotificationDetailState {}

class NotificationDetailLoaded extends NotificationDetailState {
  final NotificationModel notification;

  const NotificationDetailLoaded(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationDetailError extends NotificationDetailState {
  final String message;

  const NotificationDetailError(this.message);

  @override
  List<Object?> get props => [message];
}