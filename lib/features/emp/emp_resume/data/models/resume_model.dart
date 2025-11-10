import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_entity.dart';

class ResumeModel extends ResumeEntity {
  const ResumeModel({
    required super.id,
    required super.name,
    required super.role,
    required super.age,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String,
      age: json['age'] as String,
    );
  }




}