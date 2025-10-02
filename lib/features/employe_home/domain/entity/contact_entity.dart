import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String name;
  final String type; // e.g., 'telegram', 'whatsapp', 'email', 'phone', 'vk'

  const ContactEntity({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}