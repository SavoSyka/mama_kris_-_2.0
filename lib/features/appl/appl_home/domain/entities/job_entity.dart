// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final int jobId;
  final int userId;
  final int contactsId;

  final String title;
  final String description;
  final String dateTime;

  final String salary;
  final String status;
  final String? firstPublishedAt;
  const JobEntity({
    required this.jobId,
    required this.userId,
    required this.contactsId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.salary,
    required this.status,
    this.firstPublishedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    jobId,
    userId,
    contactsId,
    title,
    description,
    salary,
    status,
    firstPublishedAt,
  ];
}
