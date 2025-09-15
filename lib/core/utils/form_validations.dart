import 'package:mama_kris/core/constants/app_text_contents.dart';

class FormValidations {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return  AppTextContents.nameRequired;
    }
    if (value.trim().length < 2) {
      return  AppTextContents.nameTooShort;

    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return  AppTextContents.emailRequired;

    }
    // Basic email regex
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      return  AppTextContents.emailInvalid;
      
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return  AppTextContents.passwordRequired;

    }
    if (value.length < 6) {
      return  AppTextContents.passwordTooShort;

    }

    return null;
  }
}
