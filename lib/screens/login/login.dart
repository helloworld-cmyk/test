import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic/notifier.dart';
import 'logic/state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (previous?.status == next.status) {
        return;
      }

      if (next.status == LoginStatus.success) {
        Navigator.of(context).pushReplacementNamed(
          '/welcome',
          arguments: {'fullName': next.fullName, 'email': next.userEmail},
        );
        ref.read(loginProvider.notifier).clearStatus();
        return;
      }

      if (next.status == LoginStatus.failure && next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${next.errorMessage}')),
        );
        ref.read(loginProvider.notifier).clearStatus();
      }
    });

    final notifier = ref.read(loginProvider.notifier);
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
                  onChanged: notifier.onEmailChanged,
                  keyboardType: TextInputType.emailAddress,
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
                TextFormField(
                  initialValue: state.password,
                  obscureText: !state.isShowPassword,
                  onChanged: notifier.onPasswordChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Nhập mật khẩu của bạn',
                    errorText: state.passwordError.isEmpty
                        ? null
                        : state.passwordError,
                    suffixIcon: IconButton(
                      onPressed: notifier.toggleShowPassword,
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
                    onPressed: isLoading ? null : notifier.login,
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
  }
}
