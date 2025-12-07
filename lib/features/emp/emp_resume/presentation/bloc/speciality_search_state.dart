// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality.dart';
import 'package:mama_kris/features/emp/emp_resume/domain/entities/speciality_list.dart';

abstract class SpecialitySearchState extends Equatable {
  const SpecialitySearchState();

  @override
  List<Object> get props => [];
}

class SpecialitySearchInitial extends SpecialitySearchState {}

class SpecialitySearchLoading extends SpecialitySearchState {}

class SpecialitySearchLoaded extends SpecialitySearchState {
  final SpecialityList specialities;
  final bool isLoadingMore;

  const SpecialitySearchLoaded({
    required this.specialities,
    required this.isLoadingMore,
  });

  @override
  List<Object> get props => [specialities];

  SpecialitySearchLoaded copyWith({
    SpecialityList? specialities,
    bool? isLoadingMore,
  }) {
    return SpecialitySearchLoaded(
      specialities: specialities ?? this.specialities,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SpecialitySearchError extends SpecialitySearchState {
  final String message;

  const SpecialitySearchError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadedPublicPofileState extends SpecialitySearchState {
  final UserProfileEntity user;

  const LoadedPublicPofileState({required this.user});

  @override
  List<Object> get props => [user];
}

class SearchHistoryLoaded extends SpecialitySearchState {
  final List<String> searchHistory;

  const SearchHistoryLoaded({required this.searchHistory});

  @override
  List<Object> get props => [searchHistory];
}
