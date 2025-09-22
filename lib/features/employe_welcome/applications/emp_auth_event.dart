abstract class EmpAuthEvent {}

class CheckEmailEvent extends EmpAuthEvent {
  final String email;
  CheckEmailEvent(this.email);
}

class ForgotPasswordEvent extends EmpAuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class ValidateOtpEvent extends EmpAuthEvent {
  final String email;
  final String otp;
  ValidateOtpEvent(this.email, this.otp);
}

class RegisterEvent extends EmpAuthEvent {
  final String email;
  final String name;
  final String password;
  RegisterEvent({
    required this.email,
    required this.name,
    required this.password,
  });
}

class LoginEvent extends EmpAuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class ChangePasswordEvent extends EmpAuthEvent {
  final String password;
  ChangePasswordEvent(this.password);
}
