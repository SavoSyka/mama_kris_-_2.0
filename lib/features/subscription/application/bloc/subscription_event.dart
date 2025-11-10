import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class FetchSubscriptionEvent extends SubscriptionEvent {

  const FetchSubscriptionEvent();
}
