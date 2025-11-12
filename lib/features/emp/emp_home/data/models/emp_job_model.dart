import 'package:mama_kris/features/appl/appl_home/data/models/contact_jobs_model.dart';

class EmpJobModel {
  final int jobId;
  final int userId;
  final int contactsId;
  final String title;
  final String description;
  final String salary;
  final String status;
  final String dateTime;
  final ContactJobsModel? contactJobs;

  const EmpJobModel({
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

  factory EmpJobModel.fromJson( json) {
    final contact = json['contacts'] != null
        ? ContactJobsModel.fromJson(json['contacts'])
        : null;
    return EmpJobModel(
      jobId: json['jobID'],
      userId: json['userID'],
      contactsId: json['contactsID'],
      title: json['title'],
      description: json['description'],
      dateTime: json['dateTime'],
      salary: json['salary'].toString(),
      status: json['status'],
      contactJobs: contact,
    );
  }

}