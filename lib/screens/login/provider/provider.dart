import 'package:flutter/material.dart';

import '../../../assets/BE.dart';
import 'state.dart';
class LoginProvider extends ChangeNotifier {
  LoginState _state = const LoginState();

  LoginState get state => _state;

  void onEmailChanged(String value) {
    _state = _state.copyWith(
      email: value,
      emailError: _state.showValidationErrors ? _validateEmail(value) : '',
      status: _state.status == LoginStatus.failure
          ? LoginStatus.initial
          : _state.status,
      errorMessage: _state.status == LoginStatus.failure
          ? ''
          : _state.errorMessage,
    );
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(
      password: value,
      passwordError: _state.showValidationErrors
          ? _validatePassword(value)
          : '',
      status: _state.status == LoginStatus.failure
          ? LoginStatus.initial
          : _state.status,
      errorMessage: _state.status == LoginStatus.failure
          ? ''
          : _state.errorMessage,
    );
    notifyListeners();
  }

  void toggleShowPassword() {
    _state = _state.copyWith(isShowPassword: !_state.isShowPassword);
    notifyListeners();
  }

  Future<void> login() async {
    if (_state.status == LoginStatus.loading) {
      return;
    }

    final isValid = _validate(showErrors: true);
    if (!isValid) {
      return;
    }

    _state = _state.copyWith(
      status: LoginStatus.loading,
      errorMessage: '',
      fullName: '',
      userEmail: '',
    );
    notifyListeners();

    try {
      final result = await FakeAuthApi.instance.login(
        email: _state.email.trim(),
        password: _state.password,
      );

      if (result.success) {
        _state = _state.copyWith(
          status: LoginStatus.success,
          errorMessage: '',
          fullName: result.user?['fullName'] as String? ?? 'Người dùng',
          userEmail: result.user?['email'] as String? ?? 'Email không xác định',
        );
      } else {
        _state = _state.copyWith(
          status: LoginStatus.failure,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Có lỗi khi đăng nhập: $e',
      );
    }

    notifyListeners();
  }

  void clearStatus() {
    if (_state.status == LoginStatus.initial && _state.errorMessage.isEmpty) {
      return;
    }

    _state = _state.copyWith(status: LoginStatus.initial, errorMessage: '');
    notifyListeners();
  }

  bool _validate({required bool showErrors}) {
    final emailError = _validateEmail(_state.email);
    final passwordError = _validatePassword(_state.password);

    _state = _state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      showValidationErrors: showErrors ? true : _state.showValidationErrors,
    );
    notifyListeners();

    return emailError.isEmpty && passwordError.isEmpty;
  }

  String _validateEmail(String value) {
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

  String _validatePassword(String value) {
    final password = value.trim();

    if (password.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return '';
  }
}
