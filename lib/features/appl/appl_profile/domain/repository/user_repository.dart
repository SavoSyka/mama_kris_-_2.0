import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  ResultFuture<UserProfileEntity> getUserProfile();
}
