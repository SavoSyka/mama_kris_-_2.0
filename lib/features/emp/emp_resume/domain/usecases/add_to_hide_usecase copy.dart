import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class AddToHideParams {
  final String userId;
  AddToHideParams({required this.userId});
}

class AddToHideUsecase extends UsecaseWithParams<bool, AddToHideParams> {
  final ResumeRepository repository;

  AddToHideUsecase(this.repository);

  @override
  ResultFuture<bool> call(AddToHideParams params) async {
    return await repository.addToHide(userId: params.userId);
  }
}
