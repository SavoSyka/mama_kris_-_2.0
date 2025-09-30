part of 'get_jobs_bloc.dart';

abstract class GetJobEvent {
  const GetJobEvent();
}

class GetEmployeJobEvent extends GetJobEvent {
  final String type;

  const GetEmployeJobEvent({required this.type});
}
