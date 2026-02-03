// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/job_list.dart';
import 'package:mama_kris/features/appl/appl_home/domain/repositories/job_repository.dart';

class FilterJobsUsecase
    extends UsecaseWithParams<JobList, FilterJobParams> {
  final JobRepository repository;

  FilterJobsUsecase(this.repository);

  @override
  ResultFuture<JobList> call(FilterJobParams params) async {
    return await repository.filterJobs(
      page: params.page,
      perPage: params.perPage,
      title: params.title,
      maxSalary: params.maxSalary,
      minSalary: params.minSalary,
      salaryWithAgreemen: params.salaryWithAgreement,
    );
  }
}

class FilterJobParams {
  final int page;
  final int perPage;
  final String? minSalary;
  final String? maxSalary;
  final String? title;
  final bool? salaryWithAgreement;

  FilterJobParams({
    required this.page,
    required this.perPage,
    this.minSalary,
    this.maxSalary,
    this.title,
    this.salaryWithAgreement,
  });
}
