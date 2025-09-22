import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/welcome_page/domain/entity/force_update.dart';
import 'package:mama_kris/features/welcome_page/domain/repository/force_update_repository.dart';

class CheckForceUpdateUseCase {
  final ForceUpdateRepository repository;

  CheckForceUpdateUseCase(this.repository);

  ResultFuture<ForceUpdate> call({
    required String versionNumber,
    required String platformType,
  }) {
    return repository.checkForceUpdate(
      versionNumber: versionNumber,
      platformType: platformType,
    );
  }
}
