import 'package:mama_kris/features/emp/emp_resume/data/models/resume_model.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_list.dart';

class ResumeListModel extends ResumeList {
  const ResumeListModel({
    required super.resume,
    required super.totalPages,
    required super.currentPage,
  });

  factory ResumeListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> usersJson = json['data'] as List<dynamic>;
    final List<ResumeModel> resume = usersJson
        .map((userJson) => ResumeModel.fromJson(userJson as Map<String, dynamic>))
        .toList();

    return ResumeListModel(
      resume: resume,
      totalPages: json['totalPages']  != null ? json['totalPages']  as int: 0 ,
      currentPage: json['currentPage']  != null ? json['currentPage']  as int: 0 ,

    );
  }


}