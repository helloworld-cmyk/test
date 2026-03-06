String validateEmail(String value) {
  final email = value.trim();

  if (email.isEmpty) {
    return 'Vui lòng nhập email';
  }

  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(email)) {
    return 'Email không đúng định dạng';
  }

  return '';
}

String validatePassword(String value) {
  final password = value.trim();

  if (password.isEmpty) {
    return 'Vui lòng nhập mật khẩu';
  }

  if (password.length < 6) {
    return 'Mật khẩu phải có ít nhất 6 ký tự';
  }

  return '';
}
