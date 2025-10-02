import 'package:mama_kris/features/employe_home/data/model/contact_model.dart';
import 'package:mama_kris/features/employe_home/data/model/employe_job_model.dart';
import 'package:mama_kris/features/employe_home/data/model/job_post_model.dart';
import 'package:mama_kris/features/employe_home/data/model/profession_model.dart';

abstract class JobPostRemoteDataSource {
  Future<void> postJob(JobPostModel jobPost);
  Future<List<EmployeJobModel>> getAllPostedJob({required String type});
  Future<List<ProfessionModel>> getProfessions();
  Future<List<ContactModel>> getContacts();

}