import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/welcome_page/domain/entity/force_update.dart';

abstract class ForceUpdateRepository {
  ResultFuture<ForceUpdate> checkForceUpdate({
    required String versionNumber,
    required String platformType,
  });
}
