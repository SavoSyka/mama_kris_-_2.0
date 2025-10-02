import 'package:equatable/equatable.dart';

class JobPostEntity extends Equatable {
  final String profession;
  final String salary;
  final String description;
  final List<String> contacts;
  final bool salaryByAgreement;

  const JobPostEntity({
    required this.profession,
    required this.salary,
    required this.description,
    required this.contacts,
    required this.salaryByAgreement,
  });

  @override
  List<Object?> get props => [profession, salary, description, contacts, salaryByAgreement];
}