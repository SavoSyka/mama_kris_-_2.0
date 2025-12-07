import 'package:mama_kris/core/utils/typedef.dart';

abstract class LifeCycleManagerRepository {
  ResultFuture<int> userEntered(String startDate);
  ResultFuture<void> userLeft(String endDate, int sessionId);
}
