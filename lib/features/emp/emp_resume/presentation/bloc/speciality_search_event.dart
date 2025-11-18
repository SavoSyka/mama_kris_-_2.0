import 'package:equatable/equatable.dart';

abstract class SpecialitySearchEvent extends Equatable {
  const SpecialitySearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSpecialitiesEvent extends SpecialitySearchEvent {
  final String query;

  const SearchSpecialitiesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends SpecialitySearchEvent {}