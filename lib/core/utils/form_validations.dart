import 'package:mama_kris/core/constants/app_text_contents.dart';

class FormValidations {
  FormValidations._();

  static const int _minPasswordLength = 6;
  static const String _passwordRequired = 'Требуется пароль.';
  static const String _otpRequired = 'Требуется одноразовый пароль.';
  static const String _otpTooShort =
      'Одноразовый пароль должен состоять из 6 символов..';

  static const String passwordTooShort =
      "Пароль должен содержать не менее $_minPasswordLength символов";
  static const String passwordsDoNotMatch = 'Пароли не совпадают';
  static const String sameAsOldPassword =
      'Новый пароль должен отличаться от старого пароля.';

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
      return _otpRequired;
    }
    if (value.trim().length < 6) {
      return _otpTooShort;
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'AppTextContents.emailRequired';
    }
    // Basic email regex
    // if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
    //   return "AppTextContents.emailInvalid;";
    // }
    return null;
  }

  // Base validation for common password checks
  static String? _validateBasePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _passwordRequired;
    }
    if (value.length < _minPasswordLength) {
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
