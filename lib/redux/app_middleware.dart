import 'package:redux/redux.dart';

import '../screens/login/redux/middleware.dart';
import 'app_state.dart';

List<Middleware<AppState>> createAppMiddleware() {
  return createLoginMiddleware<AppState>(
    selectLoginState: (state) => state.login,
  );
}
