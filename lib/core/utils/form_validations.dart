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
      return AppTextContents.emailRequired;
    }
    // Simple email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppTextContents.emailInvalid;
    }
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

  // ------------------- CONTACTS -------------------
  /// Validates contact form fields.
  /// - [name] is required (e.g., "Telegram", "VK", "WhatsApp")
  /// - [link] or [phone] is optional but validated if provided.
  static String? validateContactName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Введите название контакта (например, Telegram, VK).';
    }
    if (name.trim().length < 2) {
      return 'Название контакта слишком короткое.';
    }
    return null;
  }

  static String? validateContactLink(String? value, {String? platform}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final trimmed = value.trim();

    // 1. Allow phone numbers (international format)
    final phonePattern = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (phonePattern.hasMatch(trimmed.replaceAll(RegExp(r'[-\s()]'), ''))) {
      return null; // Valid phone
    }

    // 2. Allow usernames (with or without @)
    final usernamePattern = RegExp(r'^@?[\w\.\d_]{3,}$');
    if (usernamePattern.hasMatch(trimmed.replaceAll('@', ''))) {
      return null; // Valid username
    }

    // 3. Allow short app links: t.me/, wa.me/, vk.me/, etc.
    final shortLinkPattern = RegExp(
      r'^(t\.me|wa\.me|vk\.me|m\.me|telegram\.me|whatsapp\.com)\/[\w\d._-]+',
      caseSensitive: false,
    );
    if (shortLinkPattern.hasMatch(trimmed)) {
      return null;
    }

    // 4. Allow full URLs (http/https)

    // 5. Platform-specific hints
    final hint = platform != null
        ? 'Enter a valid $platform username, link, or phone'
        : 'Enter a valid link, username, or phone';

    return hint;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional

    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Введите корректный номер телефона.';
    }
    return null;
  }

  // ------------------- JOB CREATION -------------------
  static String? validateJobTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Название вакансии обязательно.';
    }
    if (value.trim().length < 3) {
      return 'Название вакансии должно содержать не менее 3 символов.';
    }
    if (value.trim().length > 100) {
      return 'Название вакансии не должно превышать 100 символов.';
    }
    return null;
  }

  static String? validateJobDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Описание вакансии обязательно.';
    }
    if (value.trim().length < 10) {
      return 'Описание вакансии должно содержать не менее 10 символов.';
    }
    if (value.trim().length > 2000) {
      return 'Описание вакансии не должно превышать 2000 символов.';
    }
    return null;
  }

  static String? validateSalary(String? value, bool salaryWithAgreement) {
    if (salaryWithAgreement) {
      return null; // No validation needed if agreement is checked
    }
    if (value == null || value.trim().isEmpty) {
      return 'Зарплата обязательна, если не выбрана "по договоренности".';
    }
    final salary = double.tryParse(value.trim());
    if (salary == null) {
      return 'Зарплата должна быть числом.';
    }
    if (salary <= 0) {
      return 'Зарплата должна быть положительной.';
    }
    return null;
  }
}
