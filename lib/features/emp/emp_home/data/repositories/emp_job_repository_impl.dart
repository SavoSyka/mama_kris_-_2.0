import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/emp/emp_home/data/data_sources/emp_job_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/create_job_request_model.dart';
import 'package:mama_kris/features/emp/emp_home/data/models/emp_job_list_model.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/create_job_params.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_entity.dart';
import 'package:mama_kris/features/emp/emp_home/domain/entities/emp_job_list_entity.dart';
import 'package:mama_kris/features/emp/emp_home/domain/repositories/emp_job_repository.dart';

class EmpJobRepositoryImpl implements EmpJobRepository {
  final EmpJobRemoteDataSource remoteDataSource;

  EmpJobRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<void> createOrUpdateJob(CreateJobParams params) async {
    try {
      final userID = int.tryParse(sl<AuthLocalDataSource>().getUserId().toString()) ?? 1;

      final request = CreateJobRequestModel(
        userID: userID,
        description: params.description,
        dateTime: DateTime.now().toIso8601String(),
        salary: params.salaryWithAgreement ? 0 : (int.tryParse(params.salary) ?? 0),
        status: 'checking',
        title: params.title,
        contactsID: params.contactsID,
        firstPublishedAt: '3', // default
        jobID: params.jobId, // For updates
      );

      await remoteDataSource.createJob(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<EmpJobListEntity> fetchJobs({required String status, int page = 1}) async {
    try {
      final result = await remoteDataSource.fetchJobs(status: status, page: page);
      final jobs = result.jobs.map((job) => EmpJobEntity(
        jobId: job.jobId,
        userId: job.userId,
        contactsId: job.contactsId,
        title: job.title,
        description: job.description,
        salary: job.salary,
        status: job.status,
        dateTime: job.dateTime,
        contactJobs: job.contactJobs,
      )).toList();
      final jobList = EmpJobListEntity(
        jobs: jobs,
        currentPage: result.currentPage,
        totalPage: result.totalPage,
        hasNextPage: result.hasNextPage,
      );
      return Right(jobList);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}