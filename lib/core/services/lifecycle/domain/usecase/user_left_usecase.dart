import 'package:mama_kris/core/services/lifecycle/domain/repository/life_cycle_manager_repository.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';

class UserLeftParams {
  final String endDate;
  final int sessionId;
  const UserLeftParams({required this.endDate, required this.sessionId});
}

class UserLeftUsecase extends UseCase<void, UserLeftParams> {
  final LifeCycleManagerRepository repository;

  UserLeftUsecase(this.repository);

  @override
  ResultFuture<void> call(UserLeftParams params) async {
    return await repository.userLeft(params.endDate, params.sessionId);
  }
}
