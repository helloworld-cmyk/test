import '../screens/login/redux/reducer.dart';
import '../screens/welcome/redux/reducer.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return state.copyWith(
    login: loginReducer(state.login, action),
    product: productReducer(state.product, action),
  );
}
