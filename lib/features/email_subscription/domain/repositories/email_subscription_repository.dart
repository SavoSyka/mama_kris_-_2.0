import 'package:mama_kris/core/utils/typedef.dart';

abstract class EmailSubscriptionRepository {
  ResultFuture<bool> subscribeEmail(String email);
  ResultFuture<bool> unsubscribeEmail(String email);
}
