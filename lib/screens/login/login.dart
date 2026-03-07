import 'package:flutter/material.dart';
import 'state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _controller = LoginController();

  void _login() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    try {
      final result = await _controller.login();

      if (!mounted) {
        return;
      }

      if (result.success) {
        Navigator.of(context).pushReplacementNamed(
          '/welcome',
          arguments: {
            'fullName': result.user?['fullName'] as String? ?? 'Người dùng',
            'email': result.user?['email'] as String? ?? 'Email không xác định',
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${result.message}')),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Có lỗi khi đăng nhập: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

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
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) =>
                            setState(() => _controller.updateEmail(value)),
                        validator: _controller.validateEmail,
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
                        obscureText: !_controller.isShowPassword,
                        onChanged: (value) =>
                            setState(() => _controller.updatePassword(value)),
                        validator: _controller.validatePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Nhập mật khẩu của bạn',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(_controller.toggleShowPassword),
                            icon: Icon(
                              _controller.isShowPassword
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
                          onPressed: _login,
                          child: const Text('Đăng nhập'),
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
  }
}
