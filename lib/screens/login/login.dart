import 'package:flutter/material.dart';
import 'package:first_app/assets/BE.dart';
import 'package:first_app/screens/login/inheritedwidget.dart';
import 'package:first_app/screens/login/state.dart';
import 'package:first_app/screens/login/validate.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Validation now imported from validate.dart

  void _onEmailChanged(
    String value,
    LoginState state,
    void Function(LoginState) updateState,
  ) {
    updateState(
      state.copyWith(
        email: value,
        emailError: state.showValidationErrors ? validateEmail(value) : '',
        status: LoginStatus.initial,
        errorMessage: '',
      ),
    );
  }

  void _onPasswordChanged(
    String value,
    LoginState state,
    void Function(LoginState) updateState,
  ) {
    updateState(
      state.copyWith(
        password: value,
        passwordError: state.showValidationErrors
            ? validatePassword(value)
            : '',
        status: LoginStatus.initial,
        errorMessage: '',
      ),
    );
  }

  Future<void> _login(
    LoginState state,
    void Function(LoginState) updateState,
  ) async {
    final email = state.email.trim();
    final password = state.password;
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      updateState(
        state.copyWith(
          email: email,
          emailError: emailError,
          passwordError: passwordError,
          showValidationErrors: true,
          status: LoginStatus.initial,
          errorMessage: '',
        ),
      );
      return;
    }

    updateState(
      state.copyWith(
        email: email,
        emailError: '',
        passwordError: '',
        showValidationErrors: true,
        status: LoginStatus.loading,
        errorMessage: '',
      ),
    );

    final result = await FakeAuthApi.instance.login(
      email: email,
      password: password,
    );

    if (result.success) {
      final user = result.user ?? const <String, dynamic>{};
      updateState(
        state.copyWith(
          email: email,
          status: LoginStatus.success,
          errorMessage: '',
          fullName: user['fullName'] as String? ?? '',
          userEmail: user['email'] as String? ?? email,
        ),
      );
      return;
    }

    updateState(
      state.copyWith(
        email: email,
        status: LoginStatus.failure,
        errorMessage: result.message,
        fullName: '',
        userEmail: '',
      ),
    );
  }

  void _handleStatus(
    BuildContext context,
    LoginState state,
    void Function(LoginState) updateState,
  ) {
    if (state.status == LoginStatus.success) {
      final fullName = state.fullName;
      final email = state.userEmail;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        updateState(
          state.copyWith(status: LoginStatus.initial, errorMessage: ''),
        );
        Navigator.of(context).pushReplacementNamed(
          '/welcome',
          arguments: {'fullName': fullName, 'email': email},
        );
      });
      return;
    }

    if (state.status == LoginStatus.failure && state.errorMessage.isNotEmpty) {
      final message = state.errorMessage;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        updateState(
          state.copyWith(status: LoginStatus.initial, errorMessage: ''),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $message')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final loginProvider = LoginProvider.of(context);
    final state = loginProvider.state;
    final updateState = loginProvider.updateState;
    final isLoading = state.status == LoginStatus.loading;

    _handleStatus(context, state, updateState);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
            left: 32,
            right: 32,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text('Chào mừng bạn quay trở lại'),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) =>
                          _onEmailChanged(value, state, updateState),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Nhập email của bạn',
                        errorText: state.emailError.isEmpty
                            ? null
                            : state.emailError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Mật khẩu'),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: !state.isShowPassword,
                      onChanged: (value) =>
                          _onPasswordChanged(value, state, updateState),
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Nhập mật khẩu của bạn',
                        errorText: state.passwordError.isEmpty
                            ? null
                            : state.passwordError,
                        suffixIcon: IconButton(
                          onPressed: () => updateState(
                            state.copyWith(
                              isShowPassword: !state.isShowPassword,
                            ),
                          ),
                          icon: Icon(
                            state.isShowPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _login(state, updateState),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Đăng nhập'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
