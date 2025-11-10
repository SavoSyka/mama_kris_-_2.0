import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class FetchJobsEvent extends JobEvent {}

class SearchJobsEvent extends JobEvent {
  final String query;

  const SearchJobsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LikeJobEvent extends JobEvent {
  final int jobId;

  const LikeJobEvent(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class DislikeJobEvent extends JobEvent {
  final int jobId;

  const DislikeJobEvent(this.jobId);

  @override
  List<Object> get props => [jobId];
}

class LoadNextJobsPageEvent extends JobEvent {
  final int nextPage;
  const LoadNextJobsPageEvent(this.nextPage);

  @override
  List<Object> get props => [nextPage];
}

class FilterJobEvent extends JobEvent {
  final int page;
  final int perPage;
  final String? title;

  final String? minSalary;
  final String? maxSalary;
  final bool? salaryWithAgreement;

  const FilterJobEvent({
    required this.page,
    required this.perPage,
    this.title,

    this.maxSalary,
    this.minSalary,
    this.salaryWithAgreement,
  });

  @override
  List<Object> get props => [page, perPage];
}
