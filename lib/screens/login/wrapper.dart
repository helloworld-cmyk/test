import 'package:flutter/material.dart';
import 'package:first_app/screens/login/inheritedwidget.dart';
import 'package:first_app/screens/login/state.dart';

class LoginStore extends StatefulWidget {
  final Widget child;
  const LoginStore({super.key, required this.child});

  @override
  State<LoginStore> createState() => _LoginStoreState();
}

class _LoginStoreState extends State<LoginStore> {
  LoginState _state = LoginState(
    email: '',
    password: '',
    isShowPassword: false,
    emailError: '',
    passwordError: '',
    showValidationErrors: false,
    errorMessage: '',
    fullName: '',
    userEmail: '',
  );

  void updateState(LoginState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      state: _state,
      updateState: updateState,
      child: widget.child,
    );
  }
}
