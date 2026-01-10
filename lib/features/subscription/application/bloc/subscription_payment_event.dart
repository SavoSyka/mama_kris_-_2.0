import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class SubscriptionPaymentEvent extends Equatable {
  const SubscriptionPaymentEvent();

  @override
  List<Object> get props => [];
}

class InitiatePaymentEvent extends SubscriptionPaymentEvent {
  final SubscriptionEntity tariff;

  const InitiatePaymentEvent({required this.tariff});

  @override
  List<Object> get props => [tariff];
}

class ResetPaymentStateEvent extends SubscriptionPaymentEvent {
  const ResetPaymentStateEvent();
}
