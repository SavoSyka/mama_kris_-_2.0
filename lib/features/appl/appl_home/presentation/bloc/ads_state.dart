// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/ad_entity.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object> get props => [];
}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsLoaded extends AdsState {
  final AdEntity ad;

  const AdsLoaded({required this.ad});

  @override
  List<Object> get props => [ad];
}

class AdsError extends AdsState {
  final String message;

  const AdsError(this.message);

  @override
  List<Object> get props => [message];
}
