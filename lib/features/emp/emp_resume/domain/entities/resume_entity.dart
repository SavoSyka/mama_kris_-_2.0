import 'package:equatable/equatable.dart';

class ResumeEntity extends Equatable {
  final int id;
  final String name;
  final String role;
  final String age;

  const ResumeEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.age,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, role, age];
}
