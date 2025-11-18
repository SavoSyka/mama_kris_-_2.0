import 'package:mama_kris/features/appl/applicant_contact/domain/entity/applicant_contact.dart';
import 'package:mama_kris/features/emp/employe_contact/domain/entity/employee_contact.dart';

/// Data model for applicant contact, used for API/JSON serialization.
/// Extends the domain entity to add serialization capabilities.
class EmployeeContactModel extends EmployeeContact {
  const EmployeeContactModel({
    required super.contactId,
    required super.name,
    required super.email,
    required super.phone,
    required super.telegram,
    required super.whatsapp,
    required super.vk,
    required super.userId,
  });

  /// Creates a model from JSON data.
  factory EmployeeContactModel.fromJson(Map<String, dynamic> json) {
    return EmployeeContactModel(
      contactId: json['contactsID'],
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      telegram: json['telegram'] as String,
      whatsapp: json['whatsapp'] as String,
      vk: json['vk'] as String,
      userId: json['userID'],
    );
  }

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'telegram': telegram,
      'vk': vk,
    };
  }

  /// Creates a model from the domain entity.
  factory EmployeeContactModel.fromEntity(EmployeeContact entity) {
    return EmployeeContactModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      telegram: entity.telegram,
      whatsapp: entity.whatsapp,
      vk: entity.vk,
      contactId: entity.contactId,
    );
  }

  /// Converts the model to the domain entity.
  EmployeeContact toEntity() {
    return EmployeeContact(
      contactId: contactId,
      name: name,
      email: email,
      phone: phone,
      telegram: telegram,
      whatsapp: whatsapp,
      vk: vk,
      userId: userId,
    );
  }
}
