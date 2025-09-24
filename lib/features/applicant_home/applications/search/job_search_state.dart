import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';

abstract class JobSearchState extends Equatable {}

class JobsInitial extends JobSearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class JobsLoading extends JobSearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class JobsLoaded extends JobSearchState {
  final List<SearchJobEntity> jobs;
  JobsLoaded(this.jobs);

  @override
  // TODO: implement props
  List<Object?> get props => [jobs];
}

class JobsError extends JobSearchState {
  final String message;
  JobsError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
