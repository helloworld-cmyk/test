import '../screens/login/redux/state.dart';
import '../screens/welcome/redux/state.dart';

class AppState {
  final LoginState login;
  final ProductState product;

  const AppState({
    this.login = const LoginState(),
    this.product = const ProductState(),
  });

  AppState copyWith({
    LoginState? login,
    ProductState? product,
  }) {
    return AppState(
      login: login ?? this.login,
      product: product ?? this.product,
    );
  }
}
