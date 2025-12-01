import 'package:mama_kris/features/emp/emp_resume/domain/entities/resume_entity.dart';

class ResumeModel extends ResumeEntity {
  const ResumeModel({
    required super.id,
    required super.name,
    required super.specializations,
    required super.age,
    required super.isFavorite,
    required super.isHidden,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    final specialization = json['specializations'] as List<dynamic>?;
    final specializationNames =
        specialization?.map((e) => e as String).toList() ?? [];
    return ResumeModel(
      id: json['userID'] as int,
      name: json['name'] as String? ?? 'Unknown',
      specializations: specializationNames,
      age: json['age']?.toString() ?? '',
      isFavorite: json['isFavorite'] ?? true,
      isHidden: json['isHidden'] ?? false,
    );
  }
}
