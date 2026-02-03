import 'package:mama_kris/core/services/lifecycle/domain/repository/life_cycle_manager_repository.dart';
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';

class UserEnteredParams {
  final String startDate;

  const UserEnteredParams({required this.startDate});
}

class UserEnteredUsecase extends UseCase<int, UserEnteredParams> {
  final LifeCycleManagerRepository repository;

  UserEnteredUsecase(this.repository);

  @override
  ResultFuture<int> call(UserEnteredParams params) async {
    return await repository.userEntered(params.startDate);
  }
}
