import 'package:signals/signals_flutter.dart';
import 'state.dart';
import '../../../assets/BE.dart';

class LoginLogic {
  final state = signal(const LoginState());

  void updateEmail(String email) {
    state.value = state.value.copyWith(email: email);
  }

  void updatePassword(String password) {
    state.value = state.value.copyWith(password: password);
  }

  void toggleShowPassword() {
    state.value = state.value.copyWith(
      isShowPassword: !state.value.isShowPassword,
    );
  }

  Future<bool> login() async {
    state.value = state.value.copyWith(status: LoginStatus.loading);
    try {
      final result = await FakeAuthApi.instance.login(
        email: state.value.email.trim(),
        password: state.value.password,
      );

      if (result.success) {
        state.value = state.value.copyWith(
          status: LoginStatus.success,
          fullName: result.user?['fullName'] as String? ?? 'Người dùng',
          userEmail: result.user?['email'] as String? ?? 'Email không xác định',
        );
        return true;
      } else {
        state.value = state.value.copyWith(
          status: LoginStatus.failure,
          errorMessage: result.message,
        );
        return false;
      }
    } catch (e) {
      state.value = state.value.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final loginLogic = LoginLogic();
