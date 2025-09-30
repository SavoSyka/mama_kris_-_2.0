import 'package:equatable/equatable.dart';

class EmailVerificationEntity extends Equatable {
  final String otp;

  const EmailVerificationEntity({required this.otp});

  @override
  List<Object?> get props => [otp];
}