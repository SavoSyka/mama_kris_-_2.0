import 'package:flutter/material.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_model.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

class JobListModel extends JobList {
  const JobListModel({required super.jobs});

  factory JobListModel.fromJson(DataMap json) {
    final jobsData = json['data'] as List;
    debugPrint("joblistmodel ${jobsData}");

    return JobListModel(
      jobs: jobsData.map((job) => JobModel.fromJson(job)).toList(),
    );
  }
}
