class Validators {
  Validators._();

  static String? validateTitle(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Judul tidak boleh kosong';
    if (v.length < 3) return 'Judul minimal 3 karakter';
    if (v.length > 50) return 'Judul maksimal 50 karakter';
    return null;
  }

  static String? validateContent(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Isi catatan tidak boleh kosong';
    if (v.length < 10) return 'Isi catatan minimal 10 karakter';
    if (v.length > 1000) return 'Isi catatan maksimal 1000 karakter';
    return null;
  }

  static String? validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email tidak boleh kosong';
    final regex = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');
    if (!regex.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }

  /// Membersihkan karakter berbahaya (<, >, ", ') dari [input].
  static String sanitize(String input) {
    return input
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .trim();
  }
}
