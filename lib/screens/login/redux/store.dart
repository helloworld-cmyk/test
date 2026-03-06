import 'package:redux/redux.dart';

import 'middleware.dart';
import 'reducer.dart';
import 'state.dart';

Store<LoginState> createLoginStore() {
  return Store<LoginState>(
    loginReducer,
    initialState: const LoginState(),
    middleware: createLoginMiddleware<LoginState>(
      selectLoginState: (state) => state,
    ),
  );
}
