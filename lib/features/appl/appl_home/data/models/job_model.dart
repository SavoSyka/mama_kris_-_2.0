import 'package:flutter/cupertino.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  const JobModel({
    required super.jobId,
    required super.userId,
    required super.contactsId,

    required super.title,
    required super.description,
    required super.salary,
    required super.status,
    super.firstPublishedAt,
    required super.dateTime,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    debugPrint("\n\nJobse $json");
    return JobModel(
      jobId: json['jobID'],
      userId: json['userID'],
      contactsId: json['contactsID'],

      title: json['title'],
      description: json['description'],
      dateTime: json['dateTime'],

      salary: json['salary'],
      status: json['status'],
    );
  }
}
