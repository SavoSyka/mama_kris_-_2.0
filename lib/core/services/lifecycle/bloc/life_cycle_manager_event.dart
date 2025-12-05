part of 'life_cycle_manager_bloc.dart';

sealed class LifeCycleManagerEvent extends Equatable {
  const LifeCycleManagerEvent();

  @override
  List<Object> get props => [];
}

class StartUserSessionEvent extends LifeCycleManagerEvent {
  final String startDate;

  const StartUserSessionEvent({required this.startDate});
}

class EndUserSessionEvent extends LifeCycleManagerEvent {
  final String endDate;
  final int sessionId;

  const EndUserSessionEvent({required this.endDate, required this.sessionId});
}
