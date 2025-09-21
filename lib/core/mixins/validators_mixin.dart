mixin ValidatorsMixin {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'E-posta zorunlu';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Geçerli bir e-posta girin';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre zorunlu';
    if (value.length < 6) return 'En az 6 karakter';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'İsim zorunlu';
    if (value.trim().length < 2) return 'En az 2 karakter';
    return null;
  }
}