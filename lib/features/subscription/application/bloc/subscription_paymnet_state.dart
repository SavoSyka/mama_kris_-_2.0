// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';


abstract class SubscriptionPaymentState extends Equatable {
  const SubscriptionPaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitiatingState extends SubscriptionPaymentState {}


class PaymentLoadinState extends SubscriptionPaymentState {}

class PaymentInitiatedState extends SubscriptionPaymentState {
  final String paymentUrl;

  const PaymentInitiatedState({required this.paymentUrl});

  @override
  List<Object> get props => [paymentUrl];
}

class PaymentErrorState extends SubscriptionPaymentState {
  final String message;

  const PaymentErrorState(this.message);

  @override
  List<Object> get props => [message];
}
