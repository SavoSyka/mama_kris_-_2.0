import 'package:mama_kris/features/emp/emp_resume/data/models/resume_list_model.dart';

abstract class ResumeRemoteDataSource {
  Future<ResumeListModel> fetchUsers({required int page, String? searchQuery});
  Future<ResumeListModel> fetchFavoritedUsers({
    required int page,
    String? searchQuery,
  });

  Future<bool> updatedFavoriting({
    required String userId,
    required bool isFavorited,
  });
}
