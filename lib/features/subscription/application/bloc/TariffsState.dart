// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class Tariffsstate extends Equatable {
  const Tariffsstate();

  @override
  List<Object> get props => [];
}

class TariffsInitialState extends Tariffsstate {}

class TariffsLoadingState extends Tariffsstate {}

class TariffsLoadedState extends Tariffsstate {
  final List<SubscriptionEntity> subscriptions;

  const TariffsLoadedState({required this.subscriptions});

  @override
  List<Object> get props => [subscriptions];
}

class TariffsErrorState extends Tariffsstate {
  final String message;

  const TariffsErrorState(this.message);

  @override
  List<Object> get props => [message];
}
