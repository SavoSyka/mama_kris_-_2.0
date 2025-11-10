import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/resume_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource remoteDataSource;

  ResumeRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<ResumeList> fetchUsers({
    required int page,
    required bool isFavorite,
  }) async {
    try {
      final value = await remoteDataSource.fetchUsers(
        page: page,
        isFavorite: isFavorite,
      );
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
