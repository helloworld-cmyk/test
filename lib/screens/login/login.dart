import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:first_app/redux/app_state.dart';
import 'package:first_app/screens/login/redux/view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return StoreConnector<AppState, LoginViewModel>(
      converter: LoginViewModel.fromStore,
      onWillChange: (previousVm, vm) {
        _onStateChanged(context, previousVm, vm);
      },
      builder: (context, vm) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: mediaQuery.padding.top,
                bottom: mediaQuery.padding.bottom,
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
                      autovalidateMode: vm.showValidationErrors
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          const SizedBox(height: 8),
                          TextFormField(
                            onChanged: vm.onEmailChanged,
                            keyboardType: TextInputType.emailAddress,
                            validator: (_) {
                              if (!vm.showValidationErrors ||
                                  vm.emailError.isEmpty) {
                                return null;
                              }
                              return vm.emailError;
                            },
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
                            obscureText: !vm.isShowPassword,
                            onChanged: vm.onPasswordChanged,
                            validator: (_) {
                              if (!vm.showValidationErrors ||
                                  vm.passwordError.isEmpty) {
                                return null;
                              }
                              return vm.passwordError;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Nhập mật khẩu của bạn',
                              suffixIcon: IconButton(
                                onPressed: vm.onToggleShowPassword,
                                icon: Icon(
                                  vm.isShowPassword
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
                              onPressed: vm.isLoading ? null : vm.onSubmit,
                              child: vm.isLoading
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
    );
  }

  void _onStateChanged(
    BuildContext context,
    LoginViewModel? previousVm,
    LoginViewModel vm,
  ) {
    if (previousVm?.status == vm.status) {
      return;
    }

    if (vm.isFailure && vm.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${vm.errorMessage}')),
        );
      vm.onClearStatus();
      return;
    }

    if (vm.isSuccess) {
      Navigator.of(context).pushReplacementNamed(
        '/welcome',
        arguments: <String, String>{
          'fullName': vm.fullName.isEmpty ? 'Người dùng' : vm.fullName,
          'email': vm.userEmail.isEmpty ? 'Email không xác định' : vm.userEmail,
        },
      );
    }
  }
}
