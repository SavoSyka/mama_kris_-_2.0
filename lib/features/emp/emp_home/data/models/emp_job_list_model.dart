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

factory EmpJobListModel.fromJson(Map<String, dynamic> json) {
  final jobList = json['data'] as List<dynamic>? ?? [];

  final jobs = jobList
      .map((job) => EmpJobModel.fromJson(job as Map<String, dynamic>))
      .toList();

  final page = json['page'] ?? 1;
  final pageSize = json['pageSize'] ?? jobs.length;
  final total = json['total'] ?? jobs.length;

  return EmpJobListModel(
    jobs: jobs,
    currentPage: page,
    totalPage: (total / pageSize).ceil(),
    hasNextPage: page * pageSize < total,
  );
}

}
