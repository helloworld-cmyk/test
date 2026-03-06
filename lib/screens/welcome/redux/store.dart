import 'package:redux/redux.dart';
import 'reducer.dart';
import 'state.dart';

Store<ProductState> createProductStore() {
  return Store<ProductState>(
    productReducer,
    initialState: const ProductState(),
  );
}
