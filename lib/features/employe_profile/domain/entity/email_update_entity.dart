import 'package:equatable/equatable.dart';

class EmailUpdateEntity extends Equatable {
  final String email;

  const EmailUpdateEntity({required this.email});

  @override
  List<Object?> get props => [email];
}