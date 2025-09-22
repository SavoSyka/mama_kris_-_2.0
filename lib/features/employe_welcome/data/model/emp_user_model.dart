import '../../domain/entities/employe_user.dart';

class EmpUserModel extends EmployeUser {
  EmpUserModel({required super.id, required super.email, required super.name});

  factory EmpUserModel.fromJson(Map<String, dynamic> json) {
    return EmpUserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
