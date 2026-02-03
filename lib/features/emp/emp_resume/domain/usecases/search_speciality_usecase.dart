import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/speciality_repository.dart';

class SearchSpecialityParams {
  final String query;
  final int page;
  SearchSpecialityParams({required this.query, required this.page});
}

class SearchSpecialityUsecase
    extends UsecaseWithParams<SpecialityList, SearchSpecialityParams> {
  final SpecialityRepository repository;

  SearchSpecialityUsecase(this.repository);

  @override
  ResultFuture<SpecialityList> call(SearchSpecialityParams params) async {
    return await repository.searchSpecialities(params.query, params.page);
  }
}
