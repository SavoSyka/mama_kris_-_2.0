import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/lifecycle/data/data_source/life_cycle_manager_data_source.dart';
import 'package:mama_kris/core/services/lifecycle/domain/repository/life_cycle_manager_repository.dart';
import 'package:mama_kris/core/utils/typedef.dart';

class LifeCycleManagerRepositoryImpl extends LifeCycleManagerRepository {
  final LifeCycleManagerDataSource remoteDataSource;

  LifeCycleManagerRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<int> userEntered(String startDate) async {
    try {
      final result = await remoteDataSource.userEntered(startDate);
      return  Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<void> userLeft(String endDate, int sessionId) async {
    try {
      final result = await remoteDataSource.userLeft(endDate, sessionId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
