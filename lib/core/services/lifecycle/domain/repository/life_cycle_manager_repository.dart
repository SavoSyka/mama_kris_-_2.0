import 'package:mama_kris/core/utils/typedef.dart';

abstract class LifeCycleManagerRepository {
  ResultFuture<void> userEntered(String startDate);
  ResultFuture<void> userLeft(String endDate, int sessionId);
}
