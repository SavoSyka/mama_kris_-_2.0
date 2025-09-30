import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_profile/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_profile/domain/repository/profile_repository.dart';

class UpdateContactsUsecase extends UsecaseWithParams<void, ContactEntity> {
  final ProfileRepository repository;

  UpdateContactsUsecase(this.repository);

  @override
  ResultFuture<void> call(ContactEntity params) async {
    return await repository.updateContacts(params);
  }
}