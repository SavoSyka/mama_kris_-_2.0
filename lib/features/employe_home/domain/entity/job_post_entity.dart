import 'package:equatable/equatable.dart';

class JobPostEntity extends Equatable {
  final String profession;
  final String salary;
  final String description;

  const JobPostEntity({
    required this.profession,
    required this.salary,
    required this.description,
  });

  @override
  List<Object?> get props => [profession, salary, description];
}