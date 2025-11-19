import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';
import 'package:mama_kris/features/subscription/domain/repository/subscription_repository.dart';

class InitiatePaymentUsecase extends UsecaseWithParams<String?, SubscriptionEntity> {
  final SubscriptionRepository repository;

  InitiatePaymentUsecase(this.repository);

  @override
  ResultFuture<String?> call(SubscriptionEntity params) async {
    return await repository.initiatePayment(params);
  }
}