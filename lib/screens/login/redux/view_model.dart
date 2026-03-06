import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import 'package:first_app/redux/app_state.dart';
import 'package:first_app/screens/login/redux/actions.dart';
import 'package:first_app/screens/login/redux/state.dart';

class LoginViewModel {
  final bool isShowPassword;
  final String emailError;
  final String passwordError;
  final bool showValidationErrors;
  final LoginStatus status;
  final String errorMessage;
  final String fullName;
  final String userEmail;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleShowPassword;
  final VoidCallback onSubmit;
  final VoidCallback onClearStatus;

  const LoginViewModel({
    required this.isShowPassword,
    required this.emailError,
    required this.passwordError,
    required this.showValidationErrors,
    required this.status,
    required this.errorMessage,
    required this.fullName,
    required this.userEmail,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onToggleShowPassword,
    required this.onSubmit,
    required this.onClearStatus,
  });

  bool get isLoading => status == LoginStatus.loading;

  bool get isFailure => status == LoginStatus.failure;

  bool get isSuccess => status == LoginStatus.success;

  factory LoginViewModel.fromStore(Store<AppState> store) {
    final loginState = store.state.login;

    return LoginViewModel(
      isShowPassword: loginState.isShowPassword,
      emailError: loginState.emailError,
      passwordError: loginState.passwordError,
      showValidationErrors: loginState.showValidationErrors,
      status: loginState.status,
      errorMessage: loginState.errorMessage,
      fullName: loginState.fullName,
      userEmail: loginState.userEmail,
      onEmailChanged: (value) {
        store.dispatch(LoginEmailChangedAction(value));
      },
      onPasswordChanged: (value) {
        store.dispatch(LoginPasswordChangedAction(value));
      },
      onToggleShowPassword: () {
        store.dispatch(const LoginToggleShowPasswordAction());
      },
      onSubmit: () {
        store.dispatch(const LoginSubmitRequestedAction());
      },
      onClearStatus: () {
        store.dispatch(const LoginClearStatusAction());
      },
    );
  }
}
