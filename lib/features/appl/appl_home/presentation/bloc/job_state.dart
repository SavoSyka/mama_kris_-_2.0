import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
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

  const JobLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
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