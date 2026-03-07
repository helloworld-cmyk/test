import 'package:flutter/foundation.dart';

import '../../assets/BE.dart';

class LoginState {
  final String email;
  final String password;
  final bool isShowPassword;
  final bool isLoading;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isShowPassword = false,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isShowPassword,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginController {
  final ValueNotifier<LoginState> state = ValueNotifier(const LoginState());

  void updateEmail(String value) {
    state.value = state.value.copyWith(email: value);
  }

  void updatePassword(String value) {
    state.value = state.value.copyWith(password: value);
  }

  void toggleShowPassword() {
    state.value = state.value.copyWith(
      isShowPassword: !state.value.isShowPassword,
    );
  }

  String? validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = (value ?? '').trim();
    if (password.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  Future<AuthResult> login() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final result = await FakeAuthApi.instance.login(
        email: state.value.email.trim(),
        password: state.value.password,
      );
      return result;
    } finally {
      state.value = state.value.copyWith(isLoading: false);
    }
  }

  void dispose() {
    state.dispose();
  }
}

