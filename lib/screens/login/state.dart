import '../../assets/BE.dart';

class LoginController {
  String email = '';
  String password = '';
  bool isShowPassword = false;

  void updateEmail(String value) {
    email = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  void toggleShowPassword() {
    isShowPassword = !isShowPassword;
  }

  String? validateEmail(String? value) {
    final emailValue = (value ?? '').trim();
    if (emailValue.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(emailValue)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final passwordValue = (value ?? '').trim();
    if (passwordValue.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (passwordValue.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  Future<AuthResult> login() {
    return FakeAuthApi.instance.login(email: email.trim(), password: password);
  }
}
