// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SearchJobEntity extends Equatable {
  final String title;
  const SearchJobEntity({required this.title});
  @override
  // TODO: implement props
  List<Object?> get props => [title];
}
