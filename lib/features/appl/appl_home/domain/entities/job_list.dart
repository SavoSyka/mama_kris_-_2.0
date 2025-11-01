// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_event.dart';

class JobList extends Equatable {
  final List<JobEntity> jobs;
  const JobList({required this.jobs});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
