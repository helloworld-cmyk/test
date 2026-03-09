import 'package:flutter/material.dart';
import 'package:first_app/screens/login/state.dart';

class LoginProvider extends InheritedWidget {
  final LoginState state;
  final void Function(LoginState newState) updateState;

  const LoginProvider({
    super.key,
    required this.state,
    required this.updateState,
    required super.child,
  });

  static LoginProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<LoginProvider>();
    assert(provider != null, 'LoginProvider not found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(LoginProvider oldWidget) {
    return oldWidget.state != state;
  }
}
