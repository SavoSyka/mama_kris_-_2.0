import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';
import 'package:mama_kris/features/subscription/domain/repository/subscription_repository.dart';

class GetTariffsUsecase extends UsecaseWithoutParams<List<SubscriptionEntity>> {
  final SubscriptionRepository repository;

  GetTariffsUsecase(this.repository);

  @override
  ResultFuture<List<SubscriptionEntity>> call() async {
    return await repository.getTariffs();
  }
}
