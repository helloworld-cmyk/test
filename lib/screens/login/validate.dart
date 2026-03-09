String validateEmail(String email) {
  final normalizedEmail = email.trim();

  if (normalizedEmail.isEmpty) {
    return 'Email không được để trống';
  }

  if (normalizedEmail.contains(' ')) {
    return 'Email không hợp lệ';
  }

  final parts = normalizedEmail.split('@');
  if (parts.length != 2 || parts.first.isEmpty || parts.last.isEmpty) {
    return 'Email không hợp lệ';
  }

  if (!parts.last.contains('.')) {
    return 'Email không hợp lệ';
  }

  return '';
}

String validatePassword(String password) {
  if (password.isEmpty) {
    return 'Mật khẩu không được để trống';
  }

  if (password.length < 6) {
    return 'Mật khẩu phải có ít nhất 6 ký tự';
  }

  return '';
}
