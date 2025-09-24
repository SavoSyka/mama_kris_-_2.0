import 'package:equatable/equatable.dart';

class VacancyEntity extends Equatable {
  final int? jobID;
  final Job? job;

  const VacancyEntity({this.jobID, this.job});

  @override
  // TODO: implement props
  List<Object?> get props => [jobID, job];
}

class Job extends Equatable {
  int? jobID;
  int? userID;
  String? description;
  String? dateTime;
  String? salary;
  String? status;
  String? title;
  int? contactsID;

  Job({
    this.jobID,
    this.userID,
    this.description,
    this.dateTime,
    this.salary,
    this.status,
    this.title,
    this.contactsID,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    jobID,
    userID,
    description,
    dateTime,
    salary,
    status,
    title,
    contactsID,
  ];
}
