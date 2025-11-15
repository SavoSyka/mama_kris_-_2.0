import 'package:mama_kris/core/utils/typedef.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    super.userID,
    super.email,
    super.name,
    super.phone,
    super.dateTime,
    super.signedIn,
    super.choice,
    super.appleID,
    super.role,
    super.provider,
    super.defaultContactId,
    super.specializations,
    super.specializationsNorm,
    super.birthDate,
    super.education,
    super.about,
    super.workExperience,
    super.age,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final workExperience = json['workExperience'] != null
        ? json['workExperience'] as List
        : [];

    final wExp = workExperience
        .map((experience) => WorkExperienceModel.fromJson(experience))
        .toList();

    final specializations =
        (json['specializations'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final specializationsNorm =
        (json['specializationsNorm'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return UserProfileModel(
      userID: json['userID'] as int?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      dateTime: json['dateTime'] as String?,
      signedIn: json['signedIn'] as String?,
      choice: json['choice'] as String?,
      appleID: json['appleID'] as String?,
      role: json['role'] as String?,
      provider: json['provider'] as String?,
      defaultContactId: json['defaultContactId'],
      specializations: specializations,
      specializationsNorm: specializationsNorm,
      birthDate: json['birthDate'],
      education: json['education'],
      about: json['about'],
      workExperience: wExp,
      age: json['age'],
    );
  }
}

class WorkExperienceModel extends ApplWorkExperienceEntity {
  const WorkExperienceModel({
    super.position,
    super.company,
    super.location,

    super.description,
    super.startDate,
    super.endDate,
    super.isPresent,
  });

  factory WorkExperienceModel.fromJson(DataMap json) {
    return WorkExperienceModel(
      position: json['position'],
      company: json['company'],
      location: json['location'],

      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      isPresent: json['isPresent'] ?? false,
    );
  }
}
