import 'package:equatable/equatable.dart';

class AboutUpdateEntity extends Equatable {
  final String description;

  const AboutUpdateEntity({required this.description});

  @override
  List<Object?> get props => [description];
}