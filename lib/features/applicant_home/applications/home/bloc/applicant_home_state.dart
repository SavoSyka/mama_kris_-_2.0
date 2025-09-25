part of 'applicant_home_bloc.dart';

sealed class ApplicantHomeState extends Equatable {
  const ApplicantHomeState();

  @override
  List<Object> get props => [];
}

final class ApplicantHomeInitial extends ApplicantHomeState {}

final class ApplicantHomeLoadingState extends ApplicantHomeState {}

final class VacancyLoadedState extends ApplicantHomeState {
  final List<VacancyEntity> vacancy;
  const VacancyLoadedState({required this.vacancy});
}

class ApplicantHomeError extends ApplicantHomeState {
  const ApplicantHomeError({required this.message});

  final String message;
}
