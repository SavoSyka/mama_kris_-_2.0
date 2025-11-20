import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

abstract class ResumeRepository {
  ResultFuture<ResumeList> fetchUsers({
    required int page,
    String? searchQuery,
  });

    ResultFuture<ResumeList> fetchFavoritedUsers({
    required int page,
    String? searchQuery,
  });

  ResultFuture<bool> updatedFavoriting({
    required String userId,
    required bool isFavorited,
  });

    ResultFuture<UserProfileEntity> getPublicProfiles({
    required String userId,
  });
}
