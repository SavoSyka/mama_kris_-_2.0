part of 'subscription_status_cubit.dart';

abstract class SubscriptionStatusState {}

class SubscriptionStatusInitial extends SubscriptionStatusState {}

class SubscriptionStatusLoading extends SubscriptionStatusState {}

class SubscriptionStatusSuccess extends SubscriptionStatusState {
  final bool hasSubscription;
  final DateTime? expiresAt;
  final String? type;

  SubscriptionStatusSuccess({
    required this.hasSubscription,
    this.expiresAt,
    this.type,
  });
}

class GetSubscriptionStatusState extends SubscriptionStatusState {
  final bool hasSubscription;
  final DateTime? expiresAt;
  final DateTime? startsAt;
  final String? type;

  GetSubscriptionStatusState({
    required this.hasSubscription,
     this.startsAt,
    this.expiresAt,
    this.type,
  });
}

class SubscriptionStatusError extends SubscriptionStatusState {
  final String message;

  SubscriptionStatusError(this.message);
}
