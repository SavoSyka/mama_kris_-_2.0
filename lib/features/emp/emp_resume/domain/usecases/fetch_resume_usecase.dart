import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class FetchResumeParams {
  final int page;
  final bool isFavorite;
  FetchResumeParams({required this.page, required this.isFavorite});
}

class FetchResumeUsecase extends UsecaseWithParams<ResumeList, FetchResumeParams> {
  final ResumeRepository repository;

  FetchResumeUsecase(this.repository);

  @override
  ResultFuture<ResumeList> call(FetchResumeParams params) async {
    return await repository.fetchUsers(page: params.page, isFavorite:  params.isFavorite);
  }
}
