import 'package:mama_kris/features/employe_profile/domain/entity/email_update_entity.dart';

class EmailUpdateModel extends EmailUpdateEntity {
  const EmailUpdateModel({required String email}) : super(email: email);

  factory EmailUpdateModel.fromJson(Map<String, dynamic> json) {
    return EmailUpdateModel(email: json['email'] as String);
  }

  Map<String, dynamic> toJson() => {'email': email};
}