import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class FetchSubscriptionEvent extends SubscriptionEvent {

  const FetchSubscriptionEvent();
}

class InitiatePaymentEvent extends SubscriptionEvent {
  final SubscriptionEntity tariff;

  const InitiatePaymentEvent({required this.tariff});

  @override
  List<Object> get props => [tariff];
}
