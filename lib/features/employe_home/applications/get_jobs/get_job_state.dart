part of 'get_jobs_bloc.dart';

abstract class GetJobState {
  const GetJobState();
}

class GetJobInitial extends GetJobState {}

class GetJobLoading extends GetJobState {}

class GetJobSuccess extends GetJobState {}

class GetJobError extends GetJobState {
  final String message;

  const GetJobError({required this.message});
}