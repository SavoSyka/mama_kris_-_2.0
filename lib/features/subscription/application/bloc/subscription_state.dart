// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitialState extends SubscriptionState {}

class SubscriptionLoadingState extends SubscriptionState {}

class SubscriptionLoadedState extends SubscriptionState {
  final List<SubscriptionEntity> subscriptions;

  const SubscriptionLoadedState({required this.subscriptions});

  @override
  List<Object> get props => [subscriptions];
}

class SubscriptionErrorState extends SubscriptionState {
  final String message;

  const SubscriptionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
