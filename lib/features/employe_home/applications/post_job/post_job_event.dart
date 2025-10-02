part of 'post_job_bloc.dart';

abstract class PostJobEvent {
  const PostJobEvent();
}

class PostJobUpdateProfessionEvent extends PostJobEvent {
  final String profession;

  const PostJobUpdateProfessionEvent({required this.profession});
}

class PostJobUpdateDescriptionEvent extends PostJobEvent {
  final String description;

  const PostJobUpdateDescriptionEvent({required this.description});
}

class PostJobUpdateContactsEvent extends PostJobEvent {
  final List<String> contacts;

  const PostJobUpdateContactsEvent({required this.contacts});
}

class PostJobUpdateSalaryEvent extends PostJobEvent {
  final String salary;
  final bool salaryByAgreement;

  const PostJobUpdateSalaryEvent({
    required this.salary,
    required this.salaryByAgreement,
  });
}

class PostJobSubmitEvent extends PostJobEvent {
  const PostJobSubmitEvent();
}