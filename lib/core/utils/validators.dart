// lib/core/utils/validators.dart

class Validators {
  /// Email validasyonu
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email boş olamaz';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email girin';
    }
    return null;
  }

  /// Telefon validasyonu
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası boş olamaz';
    }
    final phoneRegex = RegExp(r'^(\+90|0)?[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d+]'), ''))) {
      return 'Geçerli bir telefon numarası girin';
    }
    return null;
  }

  /// Şifre validasyonu (minimum 6 karakter)
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz';
    }
    if (value.length < minLength) {
      return 'Şifre en az $minLength karakter olmalıdır';
    }
    return null;
  }

  /// Zorunlu alan kontrolü
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Bu alan'} boş olamaz';
    }
    return null;
  }

  /// TC Kimlik No validasyonu
  static String? tcNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'TC Kimlik No boş olamaz';
    }
    if (value.length != 11) {
      return 'TC Kimlik No 11 haneli olmalıdır';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'TC Kimlik No sadece rakam içermelidir';
    }
    return null;
  }
}

