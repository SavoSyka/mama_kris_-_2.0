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
      id: json['userID'] as int, // Safe: API returns int
      name: json['name'] as String? ?? 'Unknown', // Fallback if null
      role: 'role', // TODO: Replace with actual field when available
      age: json['age']?.toString() ?? '' , // Convert int/null to String?
    );
  }
}
