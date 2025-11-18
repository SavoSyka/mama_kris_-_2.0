import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/speciality_repository.dart';

class SearchSpecialityParams {
  final String query;

  SearchSpecialityParams({required this.query});
}

class SearchSpecialityUsecase extends UsecaseWithParams<List<Speciality>, SearchSpecialityParams> {
  final SpecialityRepository repository;

  SearchSpecialityUsecase(this.repository);

  @override
  ResultFuture<List<Speciality>> call(SearchSpecialityParams params) async {
    return await repository.searchSpecialities(params.query);
  }
}