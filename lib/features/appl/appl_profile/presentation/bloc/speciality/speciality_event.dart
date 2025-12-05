part of 'speciality_bloc.dart';

abstract class SpecialityEvent {}

class SearchSpecialityEvent extends SpecialityEvent {
  final String query;
  SearchSpecialityEvent(this.query);
}

class AddSpecialityEvent extends SpecialityEvent {
  final String speciality;
  AddSpecialityEvent(this.speciality);
}

class RemoveSpecialityEvent extends SpecialityEvent {
  final String speciality;
  RemoveSpecialityEvent(this.speciality);
}
