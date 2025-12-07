import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/data/data_sources/speciality_remote_data_source.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/speciality_repository.dart';

class SpecialityRepositoryImpl implements SpecialityRepository {
  final SpecialityRemoteDataSource remoteDataSource;

  SpecialityRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<SpecialityList> searchSpecialities(String query, int page) async {
    try {
      final specialities = await remoteDataSource.searchSpecialities(query, page);
      return Right(specialities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}