import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_list_entity.dart';

abstract class FetchEmpJobsState extends Equatable {
  const FetchEmpJobsState();

  @override
  List<Object> get props => [];
}

class FetchEmpJobsInitial extends FetchEmpJobsState {}

class FetchEmpJobsLoading extends FetchEmpJobsState {}

class FetchEmpJobsLoaded extends FetchEmpJobsState {
  final EmpJobListEntity jobList;

  const FetchEmpJobsLoaded(this.jobList);

  @override
  List<Object> get props => [jobList];
}

class FetchEmpJobsError extends FetchEmpJobsState {
  final String message;

  const FetchEmpJobsError(this.message);

  @override
  List<Object> get props => [message];
}