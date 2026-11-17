class FormValidators {
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  static String? loginIdentifier(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (value!.trim().length < 5) return 'يجب ألا يقل المعرف عن 5 خانات';
    return null;
  }

  static String? loginPassword(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (value!.length < 6) return 'كلمة المرور يجب ألا تقل عن 6 محارف';
    return null;
  }

  static String? fullName(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (value!.trim().length < 3) return 'الاسم يجب ألا يقل عن 3 محارف';
    return null;
  }

  static String? academicId(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (!RegExp(r'^\d{9,10}$').hasMatch(value!.trim())) {
      return 'أدخل 9 أو 10 أرقام فقط';
    }
    return null;
  }

  static String? universityEmail(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
        .hasMatch(value!.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    final required = requiredText(value);
    if (required != null) return required;
    if (value!.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'\d').hasMatch(value)) {
      return '8 محارف على الأقل، مع حرف كبير ورقم';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? otp(String? value) {
    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام';
    }
    return null;
  }
}
