import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String whatsapp;
  final String telegram;
  final String vk;

  const ContactEntity({
    required this.telegram,
    required this.whatsapp,
    required this.vk,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [whatsapp, telegram, vk];
}

class ContactUpdateEntity extends Equatable {
  final List<ContactEntity> contacts;

  const ContactUpdateEntity({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}
