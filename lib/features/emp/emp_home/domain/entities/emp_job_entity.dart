// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';

class EmpJobEntity extends Equatable {
  final int jobId;
  final int userId;
  final int contactsId;
  final String title;
  final String description;
  final bool? salaryWithAgreement;
  final String? links;


  final String salary;
  final String status;
  final String dateTime;
  final ContactJobs? contactJobs;

  const EmpJobEntity({
    required this.jobId,
    required this.userId,
    required this.contactsId,
    required this.title,
    required this.description,
    required this.salary,
    required this.status,
    required this.dateTime,
    this.salaryWithAgreement,
    this.links,

    this.contactJobs,
  });

  @override
  List<Object?> get props => [
    jobId,
    userId,
    contactsId,
    title,
    description,
    salary,
    status,
    dateTime,
    contactJobs,
  ];

  EmpJobEntity copyWith({
    int? jobId,
    int? userId,
    int? contactsId,
    String? title,
    String? description,
    bool? salaryWithAgreement,
    String? links,
    String? salary,
    String? status,
    String? dateTime,
    ContactJobs? contactJobs,
  }) {
    return EmpJobEntity(
      jobId: jobId ?? this.jobId,
      userId: userId ?? this.userId,
      contactsId: contactsId ?? this.contactsId,
      title: title ?? this.title,
      description: description ?? this.description,
      salaryWithAgreement: salaryWithAgreement ?? this.salaryWithAgreement,
      links: links ?? this.links,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
      contactJobs: contactJobs ?? this.contactJobs,
    );
  }
}
