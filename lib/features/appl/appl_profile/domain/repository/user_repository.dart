import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_entity.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';

abstract class UserRepository {
  ResultFuture<UserProfileEntity> getUserProfile();
}
