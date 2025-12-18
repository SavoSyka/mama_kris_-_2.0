import 'package:mama_kris/core/utils/typedef.dart';

abstract class EmailSubscriptionRemoteDataSource {
  ResultFuture<bool> subscribeEmail(String email);
  ResultFuture<bool> unsubscribeEmail(String email);
}
