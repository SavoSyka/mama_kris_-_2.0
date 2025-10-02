import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/employe_home/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_home/domain/repository/job_post_repository.dart';

class GetContactsUsecase extends UsecaseWithoutParams<List<ContactEntity>> {
  final JobPostRepository repository;

  GetContactsUsecase(this.repository);

  @override
  ResultFuture<List<ContactEntity>> call() async {
    return await repository.getContacts();
  }
}