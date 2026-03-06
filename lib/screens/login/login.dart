import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'logic/logic.dart';
import 'logic/state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    final formKey = GlobalKey<FormState>();

    void onLoginPressed() async {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      final success = await loginLogic.login();
      if (!context.mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed(
          '/welcome',
          arguments: {
            'fullName': loginLogic.state.value.fullName,
            'email': loginLogic.state.value.userEmail,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đăng nhập thất bại: ${loginLogic.state.value.errorMessage}',
            ),
          ),
        );
      }
    }

    String? validateEmail(String? value) {
      final email = (value ?? '').trim();
      if (email.isEmpty) return 'Vui lòng nhập email';
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(email)) return 'Email không đúng định dạng';
      return null;
    }

    String? validatePassword(String? value) {
      final password = (value ?? '').trim();
      if (password.isEmpty) return 'Vui lòng nhập mật khẩu';
      if (password.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
      return null;
    }

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
            child: Watch((context) {
              final state = loginLogic.state.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text('Chào mừng bạn quay trở lại'),
                  const SizedBox(height: 16),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email'),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: loginLogic.updateEmail,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Nhập email của bạn',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Mật khẩu'),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: !state.isShowPassword,
                          onChanged: loginLogic.updatePassword,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Nhập mật khẩu của bạn',
                            suffixIcon: IconButton(
                              onPressed: loginLogic.toggleShowPassword,
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
                            onPressed: state.status == LoginStatus.loading
                                ? null
                                : onLoginPressed,
                            child: state.status == LoginStatus.loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Đăng nhập'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
