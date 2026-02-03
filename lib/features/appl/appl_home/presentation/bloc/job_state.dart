// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final JobList jobs;

  final bool isLoadingMore;

  const JobLoaded({required this.jobs, required this.isLoadingMore});

  @override
  List<Object> get props => [jobs];

  JobLoaded copyWith({
    JobList? jobs,
    bool? isLoadingMore,
  }) {
    return JobLoaded(
      jobs: jobs ?? this.jobs,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object> get props => [message];
}

class JobActionSuccess extends JobState {
  final String message;

  const JobActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
