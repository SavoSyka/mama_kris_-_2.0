part of 'life_cycle_manager_bloc.dart';

sealed class LifeCycleManagerState extends Equatable {
  const LifeCycleManagerState();

  @override
  List<Object> get props => [];
}

class LifeCycleManagerInitial extends LifeCycleManagerState {}

class LifeCycleManagerLoadingState extends LifeCycleManagerState {}

class LifeCycleManagerStartedState extends LifeCycleManagerState {
  final int sessionId;
  const LifeCycleManagerStartedState({required this.sessionId});
}

class LifeCycleManagerEndedState extends LifeCycleManagerState {
  const LifeCycleManagerEndedState();
}

class LifeCycleManagerErrorState extends LifeCycleManagerState {}
