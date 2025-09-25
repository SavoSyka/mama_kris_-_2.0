part of 'applicant_home_bloc.dart';

sealed class ApplicantHomeEvent extends Equatable {
  const ApplicantHomeEvent();

  @override
  List<Object> get props => [];
}

class GetAllVacancyEvent extends ApplicantHomeEvent {}

class SearchCombinedEvent extends ApplicantHomeEvent {
  final String query;
  SearchCombinedEvent({required this.query});
}
