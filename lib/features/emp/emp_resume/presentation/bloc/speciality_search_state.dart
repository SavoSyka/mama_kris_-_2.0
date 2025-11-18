import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';

abstract class SpecialitySearchState extends Equatable {
  const SpecialitySearchState();

  @override
  List<Object> get props => [];
}

class SpecialitySearchInitial extends SpecialitySearchState {}

class SpecialitySearchLoading extends SpecialitySearchState {}

class SpecialitySearchLoaded extends SpecialitySearchState {
  final List<Speciality> specialities;

  const SpecialitySearchLoaded({required this.specialities});

  @override
  List<Object> get props => [specialities];
}

class SpecialitySearchError extends SpecialitySearchState {
  final String message;

  const SpecialitySearchError({required this.message});

  @override
  List<Object> get props => [message];
}