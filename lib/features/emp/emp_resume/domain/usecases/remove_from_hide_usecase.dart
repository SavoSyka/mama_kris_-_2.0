import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class RemoveFromHideParams {
  final String userId;
  RemoveFromHideParams({required this.userId});
}

class RemoveFromHideUsecase
    extends UsecaseWithParams<bool, RemoveFromHideParams> {
  final ResumeRepository repository;

  RemoveFromHideUsecase(this.repository);

  @override
  ResultFuture<bool> call(RemoveFromHideParams params) async {
    return await repository.removeFromHide(userId: params.userId);
  }
}
