import 'package:mama_kris/features/emp/emp_resume/data/models/resume_model.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

class ResumeListModel extends ResumeList {
  const ResumeListModel({
    required super.resume,
    required super.totalPages,
    required super.currentPage,
  });

  factory ResumeListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> usersJson = json['users'] as List<dynamic>;
    final List<ResumeModel> resume = usersJson
        .map((userJson) => ResumeModel.fromJson(userJson as Map<String, dynamic>))
        .toList();

    return ResumeListModel(
      resume: resume,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
    );
  }


}