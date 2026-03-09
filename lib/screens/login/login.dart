import 'package:flutter/material.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login(BuildContext context, LoginController controller) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(content: Text('Đang đăng nhập...')),
    );

    try {
      final result = await controller.login();

      messenger.hideCurrentSnackBar();

      if (!context.mounted) return;

      if (result.success) {
        Navigator.of(context).pushReplacementNamed(
          '/welcome',
          arguments: {
            'fullName': result.user?['fullName'] as String? ?? 'Người dùng',
            'email': result.user?['email'] as String? ?? 'Email không xác định',
          },
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text('Có lỗi khi đăng nhập: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginScope(
      child: Builder(
        builder: (context) {
          final controller = LoginScope.of(context);
          final state = controller.state;
          final topPadding = MediaQuery.of(context).padding.top;
          final bottomPadding = MediaQuery.of(context).padding.bottom;

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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Chào mừng bạn quay trở lại'),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email'),
                            const SizedBox(height: 8),
                            TextFormField(
                              onChanged: controller.updateEmail,
                              validator: controller.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              enabled: !state.isLoading,
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
                              onChanged: controller.updatePassword,
                              validator: controller.validatePassword,
                              enabled: !state.isLoading,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: 'Nhập mật khẩu của bạn',
                                suffixIcon: IconButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : controller.toggleShowPassword,
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
                                onPressed: state.isLoading
                                    ? null
                                    : () => _login(context, controller),
                                child: state.isLoading
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

