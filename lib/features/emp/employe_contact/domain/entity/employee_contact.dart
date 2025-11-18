// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

/// Entity representing an applicant contact.
/// This is a pure domain object without any external dependencies.
class EmployeeContact extends Equatable {
  final int contactId;

  final String name;
  final String telegram;
  final String whatsapp;

  final String email;
  final String vk;
  final int userId;

  final String phone;

  const EmployeeContact({
    required this.contactId,
    required this.name,
    required this.telegram,
    required this.whatsapp,
    required this.email,
    required this.vk,
    required this.phone,
    required this.userId,
  });

  /// Creates a copy of this contact with updated fields.
  EmployeeContact copyWith({
    int? contactId,
    String? name,
    String? telegram,
    String? whatsapp,
    String? email,
    String? vk,
    int? userId,
    String? phone,
  }) {
    return EmployeeContact(
      contactId: contactId ?? this.contactId,
      name: name ?? this.name,
      telegram: telegram ?? this.telegram,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      vk: vk ?? this.vk,
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'EmployeeContact(id: $contactId, name: $name, email: $email, phone: $phone)';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, telegram, whatsapp, vk, email, phone];
}
