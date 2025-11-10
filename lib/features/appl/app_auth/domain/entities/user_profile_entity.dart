class UserProfileEntity {
 final int? userID;
  final String? email;
  final String? name;
  final String? phone;
  final String? dateTime;
  final String? signedIn;
  final String? choice;
 final  String? appleID;
  final String? role;
  final String? provider;
  final dynamic defaultContactId;
  final dynamic specializations;
  final dynamic specializationsNorm;
  final dynamic birthDate;
  final dynamic education;
  final dynamic about;
  final dynamic workExperience;
  final dynamic age;

 const  UserProfileEntity({
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
