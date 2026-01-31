import 'package:equatable/equatable.dart';

abstract class PublicCountsEvent extends Equatable {
  const PublicCountsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPublicCountsEvent extends PublicCountsEvent {}
