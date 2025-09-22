abstract class AuthEvent {}

class CheckEmailEvent extends AuthEvent {
  final String email;
  CheckEmailEvent(this.email);
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class ValidateOtpEvent extends AuthEvent {
  final String email;
  final String otp;
  ValidateOtpEvent(this.email, this.otp);
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;
  RegisterEvent({
    required this.email,
    required this.name,
    required this.password,
  });
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class ChangePasswordEvent extends AuthEvent {
  final String password;
  ChangePasswordEvent(this.password);
}
