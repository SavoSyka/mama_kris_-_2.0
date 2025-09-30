import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';

class JobPostModel extends JobPostEntity {
  const JobPostModel({
    required String profession,
    required String salary,
    required String description,
  }) : super(
          profession: profession,
          salary: salary,
          description: description,
        );

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
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