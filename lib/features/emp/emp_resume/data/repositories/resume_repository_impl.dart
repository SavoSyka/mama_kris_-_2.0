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
    String? searchQuery,
  }) async {
    try {
      final value = await remoteDataSource.fetchUsers(
        page: page,
        searchQuery:searchQuery
      );
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> updatedFavoriting({
    required String userId,
    required bool isFavorited,
  }) async {
    try {
      final value = await remoteDataSource.updatedFavoriting(
        userId: userId,
        isFavorited: isFavorited,
      );
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  ResultFuture<ResumeList> fetchFavoritedUsers({required int page, String? searchQuery}) 
   async {
    try {
      final value = await remoteDataSource.fetchUsers(
        page: page,
        searchQuery:searchQuery
      );
      return Right(value);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
