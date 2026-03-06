import 'actions.dart';
import 'state.dart';
import 'validators.dart';

LoginState loginReducer(LoginState state, dynamic action) {
  if (action is LoginEmailChangedAction) {
    return state.copyWith(
      email: action.email,
      emailError: validateEmail(action.email),
      status: state.status == LoginStatus.failure
          ? LoginStatus.initial
          : state.status,
      errorMessage: state.status == LoginStatus.failure
          ? ''
          : state.errorMessage,
    );
  }

  if (action is LoginPasswordChangedAction) {
    return state.copyWith(
      password: action.password,
      passwordError: validatePassword(action.password),
      status: state.status == LoginStatus.failure
          ? LoginStatus.initial
          : state.status,
      errorMessage: state.status == LoginStatus.failure
          ? ''
          : state.errorMessage,
    );
  }

  if (action is LoginToggleShowPasswordAction) {
    return state.copyWith(isShowPassword: !state.isShowPassword);
  }

  if (action is LoginSubmitRequestedAction) {
    final emailError = validateEmail(state.email);
    final passwordError = validatePassword(state.password);

    return state.copyWith(
      showValidationErrors: true,
      emailError: emailError,
      passwordError: passwordError,
      status: emailError.isEmpty && passwordError.isEmpty
          ? state.status
          : LoginStatus.initial,
      errorMessage: '',
    );
  }

  if (action is LoginSubmitStartedAction) {
    return state.copyWith(status: LoginStatus.loading, errorMessage: '');
  }

  if (action is LoginSubmitSucceededAction) {
    return state.copyWith(
      status: LoginStatus.success,
      errorMessage: '',
      fullName: action.fullName,
      userEmail: action.email,
    );
  }

  if (action is LoginSubmitFailedAction) {
    return state.copyWith(
      status: LoginStatus.failure,
      errorMessage: action.message,
    );
  }

  if (action is LoginClearStatusAction) {
    return state.copyWith(status: LoginStatus.initial, errorMessage: '');
  }

  return state;
}
