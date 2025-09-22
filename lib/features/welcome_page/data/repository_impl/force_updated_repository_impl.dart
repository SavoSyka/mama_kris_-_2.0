import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/welcome_page/data/data_source/force_update_remote_data_source.dart';
import 'package:mama_kris/features/welcome_page/domain/entity/force_update.dart';
import 'package:mama_kris/features/welcome_page/domain/repository/force_update_repository.dart';

class ForceUpdateRepositoryImpl implements ForceUpdateRepository {
  final ForceUpdateRemoteDataSource remote;

  ForceUpdateRepositoryImpl(this.remote);

  @override
  ResultFuture<ForceUpdate> checkForceUpdate({
    required String versionNumber,
    required String platformType,
  }) async {
    try {
      final result = await remote.checkForceUpdate(
        versionNumber: versionNumber,
        platformType: platformType,
      );

      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
