import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/appl_profile/data/data_source/speciality_remote_data_source.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/repository/speciality_repository.dart';
class SpecialityRepositoryImpl extends SpecialityRepository {
  final SpecialityRemoteDataSource remoteDataSource;

  SpecialityRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<List<String>> searchSpeciality(String query) async {
    try {
      final result = await remoteDataSource.searchSpeciality(query);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

