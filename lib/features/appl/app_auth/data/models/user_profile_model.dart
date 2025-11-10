import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';

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
      specializations: json['specializations'],
      specializationsNorm: json['specializationsNorm'],
      birthDate: json['birthDate'],
      education: json['education'],
      about: json['about'],
      workExperience: json['workExperience'],
      age: json['age'],
    );
  }


}
