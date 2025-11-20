// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';

import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

abstract class ResumeState extends Equatable {
  const ResumeState();

  @override
  List<Object> get props => [];
}

class ResumeInitialState extends ResumeState {}

class ResumeLoadingState extends ResumeState {}

class ResumeLoadedState extends ResumeState {
  final ResumeList users;

  final bool isLoadingMore;

  const ResumeLoadedState({required this.users, required this.isLoadingMore});

  @override
  List<Object> get props => [users];

  ResumeLoadedState copyWith({ResumeList? users, bool? isLoadingMore}) {
    return ResumeLoadedState(
      users: users ?? this.users,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ResumeErrorState extends ResumeState {
  final String message;

  const ResumeErrorState(this.message);

  @override
  List<Object> get props => [message];
}

