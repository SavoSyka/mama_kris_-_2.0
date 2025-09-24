import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_home/data/data_source/jobs_remote_data_source.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';
import 'package:mama_kris/features/applicant_home/domain/repository/jobs_repository.dart';
import 'package:mama_kris/features/applicant_welcome/data/data_source/auth_remote_data_source.dart';
import 'package:mama_kris/features/applicant_welcome/domain/entities/user.dart';
import 'package:mama_kris/features/applicant_welcome/domain/repository/auth_repository.dart';

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<List<SearchJobEntity>> getQueryJobs({
    required String query,
  }) async {
    try {
      final result = await remoteDataSource.queryJobs(query: query);
      return Right(result);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<SearchJobEntity>> searchCombined({required String query}) {
    // TODO: implement searchCombined
    throw UnimplementedError();
  }
}
