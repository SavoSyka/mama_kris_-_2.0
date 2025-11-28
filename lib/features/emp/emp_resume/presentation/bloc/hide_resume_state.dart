part of 'hide_resume_bloc.dart';

sealed class HideResumeState extends Equatable {
  const HideResumeState();

  @override
  List<Object> get props => [];
}

final class HideResumeInitial extends HideResumeState {}

/// 🔹 Loading state for any hide-related action
class HideResumeLoading extends HideResumeState {}

/// 🔹 Loaded hidden users list
class HiddenUsersLoadedState extends HideResumeState {
  final ResumeList hiddenUsers;

  const HiddenUsersLoadedState({required this.hiddenUsers});

  @override
  List<Object> get props => [hiddenUsers];
}

/// 🔹 Successfully added to hidden list
class AddToHiddenSuccessState extends HideResumeState {}

/// 🔹 Successfully removed from hidden list
class RemoveFromHiddenSuccessState extends HideResumeState {}

/// 🔹 Generic error state
class HideResumeErrorState extends HideResumeState {
  final String message;

  const HideResumeErrorState(this.message);

  @override
  List<Object> get props => [message];
}
