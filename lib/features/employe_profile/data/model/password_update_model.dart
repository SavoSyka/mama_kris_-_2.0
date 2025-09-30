import 'package:mama_kris/features/employe_profile/domain/entity/password_update_entity.dart';

class PasswordUpdateModel extends PasswordUpdateEntity {
  const PasswordUpdateModel({
    required String oldPassword,
    required String newPassword,
  }) : super(oldPassword: oldPassword, newPassword: newPassword);

  factory PasswordUpdateModel.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateModel(
      oldPassword: json['oldPassword'] as String,
      newPassword: json['newPassword'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}