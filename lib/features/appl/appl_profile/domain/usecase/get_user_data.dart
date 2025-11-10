import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/repository/user_repository.dart';

class GetUserProfileUseCase extends UsecaseWithoutParams<UserProfileEntity> {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  ResultFuture<UserProfileEntity> call() async {
    return await repository.getUserProfile();
  }
}
