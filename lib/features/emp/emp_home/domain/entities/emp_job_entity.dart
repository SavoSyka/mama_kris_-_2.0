import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';

class EmpJobEntity extends Equatable {
  final int jobId;
  final int userId;
  final int contactsId;
  final String title;
  final String description;
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
}