mixin ValidationMixin {
  String? emailValidation(String? email) {
    final validation = RegExp(r'^[a-zA-Z0-9_.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    if (email == null || !validation.hasMatch(email)) {
      return 'البريد الإلكتروني';
    }
    return null;
  }

  String? passwordValidation(String? val) {
    if (val == null || val.trim().length < 8) {
      return 'كلمة المرور الجديدة يجب أن لا تكون أقل من 8 أحرف';
    }
    if (val.length > 18) return 'كلمة المرور يجب أن لاتكون أكثر من 18 حرف';
    return null;
  }

  String? passwordConfValidation(String? val, String password) {
    if (val == null || val.trim().isEmpty || val != password) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  String? nameValidation(String? name) {
    if (name == null || name.trim().length < 5) return 'يرجى ادخال اسمك كاملاً';
    final lettersOnly = RegExp(r'^[\u0600-\u06FFA-Za-z\s]+$').hasMatch(name);
    if (!lettersOnly) return 'لا يمكن أن يحتوي الأسم على رموز أو أرقام';
    return null;
  }

  String? phoneValidation(String? phone) {
    // This is Google Play and Apple Store login account.
    if (phone == '55554444') return null;

    if (phone == null || phone.trim().length < 10) {
      return 'يرجى ادخال رقمك كاملاً';
    }
    if (!phone.startsWith('05')) return '0يجب أن يبدأ رقمك ب 5';

    return null;
  }

  String? licenseValidation(String? facility) {
    if (facility == null || facility.trim().length != 10) {
      return 'ييجب أن يتكون رقم الرخصة من 10 أرقام';
    }
    if (!facility.startsWith('70')) return 'يجب أن يبدأ رقم الرخصة ب 70';
    return null;
  }

  String? registrationValidation(String? val) {
    if (val == null || val.trim().length != 10) {
      return 'ييجب أن يتكون رقم السجل التجاري من 10 أرقام';
    }
    if (!val.startsWith('40')) return 'يجب أن يبدأ رقم السجل التجاري ب 40';
    return null;
  }

  String? userIDValidation(String? val) {
    if (val == null || val.trim().isEmpty) return null;
    if (val.trim().length != 10) {
      return 'ييجب أن يتكون رقم الهوية من 10 أرقام';
    }
    if (!val.startsWith('1')) return 'يجب أن يبدأ رقم الهوية ب 1';
    return null;
  }

  String? requiredValidation(String? val, String name) {
    if (val == null || val.trim().isEmpty) return 'يرجى ادخال $name';
    return null;
  }

  String? requiredSelectValidation(Object? val, String name) {
    if (val == null) return 'يرجى اختيار $name';
    return null;
  }
}
