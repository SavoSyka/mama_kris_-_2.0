import 'package:equatable/equatable.dart';

class ContactJobs extends Equatable {
  final int? contactsID;
  final String? name;
  final String? telegram;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? vk;
  final String? link;

  const ContactJobs({
    this.contactsID,
    this.name,
    this.telegram,
    this.email,
    this.phone,
    this.whatsapp,
    this.vk,
    this.link,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    contactsID,
    name,
    telegram,
    email,
    whatsapp,
    phone,
    vk,
    link,
  ];
}
