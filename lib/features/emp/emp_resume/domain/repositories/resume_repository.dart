import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

abstract class ResumeRepository {
  ResultFuture<ResumeList> fetchUsers({required int page, required bool isFavorite});
}