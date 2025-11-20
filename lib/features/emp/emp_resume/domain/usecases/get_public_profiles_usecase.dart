import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class GetPublicProfilesUsecase extends UsecaseWithParams<UserProfileEntity, String> {
  final ResumeRepository repository;

  GetPublicProfilesUsecase(this.repository);

  @override
  ResultFuture<UserProfileEntity> call(String userId) async {
    return await repository.getPublicProfiles(userId: userId);
  }
}
