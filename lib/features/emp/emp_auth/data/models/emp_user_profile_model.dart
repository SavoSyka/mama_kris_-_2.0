import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

class EmpUserProfileModel extends EmpUserProfileEntity {
  const EmpUserProfileModel({
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
    super.age,
    super.workExperience,
    super.contacts,
    super.defaultContact,
  });

  factory EmpUserProfileModel.fromJson(Map<String, dynamic> json) {
    return EmpUserProfileModel(
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
      age: json['age'],

      workExperience: (json['workExperience'] as List?)
          ?.map((e) => WorkExperienceModel.fromJson(e))
          .toList(),
      contacts: (json['contacts'] as List?)
          ?.map((e) => ContactModel.fromJson(e))
          .toList(),
      defaultContact: json['defaultContact'] != null
          ? ContactModel.fromJson(json['defaultContact'])
          : null,
    );
  }
}




class WorkExperienceModel extends WorkExperienceEntity {
  const WorkExperienceModel({
    super.role,
    super.company,
    super.description,
    super.startDate,
    super.endDate,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      role: json['role'] as String?,
      company: json['company'] as String?,
      description: json['description'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}



class ContactModel extends ContactEntity {
  const ContactModel({
    super.contactsID,
    super.name,
    super.telegram,
    super.email,
    super.phone,
    super.whatsapp,
    super.vk,
    super.link,
    super.userID,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactsID: json['contactsID'] as int?,
      name: json['name'] as String?,
      telegram: json['telegram'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      vk: json['vk'] as String?,
      link: json['link'] as String?,
      userID: json['userID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactsID': contactsID,
      'name': name,
      'telegram': telegram,
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'vk': vk,
      'link': link,
      'userID': userID,
    };
  }
}
