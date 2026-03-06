import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic/controller.dart';
import 'logic/state.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email'),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: controller.emailChanged,
                        keyboardType: TextInputType.emailAddress,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Nhập email của bạn',
                          errorText:
                              state.showValidationErrors &&
                                  state.emailError.isNotEmpty
                              ? state.emailError
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Mật khẩu'),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: !state.isShowPassword,
                        onChanged: controller.passwordChanged,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Nhập mật khẩu của bạn',
                          errorText:
                              state.showValidationErrors &&
                                  state.passwordError.isNotEmpty
                              ? state.passwordError
                              : null,
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
                          onPressed: state.status == LoginStatus.loading
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  controller.submitLogin();
                                },
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}