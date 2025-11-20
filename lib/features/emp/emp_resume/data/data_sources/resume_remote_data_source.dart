import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/emp/emp_resume/data/models/resume_list_model.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/usecases/get_public_profiles_usecase.dart';

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


    Future<UserProfileModel> getPublicProfiles({
    required String userId,
  });
}
