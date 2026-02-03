// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable{
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
  final bool isFavorite;
  final bool acceptOrders;

  final List<ApplContactEntity>? contacts;
  final ApplContactEntity? defaultContact;

  const UserProfileEntity( {
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
    this.isFavorite = false,
    this.acceptOrders = true,
  });

  UserProfileEntity copyWith({
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
    dynamic defaultContactId,
    List<String>? specializations,
    List<String>? specializationsNorm,
    String? birthDate,
    dynamic education,
    dynamic about,
    List<ApplWorkExperienceEntity>? workExperience,
    dynamic age,
    List<ApplContactEntity>? contacts,
    ApplContactEntity? defaultContact,
    bool? acceptOrders,
  }) {
    return UserProfileEntity(
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
      workExperience: workExperience ?? this.workExperience,
      age: age ?? this.age,
      contacts: contacts ?? this.contacts,
      defaultContact: defaultContact ?? this.defaultContact,
      acceptOrders: acceptOrders ?? this.acceptOrders,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [userID, name,email, phone,dateTime,signedIn,choice,appleID,role,provider,defaultContact,defaultContactId,specializations, specializationsNorm,birthDate, education,about, workExperience,age, isFavorite, acceptOrders];
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
