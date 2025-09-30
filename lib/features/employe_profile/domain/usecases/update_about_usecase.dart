import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/about_update_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class UpdateAboutUsecase extends UsecaseWithParams<void, AboutUpdateEntity> {
  final ProfileRepository repository;

  UpdateAboutUsecase(this.repository);

  @override
  ResultFuture<void> call(AboutUpdateEntity params) async {
    return await repository.updateAbout(params);
  }
}