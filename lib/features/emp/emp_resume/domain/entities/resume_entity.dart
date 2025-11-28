import 'package:equatable/equatable.dart';

class ResumeEntity extends Equatable {
  final int id;
  final String name;
  final List<String>? specializations;
  final String age;

  const ResumeEntity({
    required this.id,
    required this.name,
    required this.specializations,
    required this.age,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, specializations, age];
}
