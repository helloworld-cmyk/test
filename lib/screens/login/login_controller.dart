import 'package:flutter/widgets.dart';

import '../../assets/BE.dart';

class LoginState {
  final String email;
  final String password;
  final bool isShowPassword;
  final bool isLoading;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isShowPassword = false,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isShowPassword,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginController extends ChangeNotifier {
  LoginState _state = const LoginState();

  LoginState get state => _state;

  void _emit(LoginState newState) {
    if (identical(newState, _state)) return;
    _state = newState;
    notifyListeners();
  }

  void updateEmail(String value) {
    _emit(_state.copyWith(email: value));
  }

  void updatePassword(String value) {
    _emit(_state.copyWith(password: value));
  }

  void toggleShowPassword() {
    _emit(
      _state.copyWith(isShowPassword: !_state.isShowPassword),
    );
  }

  String? validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = (value ?? '').trim();
    if (password.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  Future<AuthResult> login() async {
    _emit(_state.copyWith(isLoading: true));
    try {
      final result = await FakeAuthApi.instance.login(
        email: _state.email.trim(),
        password: _state.password,
      );
      return result;
    } finally {
      _emit(_state.copyWith(isLoading: false));
    }
  }
}

class _LoginInherited extends InheritedNotifier<LoginController> {
  const _LoginInherited({
    required LoginController notifier,
    required Widget child,
    super.key,
  }) : super(notifier: notifier, child: child);
}

class LoginScope extends StatefulWidget {
  final Widget child;

  const LoginScope({super.key, required this.child});

  static LoginController of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_LoginInherited>();
    assert(inherited != null, 'No LoginScope found in context');
    return inherited!.notifier!;
  }

  @override
  State<LoginScope> createState() => _LoginScopeState();
}

class _LoginScopeState extends State<LoginScope> {
  late final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LoginInherited(
      notifier: _controller,
      child: widget.child,
    );
  }
}


