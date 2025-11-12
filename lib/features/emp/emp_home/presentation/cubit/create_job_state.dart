import 'package:equatable/equatable.dart';

abstract class CreateJobState extends Equatable {
  const CreateJobState();

  @override
  List<Object> get props => [];
}

class CreateJobInitial extends CreateJobState {}

class CreateJobLoading extends CreateJobState {}

class CreateJobSuccess extends CreateJobState {}

class CreateJobError extends CreateJobState {
  final String message;

  const CreateJobError(this.message);

  @override
  List<Object> get props => [message];
}