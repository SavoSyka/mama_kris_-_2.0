import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/search_job_entity.dart';

abstract class JobsRepository {
  ResultFuture<List<SearchJobEntity>> getQueryJobs({required String query});
  ResultFuture<List<SearchJobEntity>> searchCombined({required String query});

}
