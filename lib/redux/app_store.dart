import 'package:redux/redux.dart';

import 'app_middleware.dart';
import 'app_reducer.dart';
import 'app_state.dart';

Store<AppState> createAppStore() {
  return Store<AppState>(
    appReducer,
    initialState: const AppState(),
    middleware: createAppMiddleware(),
  );
}
