import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/appl/appl_profile/data/data_source/user_remote_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  const UserRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<UserProfileEntity> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      return Right(user);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
