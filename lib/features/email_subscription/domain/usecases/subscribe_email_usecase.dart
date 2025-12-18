import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/email_subscription/domain/repositories/email_subscription_repository.dart';

class SubscribeEmailParams {
  final String email;

  const SubscribeEmailParams({required this.email});
}

class SubscribeEmailUsecase extends UseCase<bool, SubscribeEmailParams> {
  final EmailSubscriptionRepository repository;

  SubscribeEmailUsecase(this.repository);

  @override
  ResultFuture<bool> call(SubscribeEmailParams params) async {
    return await repository.subscribeEmail(params.email);
  }
}
