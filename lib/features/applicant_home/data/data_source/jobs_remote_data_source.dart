import 'package:mama_kris/features/applicant_home/data/model/search_job_model.dart';
import 'package:mama_kris/features/applicant_welcome/data/model/user_model.dart';

abstract class JobsRemoteDataSource {
  Future<List<SearchJobModel>> queryJobs({required String query});
}
