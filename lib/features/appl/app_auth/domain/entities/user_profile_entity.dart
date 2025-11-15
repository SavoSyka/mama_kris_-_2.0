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
