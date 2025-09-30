import 'package:mama_kris/features/employe_profile/domain/entity/email_verification_entity.dart';

class EmailVerificationModel extends EmailVerificationEntity {
  const EmailVerificationModel({required String otp}) : super(otp: otp);

  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) {
    return EmailVerificationModel(otp: json['otp'] as String);
  }

  Map<String, dynamic> toJson() => {'otp': otp};
}