import 'package:equatable/equatable.dart';

abstract class EmailSubscriptionState extends Equatable {
  const EmailSubscriptionState();

  @override
  List<Object?> get props => [];
}

class EmailSubscriptionInitial extends EmailSubscriptionState {}

class EmailSubscriptionLoading extends EmailSubscriptionState {}

class EmailSubscriptionSuccess extends EmailSubscriptionState {
  final String message;

  const EmailSubscriptionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailSubscriptionFailure extends EmailSubscriptionState {
  final String message;

  const EmailSubscriptionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
