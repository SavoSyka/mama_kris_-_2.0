import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_entity.dart';

class ResumeList extends Equatable {
  final List<ResumeEntity> resume;
  final int totalPages;
  final int currentPage;

  const ResumeList({
    required this.resume,
    required this.totalPages,
    required this.currentPage,
  });

  ResumeList copyWith({
    List<ResumeEntity>? resume,
    int? totalPages,
    int? currentPage,
  }) {
    return ResumeList(
      resume: resume ?? this.resume,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [resume, totalPages, currentPage];
}
