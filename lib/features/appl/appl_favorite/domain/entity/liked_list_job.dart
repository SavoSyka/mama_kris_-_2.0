// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_job.dart';

class LikedListJob {
  List<LikedJob> likedJob;
  final int totalPage;
  final int currentPage;
  final bool hasNextPage;
  LikedListJob({
    required this.likedJob,
    required this.totalPage,
    required this.currentPage,
    required this.hasNextPage,
  });

  LikedListJob copyWith({
    List<LikedJob>? likedJob,
    int? totalPage,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return LikedListJob(
      likedJob: likedJob ?? this.likedJob,
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
