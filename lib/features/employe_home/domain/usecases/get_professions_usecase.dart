import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_home/domain/entity/profession_entity.dart';
import 'package:mama_kris/features/employe_home/domain/repository/job_post_repository.dart';

class GetProfessionsUsecase extends UsecaseWithoutParams<List<ProfessionEntity>> {
  final JobPostRepository repository;

  GetProfessionsUsecase(this.repository);

  @override
  ResultFuture<List<ProfessionEntity>> call() async {
    return await repository.getProfessions();
  }
}