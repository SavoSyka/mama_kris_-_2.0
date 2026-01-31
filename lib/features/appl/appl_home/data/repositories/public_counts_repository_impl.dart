import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/features/appl/appl_home/data/data_sources/public_counts_remote_data_source.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/public_counts_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/public_counts_repository.dart';

class PublicCountsRepositoryImpl implements PublicCountsRepository {
  final PublicCountsRemoteDataSource remoteDataSource;

  PublicCountsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PublicCountsEntity>> getPublicCounts() async {
    try {
      final result = await remoteDataSource.getPublicCounts();
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
