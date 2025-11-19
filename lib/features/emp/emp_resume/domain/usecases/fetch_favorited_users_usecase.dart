import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class FetchFavoritedResumeParams {
  final int page;
  final String? searchQuery;

  FetchFavoritedResumeParams({required this.page, this.searchQuery});
}

class FetchFavoritedUsersUsecase extends UsecaseWithParams<ResumeList, FetchFavoritedResumeParams> {
  final ResumeRepository repository;

  FetchFavoritedUsersUsecase(this.repository);

  @override
  ResultFuture<ResumeList> call(FetchFavoritedResumeParams params) async {
    return await repository.fetchFavoritedUsers(page: params.page,  searchQuery: params.searchQuery);
  }
}
