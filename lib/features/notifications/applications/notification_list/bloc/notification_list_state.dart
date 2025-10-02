part of 'notification_list_cubit.dart';

abstract class NotificationListState extends Equatable {
  const NotificationListState();

  @override
  List<Object?> get props => [];
}

class NotificationListInitial extends NotificationListState {}

class NotificationListLoading extends NotificationListState {}

class NotificationListLoaded extends NotificationListState {
  final List<NotificationModel> notifications;

  const NotificationListLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationListError extends NotificationListState {
  final String message;

  const NotificationListError(this.message);

  @override
  List<Object?> get props => [message];
}