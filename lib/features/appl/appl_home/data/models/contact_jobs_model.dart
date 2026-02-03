import 'package:mama_kris/features/appl/appl_home/domain/entities/contact_job.dart';

class ContactJobsModel extends ContactJobs {
  const ContactJobsModel({
    super.contactsID,
    super.name,
    super.telegram,
    super.email,
    super.phone,
    super.whatsapp,
    super.vk,
    super.link,
  });

  factory ContactJobsModel.fromJson(Map<String, dynamic> json) {
    // debugPrint(" Contact JOBMODEL  ${json['telegram']} \n\n");
    return ContactJobsModel(
      contactsID: json['contactsID'],
      name: json['name'],
      telegram: json['telegram'],
      email: json['email'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      vk: json['vk'],
      link: json['link'],
    );
  }
}
