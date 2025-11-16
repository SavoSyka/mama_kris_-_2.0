import 'package:equatable/equatable.dart';

class UserProfileEntity {
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
  final List<String>? specializations;
  final List<String>? specializationsNorm;
  final String? birthDate;
  final dynamic education;
  final dynamic about;
  final List<ApplWorkExperienceEntity>? workExperience;
  final dynamic age;

  final List<ApplContactEntity>? contacts;
  final ApplContactEntity? defaultContact;

  const UserProfileEntity({
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
    this.workExperience,
    this.age,
    this.contacts,
    this.defaultContact,
  });
}

class ApplWorkExperienceEntity {
  final String? position;
  final String? company;
  final String? location;
  final String? startDate;
  final String? endDate;
  final String? description;
  final bool isPresent;

  const ApplWorkExperienceEntity({
    this.position,
    this.company,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    this.isPresent = false,
  });

  ApplWorkExperienceEntity copyWith({
    String? position,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    bool? isPresent,
  }) {
    return ApplWorkExperienceEntity(
      position: position ?? this.position,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}

class Eduaction extends Equatable {
  final String endDate;
  final String program;
  final String startDate;

  final String organization;

  const Eduaction({
    required this.endDate,
    required this.program,
    required this.startDate,
    required this.organization,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [endDate, program, startDate, organization];
}

class ApplContactEntity extends Equatable {
  final int? contactsID;
  final String? name;
  final String? telegram;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? vk;
  final String? link;
  final int? userID;

  const ApplContactEntity({
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
