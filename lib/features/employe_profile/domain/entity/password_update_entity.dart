import 'package:equatable/equatable.dart';

class PasswordUpdateEntity extends Equatable {
  final String oldPassword;
  final String newPassword;

  const PasswordUpdateEntity({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}