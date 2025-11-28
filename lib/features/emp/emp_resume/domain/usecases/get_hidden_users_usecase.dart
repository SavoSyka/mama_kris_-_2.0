import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class GetHiddenUsersUsecase extends UsecaseWithoutParams<ResumeList> {
  final ResumeRepository repository;

  GetHiddenUsersUsecase(this.repository);

  @override
  ResultFuture<ResumeList> call() async {
    return await repository.getHiddenUsers();
  }
}
