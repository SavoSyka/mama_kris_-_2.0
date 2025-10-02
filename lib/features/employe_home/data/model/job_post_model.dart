import 'package:mama_kris/features/employe_home/domain/entity/job_post_entity.dart';

class JobPostModel extends JobPostEntity {
  const JobPostModel({
    required String profession,
    required String salary,
    required String description,
    required List<String> contacts,
    required bool salaryByAgreement,
  }) : super(
          profession: profession,
          salary: salary,
          description: description,
          contacts: contacts,
          salaryByAgreement: salaryByAgreement,
        );

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      profession: json['profession'] as String,
      salary: json['salary'] as String,
      description: json['description'] as String,
      contacts: List<String>.from(json['contacts'] as List),
      salaryByAgreement: json['salaryByAgreement'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'profession': profession,
        'salary': salary,
        'description': description,
        'contacts': contacts,
        'salaryByAgreement': salaryByAgreement,
      };
}