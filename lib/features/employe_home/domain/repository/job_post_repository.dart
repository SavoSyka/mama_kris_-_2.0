import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/employe_home/domain/entity/contact_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/employe_job_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/profession_entity.dart';

abstract class JobPostRepository {
  ResultVoid postJob(JobPostEntity jobPost);

  ResultFuture<List<EmployeJobEntity>> getAllPostedJob({required String type});

  ResultFuture<List<ProfessionEntity>> getProfessions();

  ResultFuture<List<ContactEntity>> getContacts();
}
