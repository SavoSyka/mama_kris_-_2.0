// domain/usecases/get_jobs.dart

import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/vacancy_entity.dart';
import 'package:mama_kris/features/applicant_home/domain/repository/jobs_repository.dart';

class SearchCombinedUsecase
    extends UsecaseWithParams<List<VacancyEntity>, String> {
  final JobsRepository repository;

  SearchCombinedUsecase(this.repository);

  @override
  ResultFuture<List<VacancyEntity>> call(String query) async {
    return await repository.searchCombined(query: query);
  }
}
