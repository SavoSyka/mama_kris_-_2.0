import 'package:mama_kris/features/employe_profile/domain/entity/about_update_entity.dart';

class AboutUpdateModel extends AboutUpdateEntity {
  const AboutUpdateModel({required String description})
      : super(description: description);

  factory AboutUpdateModel.fromJson(Map<String, dynamic> json) {
    return AboutUpdateModel(description: json['description'] as String);
  }

  Map<String, dynamic> toJson() => {'description': description};
}