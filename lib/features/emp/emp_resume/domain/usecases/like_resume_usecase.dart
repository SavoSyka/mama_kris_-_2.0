import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/core/utils/usecase.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/repositories/resume_repository.dart';

class LikedResumeParams {
  final String userId;
  final bool isFavorited;

  LikedResumeParams({required this.userId, required this.isFavorited});
}

class LikeResumeUsecase extends UsecaseWithParams<bool, LikedResumeParams> {
  final ResumeRepository repository;

  LikeResumeUsecase(this.repository);

  @override
  ResultFuture<bool> call(LikedResumeParams params) async {
    return await repository.updatedFavoriting(
      userId: params.userId,
      isFavorited: params.isFavorited,
    );
  }
}
