import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(

        listenWhen: (previous, current) => previous.status != current.status,

        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.of(context).pushReplacementNamed(
              '/welcome',
              arguments: {'fullName': state.fullName, 'email': state.userEmail},
            );
            return;
          }

          else if (state.status == LoginStatus.loading) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              const SnackBar(content: Text('Đang đăng nhập...')),
            );
          }

          if (state.status == LoginStatus.failure &&
              state.errorMessage.isNotEmpty) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },


        builder: (context, state) {
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
                            onChanged: (value) {
                              context.read<LoginBloc>().add(
                                EmailChanged(value),
                              );
                            },
                            keyboardType: TextInputType.emailAddress,
                            enabled: state.status != LoginStatus.loading,
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
                            onChanged: (value) {
                              context.read<LoginBloc>().add(
                                PasswordChanged(value),
                              );
                            },
                            enabled: state.status != LoginStatus.loading,
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
                                onPressed: state.status == LoginStatus.loading
                                    ? null
                                    : () {
                                        context.read<LoginBloc>().add(
                                          const ToggleShowPassword(),
                                        );
                                      },
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
                                      context.read<LoginBloc>().add(
                                        const SubmitLogin(),
                                      );
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
        },
      ),
    );
  }
}
