import 'package:equatable/equatable.dart';

class ProfessionEntity extends Equatable {
  final String id;
  final String name;

  const ProfessionEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}