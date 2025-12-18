import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/email_subscription/domain/repositories/email_subscription_repository.dart';

class UnsubscribeEmailParams {
  final String email;

  const UnsubscribeEmailParams({required this.email});
}

class UnsubscribeEmailUsecase extends UseCase<bool, UnsubscribeEmailParams> {
  final EmailSubscriptionRepository repository;

  UnsubscribeEmailUsecase(this.repository);

  @override
  ResultFuture<bool> call(UnsubscribeEmailParams params) async {
    return await repository.unsubscribeEmail(params.email);
  }
}
