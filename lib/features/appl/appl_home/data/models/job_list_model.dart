import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_model.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';

class JobListModel extends JobList {
  const JobListModel({
    required super.jobs,
    required super.currentPage,
    required super.totalPage,
    required super.hasNextPage,
  });

  factory JobListModel.fromJson(DataMap json) {
    // debugPrint("joblistmodel -> page");

    final jobsData = json['data'] as List;
    final cPage = json['page'] is int ? json['page'] as int : 0;
    final tPage = json['total'] is int ? json['total'] as int : 0;
    final pSize = json['pageSize'] is int ? json['pageSize'] as int : 0;

    final totalFetchedData = cPage * pSize;
    final hasNextPage = totalFetchedData < tPage;

    return JobListModel(
      jobs: jobsData.map((job) => JobModel.fromJson(job)).toList(),
      currentPage: cPage,
      totalPage: tPage,
      hasNextPage: hasNextPage,
    );
  }
}
