import 'package:equatable/equatable.dart';

class EmpUserProfileEntity {
  final int? userID;
  final String? email;
  final String? name;
  final String? phone;
  final String? dateTime;
  final String? signedIn;
  final String? choice;
  final String? appleID;
  final String? role;
  final String? provider;
  final dynamic defaultContactId;
  final dynamic specializations;
  final dynamic specializationsNorm;
  final dynamic birthDate;
  final dynamic education;
  final dynamic about;
  final dynamic age;

  final List<WorkExperienceEntity>? workExperience;
  final List<ContactEntity>? contacts;
  final ContactEntity? defaultContact;

  const EmpUserProfileEntity({
    this.userID,
    this.email,
    this.name,
    this.phone,
    this.dateTime,
    this.signedIn,
    this.choice,
    this.appleID,
    this.role,
    this.provider,
    this.defaultContactId,
    this.specializations,
    this.specializationsNorm,
    this.birthDate,
    this.education,
    this.about,
    this.age,
    this.workExperience,
    this.contacts,
    this.defaultContact,
  });
}

class WorkExperienceEntity extends Equatable {
  final String? role;
  final String? company;
  final String? description;
  final String? startDate;
  final String? endDate;

  const WorkExperienceEntity({
    this.role,
    this.company,
    this.description,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [role, company, description, startDate, endDate];
}

class ContactEntity extends Equatable {
  final int? contactsID;
  final String? name;
  final String? telegram;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? vk;
  final String? link;
  final int? userID;

  const ContactEntity({
    this.contactsID,
    this.name,
    this.telegram,
    this.email,
    this.phone,
    this.whatsapp,
    this.vk,
    this.link,
    this.userID,
  });

  @override
  List<Object?> get props => [
    contactsID,
    name,
    telegram,
    email,
    phone,
    whatsapp,
    vk,
    link,
    userID,
  ];
}
