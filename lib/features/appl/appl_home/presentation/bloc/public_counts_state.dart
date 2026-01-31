import 'package:equatable/equatable.dart';
import 'package:mama_kris/features/appl/appl_home/domain/entities/public_counts_entity.dart';

abstract class PublicCountsState extends Equatable {
  const PublicCountsState();

  @override
  List<Object?> get props => [];
}

class PublicCountsInitial extends PublicCountsState {}

class PublicCountsLoading extends PublicCountsState {}

class PublicCountsLoaded extends PublicCountsState {
  final PublicCountsEntity counts;

  const PublicCountsLoaded(this.counts);

  @override
  List<Object?> get props => [counts];
}

class PublicCountsError extends PublicCountsState {
  final String message;

  const PublicCountsError(this.message);

  @override
  List<Object?> get props => [message];
}
