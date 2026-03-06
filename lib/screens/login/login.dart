import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/provider.dart';
import 'provider/state.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleStatus(BuildContext context, LoginProvider provider) {
    final state = provider.state;

    if (state.status == LoginStatus.success) {
      final fullName = state.fullName;
      final email = state.userEmail;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        provider.clearStatus();
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

        provider.clearStatus();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $message')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Consumer<LoginProvider>(
      builder: (context, provider, _) {
        final state = provider.state;
        final isLoading = state.status == LoginStatus.loading;

        _handleStatus(context, provider);

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email'),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: provider.onEmailChanged,
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
                          onChanged: provider.onPasswordChanged,
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
                              onPressed: provider.toggleShowPassword,
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
                            onPressed: isLoading ? null : provider.login,
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
      },
    );
  }
}
