import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../assets/BE.dart';
import 'state.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  LoginState build() {
    return const LoginState();
  }

  void onEmailChanged(String value) {
    final trimmed = value.trim();
    state = state.copyWith(
      email: value,
      emailError: state.showValidationErrors ? _validateEmail(trimmed) : '',
    );
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(
      password: value,
      passwordError: state.showValidationErrors ? _validatePassword(value) : '',
    );
  }

  void toggleShowPassword() {
    state = state.copyWith(isShowPassword: !state.isShowPassword);
  }

  Future<void> login() async {
    if (state.status == LoginStatus.loading) {
      return;
    }

    final trimmedEmail = state.email.trim();
    final emailError = _validateEmail(trimmedEmail);
    final passwordError = _validatePassword(state.password);

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      state = state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        showValidationErrors: true,
      );
      return;
    }

    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: '',
      showValidationErrors: true,
      emailError: '',
      passwordError: '',
    );

    try {
      final result = await FakeAuthApi.instance.login(
        email: trimmedEmail,
        password: state.password,
      );

      if (result.success) {
        state = state.copyWith(
          status: LoginStatus.success,
          fullName: result.user?['fullName'] as String? ?? 'Người dùng',
          userEmail: result.user?['email'] as String? ?? trimmedEmail,
          errorMessage: '',
        );
        return;
      }

      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: result.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Có lỗi khi đăng nhập: $e',
      );
    }
  }

  void clearStatus() {
    if (state.status == LoginStatus.initial && state.errorMessage.isEmpty) {
      return;
    }

    state = state.copyWith(status: LoginStatus.initial, errorMessage: '');
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    if (!_emailRegex.hasMatch(value)) {
      return 'Email không đúng định dạng';
    }

    return '';
  }

  String _validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return '';
  }
}
