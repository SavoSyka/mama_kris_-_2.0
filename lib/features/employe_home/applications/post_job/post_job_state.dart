part of 'post_job_bloc.dart';

abstract class PostJobState {
  const PostJobState();
}

class PostJobInitial extends PostJobState {}

class PostJobLoading extends PostJobState {}

class PostJobSuccess extends PostJobState {}

class PostJobError extends PostJobState {
  final String message;

  const PostJobError({required this.message});
}