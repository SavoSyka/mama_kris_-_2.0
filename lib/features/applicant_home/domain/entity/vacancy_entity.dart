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
 final int? jobID;
  final int? userID;
  final  String? description;
  final String? dateTime;
 final String? salary;
 final String? status;
 final String? title;
 final int? contactsID;

  const Job({
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
