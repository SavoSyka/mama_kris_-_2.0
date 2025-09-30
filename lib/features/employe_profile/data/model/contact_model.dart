import 'package:mama_kris/features/employe_profile/domain/entity/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.whatsapp,
    required super.telegram,
    required super.vk,
  });

  Map<String, dynamic> toJson() => {
    'whatsapp': whatsapp,
    'telegram': telegram,
    'vk': vk,
  };
}

class ContactUpdateModel extends ContactUpdateEntity {
  const ContactUpdateModel({required super.contacts});

  Map<String, dynamic> toJson() => {
    'contacts': contacts.map((e) => (e as ContactModel).toJson()).toList(),
  };
}
