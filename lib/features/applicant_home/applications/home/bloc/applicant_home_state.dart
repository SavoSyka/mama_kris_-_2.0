part of 'applicant_home_bloc.dart';

sealed class ApplicantHomeState extends Equatable {
  const ApplicantHomeState();
  
  @override
  List<Object> get props => [];
}

final class ApplicantHomeInitial extends ApplicantHomeState {}
