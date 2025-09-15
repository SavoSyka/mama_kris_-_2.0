import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final int price;
  final String status;

  const JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
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

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, description, price, status];
}
