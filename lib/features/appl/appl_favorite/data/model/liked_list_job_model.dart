import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_favorite/data/model/liked_job_model.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';

class LikedJobListModel extends LikedListJob {
  LikedJobListModel({
    required super.likedJob,
    required super.currentPage,
    required super.totalPage,
    required super.hasNextPage,
  });

  factory LikedJobListModel.fromJson(DataMap json) {
    // debugPrint("LikedJobListModel -> page ${json}");

    final jobsData = json['data'] as List;
    final cPage = json['page'] is int ? json['page'] as int : 0;
    final tPage = json['total'] is int ? json['total'] as int : 0;
    final pSize = json['pageSize'] is int ? json['pageSize'] as int : 0;

    final totalFetchedData = cPage * pSize;
    final hasNextPage = totalFetchedData < tPage;

    return LikedJobListModel(
      likedJob: jobsData.map((job) => LikedJobModel.fromJson(job)).toList(),
      currentPage: cPage,
      totalPage: tPage,
      hasNextPage: hasNextPage,
    );
  }
}
