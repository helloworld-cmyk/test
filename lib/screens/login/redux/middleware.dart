import 'package:redux/redux.dart';

import '../../../assets/BE.dart';
import 'actions.dart';
import 'state.dart';

typedef LoginStateSelector<TState> = LoginState Function(TState state);

List<Middleware<TState>> createLoginMiddleware<TState>({
  required LoginStateSelector<TState> selectLoginState,
}) {
  return [
    TypedMiddleware<TState, LoginSubmitRequestedAction>((store, action, next) {
      _handleLoginSubmit<TState>(store, action, next, selectLoginState);
    }),
  ];
}

void _handleLoginSubmit<TState>(
  Store<TState> store,
  LoginSubmitRequestedAction action,
  NextDispatcher next,
  LoginStateSelector<TState> selectLoginState,
) async {
  next(action);

  final state = selectLoginState(store.state);
  final hasValidationError =
      state.emailError.isNotEmpty || state.passwordError.isNotEmpty;
  if (hasValidationError) {
    return;
  }

  store.dispatch(const LoginSubmitStartedAction());

  try {
    final result = await FakeAuthApi.instance.login(
      email: state.email.trim(),
      password: state.password,
    );

    if (result.success) {
      store.dispatch(
        LoginSubmitSucceededAction(
          fullName: result.user?['fullName']?.toString() ?? 'Người dùng',
          email: result.user?['email']?.toString() ?? 'Email không xác định',
        ),
      );
      return;
    }

    store.dispatch(LoginSubmitFailedAction(result.message));
  } catch (error) {
    store.dispatch(LoginSubmitFailedAction('Có lỗi khi đăng nhập: $error'));
  }
}
