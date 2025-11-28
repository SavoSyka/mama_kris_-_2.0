part of 'hide_resume_bloc.dart';

sealed class HideResumeEvent extends Equatable {
  const HideResumeEvent();

  @override
  List<Object> get props => [];
}

class FetchHiddenUsersEvent extends HideResumeEvent {

  const FetchHiddenUsersEvent();

  @override
  List<Object> get props => [];
}

class AddToHiddenEvent extends HideResumeEvent {
  final String userId;

  const AddToHiddenEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class RemoveFromHiddenEvent extends HideResumeEvent {
  final String userId;

  const RemoveFromHiddenEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
