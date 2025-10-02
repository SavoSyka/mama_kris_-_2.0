import 'package:mama_kris/features/employe_home/domain/entity/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required String id,
    required String name,
    required String type,
  }) : super(
          id: id,
          name: name,
          type: type,
        );

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
      };
}