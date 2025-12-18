import 'package:equatable/equatable.dart';

abstract class EmailSubscriptionEvent extends Equatable {
  const EmailSubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class SubscribeEmailEvent extends EmailSubscriptionEvent {
  final String email;

  const SubscribeEmailEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class UnsubscribeEmailEvent extends EmailSubscriptionEvent {
  final String email;

  const UnsubscribeEmailEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
