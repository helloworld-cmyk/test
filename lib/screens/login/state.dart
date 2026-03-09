enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final String email;
  final String password;
  final bool isShowPassword;
  final String emailError;
  final String passwordError;
  final bool showValidationErrors;
  final LoginStatus status;
  final String errorMessage;
  final String fullName;
  final String userEmail;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isShowPassword = false,
    this.emailError = '',
    this.passwordError = '',
    this.showValidationErrors = false,
    this.status = LoginStatus.initial,
    this.errorMessage = '',
    this.fullName = '',
    this.userEmail = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isShowPassword,
    String? emailError,
    String? passwordError,
    bool? showValidationErrors,
    LoginStatus? status,
    String? errorMessage,
    String? fullName,
    String? userEmail,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      fullName: fullName ?? this.fullName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}