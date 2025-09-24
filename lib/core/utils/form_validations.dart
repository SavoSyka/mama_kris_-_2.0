import 'package:mama_kris/core/constants/app_text_contents.dart';

class FormValidations {
  FormValidations._();

  static const int minPasswordLength = 6;
  static const String passwordRequired = 'Password is required';
  static const String otpRequired = 'OTP is required';
  static const String otpTooShort = 'OTP must be 6 characters.';

  static const String passwordTooShort =
      'Password must be at least $minPasswordLength characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String sameAsOldPassword =
      'New password must be different from old password';

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTextContents.nameRequired;
    }
    if (value.trim().length < 2) {
      return AppTextContents.nameTooShort;
    }

    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return otpRequired;
    }
    if (value.trim().length < 6) {
      return otpTooShort;
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTextContents.emailRequired;
    }
    // Basic email regex
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      return AppTextContents.emailInvalid;
    }
    return null;
  }

  // Base validation for common password checks
  static String? _validateBasePassword(String? value) {
    if (value == null || value.isEmpty) {
      return passwordRequired;
    }
    if (value.length < minPasswordLength) {
      return passwordTooShort;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    return _validateBasePassword(value);
  }

  static String? validateNewPassword(String? value, String oldPassword) {
    final baseValidation = _validateBasePassword(value);
    if (baseValidation != null) {
      return baseValidation;
    }
    if (value == oldPassword) {
      return sameAsOldPassword;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    final baseValidation = _validateBasePassword(value);
    if (baseValidation != null) {
      return baseValidation;
    }
    if (value != newPassword) {
      return passwordsDoNotMatch;
    }
    return null;
  }
}
