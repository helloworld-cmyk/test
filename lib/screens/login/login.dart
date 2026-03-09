import 'package:flutter/material.dart';
import 'login_controller.dart';
import 'state.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoginState>(
      valueListenable: controller.notifier,
      builder: (context, state, _) {
        if (state.status == LoginStatus.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(
              '/welcome',
              arguments: {'fullName': state.fullName, 'email': state.userEmail},
            );
            controller.clearStatus();
          });
        } else if (state.status == LoginStatus.failure && state.errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đăng nhập thất bại: ${state.errorMessage}')),
            );
            controller.clearStatus();
          });
        }

        final isLoading = state.status == LoginStatus.loading;

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
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
                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: state.email,
                      onChanged: controller.onEmailChanged,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Nhập email của bạn',
                        errorText: state.emailError.isEmpty ? null : state.emailError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Mật khẩu'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: state.password,
                      obscureText: !state.isShowPassword,
                      onChanged: controller.onPasswordChanged,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Nhập mật khẩu của bạn',
                        errorText: state.passwordError.isEmpty ? null : state.passwordError,
                        suffixIcon: IconButton(
                          onPressed: controller.toggleShowPassword,
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
                        onPressed: isLoading ? null : () => controller.login(),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Đăng nhập'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}