import 'package:equatable/equatable.dart';

class EmployeJobEntity extends Equatable {
  final String profession;
  final String salary;
  final String description;

  const EmployeJobEntity({
    required this.profession,
    required this.salary,
    required this.description,
  });

  @override
  List<Object?> get props => [profession, salary, description];
}