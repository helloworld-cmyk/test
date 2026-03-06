import 'package:get/get.dart';
import 'state.dart';
import '../../../assets/BE.dart';

class LoginController extends GetxController {
  final Rx<LoginState> state = const LoginState().obs;

  void emailChanged(String value) {
    final bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    state.value = state.value.copyWith(
      email: value,
      emailError: isEmailValid ? '' : 'Email không hợp lệ',
    );
  }

  void passwordChanged(String value) {
    state.value = state.value.copyWith(
      password: value,
      passwordError: value.length < 6 ? 'Mật khẩu phải có ít nhất 6 ký tự' : '',
    );
  }


  void toggleShowPassword() {
    state.value = state.value.copyWith(isShowPassword: !state.value.isShowPassword);
  }

  Future<void> submitLogin() async {
    final currentState = state.value;

    try {
      if (currentState.email.isEmpty || currentState.password.isEmpty) {
        state.value = currentState.copyWith(
          showValidationErrors: true,
          emailError: currentState.email.isEmpty ? 'Vui lòng nhập email' : currentState.emailError,
          passwordError: currentState.password.isEmpty ? 'Vui lòng nhập mật khẩu' : currentState.passwordError,
        );
        return;
      }

      if (currentState.emailError.isNotEmpty || currentState.passwordError.isNotEmpty) {
        state.value = state.value.copyWith(showValidationErrors: true);
        return;
      }

      state.value = state.value.copyWith(
        status: LoginStatus.loading,
        showValidationErrors: true,
        errorMessage: '',
      );

      final result = await FakeAuthApi.instance.login(
        email: state.value.email,
        password: state.value.password,
      );

      if (result.success) {
        final fullName = result.user?['fullName'] as String? ?? 'Người dùng';
        final email = result.user?['email'] as String? ?? 'Email không xác định';
        state.value = state.value.copyWith(
          status: LoginStatus.success,
          fullName: fullName,
          userEmail: email,
          errorMessage: '',
        );
        Get.offNamed(
          '/welcome',
          arguments: {
            'fullName': fullName,
            'email': email,
          },
        );
      } else {
        state.value = state.value.copyWith(
          status: LoginStatus.failure,
          errorMessage: result.message,
        );
        Get.snackbar('Đăng nhập thất bại', result.message);
      }
    } catch (e) {
      state.value = state.value.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      );
      Get.snackbar('Có lỗi khi đăng nhập', e.toString());
    }
  }

}