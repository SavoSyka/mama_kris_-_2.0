part of 'post_job_bloc.dart';

abstract class PostJobEvent {
  const PostJobEvent();
}

class PostJobSubmitEvent extends PostJobEvent {
  final String profession;
  final String salary;
  final String description;

  const PostJobSubmitEvent({
    required this.profession,
    required this.salary,
    required this.description,
  });
}