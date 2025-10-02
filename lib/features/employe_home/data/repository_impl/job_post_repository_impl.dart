import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/employe_home/data/data_source/job_post_remote_data_source.dart';
import 'package:mama_kris/features/employe_home/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_home/data/model/job_post_model.dart';
import 'package:mama_kris/features/employe_home/data/model/profession_model.dart';
import 'package:mama_kris/features/employe_home/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/employe_job_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/profession_entity.dart';
import 'package:mama_kris/features/employe_home/domain/repository/job_post_repository.dart';

class JobPostRepositoryImpl implements JobPostRepository {
  final JobPostRemoteDataSource remoteDataSource;

  JobPostRepositoryImpl(this.remoteDataSource);

  @override
  ResultVoid postJob(JobPostEntity jobPost) async {
    try {
      final model = JobPostModel(
        profession: jobPost.profession,
        salary: jobPost.salary,
        description: jobPost.description,
        contacts: jobPost.contacts,
        salaryByAgreement: jobPost.salaryByAgreement,
      );
      await remoteDataSource.postJob(model);
      return const Right(null);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<EmployeJobEntity>> getAllPostedJob({required String type}) {
    // TODO: implement getAllPostedJob
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<ProfessionEntity>> getProfessions() async {
    try {
      final models = await remoteDataSource.getProfessions();
      final entities = models.map((model) => model as ProfessionEntity).toList();
      return Right(entities);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<ContactEntity>> getContacts() async {
    try {
      final models = await remoteDataSource.getContacts();
      final entities = models.map((model) => model as ContactEntity).toList();
      return Right(entities);
    } on ApiException catch (err) {
      return Left(ServerFailure(err.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}