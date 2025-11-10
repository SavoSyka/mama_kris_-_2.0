import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/subscription/domain/entity/subscription_entity.dart';

abstract class SubscriptionRepository {
  ResultFuture<List<SubscriptionEntity>> getTariffs();
}
