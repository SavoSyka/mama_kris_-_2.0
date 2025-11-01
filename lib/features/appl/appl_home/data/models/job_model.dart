import 'package:mama_kris/features/appl/appl_home/domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  JobModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.status,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
    };
  }


}