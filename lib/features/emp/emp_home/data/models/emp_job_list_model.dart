import 'package:flutter/widgets.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/emp_job_model.dart';

class EmpJobListModel {
  final List<EmpJobModel> jobs;
  final int currentPage;
  final int totalPage;
  final bool hasNextPage;

  const EmpJobListModel({
    required this.jobs,
    required this.currentPage,
    required this.totalPage,
    required this.hasNextPage,
  });

  factory EmpJobListModel.fromJson(dynamic json) {
    List<dynamic> jobList = [];

    if (json is List) {
      jobList = json;
    } else if (json is Map<String, dynamic> && json['jobs'] != null) {
      jobList = json['jobs'];
    }

    final jobs = jobList
        .map((job) => EmpJobModel.fromJson(job as Map<String, dynamic>))
        .toList();

    // Default pagination if not provided
    return EmpJobListModel(
      jobs: jobs,
      currentPage: json is Map ? (json['currentPage'] ?? 1) : 1,
      totalPage: json is Map ? (json['totalPage'] ?? 1) : 1,
      hasNextPage: jobs.length >= 10, // Assume 10 = pageSize
    );
  }
}
