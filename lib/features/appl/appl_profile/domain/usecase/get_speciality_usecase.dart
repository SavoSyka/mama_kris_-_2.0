import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_profile/domain/repository/speciality_repository.dart';

class GetSpecialityListUsecase extends UsecaseWithParams<List<String>, String> {
  final SpecialityRepository repository;
  GetSpecialityListUsecase(this.repository);

  @override
  ResultFuture<List<String>> call(String query) {
    return repository.searchSpeciality(query);
  }
}
