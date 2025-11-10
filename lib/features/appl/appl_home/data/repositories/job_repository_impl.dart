import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_favorite/domain/entity/liked_list_job.dart';
import 'package:mama_kris/features/appl/appl_home/data/data_sources/job_local_data_source.dart';
import 'package:mama_kris/features/appl/appl_home/data/data_sources/job_remote_data_source.dart';
import 'package:mama_kris/features/appl/appl_home/data/models/job_list_model.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final JobLocalDataSource localDataSource;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  ResultFuture<JobList> fetchJobs({required int page}) async {
    try {
      final value = await remoteDataSource.fetchJobs(page: page);
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<JobList> filterJobs({
    required int page,
    required int perPage,
    String? minSalary,
    String? maxSalary,
    String? title,
    bool? salaryWithAgreemen,
  }) async {
    try {
      final value = await remoteDataSource.filterJobs(
        page: page,
        perPage: perPage,
        title: title,
        maxSalary: maxSalary,
        minSalary: minSalary,
        salaryWithAgreemen: salaryWithAgreemen,
      );
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<JobList> searchJobs(String query) async {
    try {
      final value = await remoteDataSource.searchJobs(query);
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<void> likeJob(int jobId) async {
    try {
      final value = await remoteDataSource.likeJob(jobId);
      await localDataSource.saveLikedJob(jobId);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<void> dislikeJob(int jobId) async {
    try {
      final value = await remoteDataSource.dislikeJob(jobId);
      await localDataSource.saveDislikedJob(jobId);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<LikedListJob> fetchLikedJobs(int page) async {
    try {
      final result = await remoteDataSource.fetchLikedJobs(page);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
