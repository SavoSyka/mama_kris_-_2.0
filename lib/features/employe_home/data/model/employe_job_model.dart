import 'package:mama_kris/features/employe_home/domain/entity/employe_job_entity.dart';
import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';

class EmployeJobModel extends EmployeJobEntity {
  const EmployeJobModel({
    required String profession,
    required String salary,
    required String description,
  }) : super(
          profession: profession,
          salary: salary,
          description: description,
        );

  factory EmployeJobModel.fromJson(Map<String, dynamic> json) {
    return EmployeJobModel(
      profession: json['profession'] as String,
      salary: json['salary'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'profession': profession,
        'salary': salary,
        'description': description,
      };
}