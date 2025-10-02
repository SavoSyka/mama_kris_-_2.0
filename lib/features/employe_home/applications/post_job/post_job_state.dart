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

class PostJobData extends PostJobState {
  final String? profession;
  final String? description;
  final List<String>? contacts;
  final String? salary;
  final bool? salaryByAgreement;

  const PostJobData({
    this.profession,
    this.description,
    this.contacts,
    this.salary,
    this.salaryByAgreement,
  });

  PostJobData copyWith({
    String? profession,
    String? description,
    List<String>? contacts,
    String? salary,
    bool? salaryByAgreement,
  }) {
    return PostJobData(
      profession: profession ?? this.profession,
      description: description ?? this.description,
      contacts: contacts ?? this.contacts,
      salary: salary ?? this.salary,
      salaryByAgreement: salaryByAgreement ?? this.salaryByAgreement,
    );
  }
}