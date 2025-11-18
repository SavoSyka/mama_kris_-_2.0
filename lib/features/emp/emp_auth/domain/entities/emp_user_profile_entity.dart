// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  EmpUserProfileEntity copyWith({
    int? userID,
    String? email,
    String? name,
    String? phone,
    String? dateTime,
    String? signedIn,
    String? choice,
    String? appleID,
    String? role,
    String? provider,
    dynamic? defaultContactId,
    dynamic? specializations,
    dynamic? specializationsNorm,
    dynamic? birthDate,
    dynamic? education,
    dynamic? about,
    dynamic? age,
    List<WorkExperienceEntity>? workExperience,
    List<ContactEntity>? contacts,
    ContactEntity? defaultContact,
  }) {
    return EmpUserProfileEntity(
      userID: userID ?? this.userID,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      dateTime: dateTime ?? this.dateTime,
      signedIn: signedIn ?? this.signedIn,
      choice: choice ?? this.choice,
      appleID: appleID ?? this.appleID,
      role: role ?? this.role,
      provider: provider ?? this.provider,
      defaultContactId: defaultContactId ?? this.defaultContactId,
      specializations: specializations ?? this.specializations,
      specializationsNorm: specializationsNorm ?? this.specializationsNorm,
      birthDate: birthDate ?? this.birthDate,
      education: education ?? this.education,
      about: about ?? this.about,
      age: age ?? this.age,
      workExperience: workExperience ?? this.workExperience,
      contacts: contacts ?? this.contacts,
      defaultContact: defaultContact ?? this.defaultContact,
    );
  }
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

  WorkExperienceEntity copyWith({
    String? role,
    String? company,
    String? description,
    String? startDate,
    String? endDate,
  }) {
    return WorkExperienceEntity(
      role: role ?? this.role,
      company: company ?? this.company,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
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

  ContactEntity copyWith({
    int? contactsID,
    String? name,
    String? telegram,
    String? email,
    String? phone,
    String? whatsapp,
    String? vk,
    String? link,
    int? userID,
  }) {
    return ContactEntity(
      contactsID: contactsID ?? this.contactsID,
      name: name ?? this.name,
      telegram: telegram ?? this.telegram,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      vk: vk ?? this.vk,
      link: link ?? this.link,
      userID: userID ?? this.userID,
    );
  }
}
