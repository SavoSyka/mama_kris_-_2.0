// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';

class JobList extends Equatable {
  final List<JobEntity> jobs;
  final int totalPage;
  final int currentPage;
  final bool hasNextPage;

  const JobList({
    required this.jobs,
    required this.totalPage,
    required this.currentPage,
    required this.hasNextPage,

  });

  @override
  List<Object?> get props => [jobs, currentPage, totalPage, hasNextPage];

  JobList copyWith({
    List<JobEntity>? jobs,
    int? totalPage,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return JobList(
      jobs: jobs ?? this.jobs,
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
