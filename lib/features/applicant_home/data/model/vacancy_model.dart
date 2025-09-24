import 'package:hive/hive.dart';
import 'package:mama_kris/core/constants/hive_constants.dart';
import 'package:mama_kris/features/applicant_home/domain/entity/vacancy_entity.dart';
part 'vacancy_model.g.dart';

@HiveType(typeId: HiveConstants.vacancyBoxId)
class VacancyModel extends VacancyEntity {
  @HiveField(0)
  final int? jobID;

  @HiveField(1)
  final JobModel? job;

  const VacancyModel({required this.jobID, required this.job}) : super(jobID: jobID, job: job);

  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    return VacancyModel(
      jobID: json['jobID'] as int?,
      job: json['job'] != null ? JobModel.fromJson(json['job'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'jobID': jobID,
        'job': job?.toJson(),
      };
}

@HiveType(typeId: HiveConstants.jobBoxId)
class JobModel extends Job {
  @HiveField(0)
  final int? jobID;

  @HiveField(1)
  final int? userID;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? dateTime;

  @HiveField(4)
  final String? salary;

  @HiveField(5)
  final String? status;

  @HiveField(6)
  final String? title;

  @HiveField(7)
  final int? contactsID;

  const JobModel({
    this.jobID,
    this.userID,
    this.description,
    this.dateTime,
    this.salary,
    this.status,
    this.title,
    this.contactsID,
  }) : super(
          jobID: jobID,
          userID: userID,
          description: description,
          dateTime: dateTime,
          salary: salary,
          status: status,
          title: title,
          contactsID: contactsID,
        );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobID: json['jobID'] as int?,
      userID: json['userID'] as int?,
      description: json['description'] as String?,
      dateTime: json['dateTime'] as String?,
      salary: json['salary'] as String?,
      status: json['status'] as String?,
      title: json['title'] as String?,
      contactsID: json['contactsID'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'jobID': jobID,
        'userID': userID,
        'description': description,
        'dateTime': dateTime,
        'salary': salary,
        'status': status,
        'title': title,
        'contactsID': contactsID,
      };
}