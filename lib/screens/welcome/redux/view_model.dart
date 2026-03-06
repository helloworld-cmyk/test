import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import 'package:first_app/redux/app_state.dart';
import 'package:first_app/screens/welcome/product.dart';
import 'package:first_app/screens/welcome/redux/action.dart';

class ProductViewModel {
  final int pageIndex;
  final List<List<Product>> productPages;
  final Future<void> Function() onRefresh;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;

  const ProductViewModel({
    required this.pageIndex,
    required this.productPages,
    required this.onRefresh,
    required this.onNextPage,
    required this.onPreviousPage,
  });

  bool get hasPages => productPages.isNotEmpty;

  int get safePageIndex {
    if (pageIndex < 0) {
      return 0;
    }
    if (hasPages && pageIndex >= productPages.length) {
      return productPages.length - 1;
    }
    return pageIndex;
  }

  List<Product> get currentPageProducts {
    if (!hasPages) {
      return const <Product>[];
    }
    return productPages[safePageIndex];
  }

  bool get canGoNext => hasPages && safePageIndex < productPages.length - 1;

  bool get canGoPrevious => hasPages && safePageIndex > 0;

  String get paginationLabel =>
      'Page ${safePageIndex + 1}/${productPages.length}';

  static void initProducts(Store<AppState> store) {
    if (store.state.product.products.isEmpty) {
      store.dispatch(const ProductInitAction());
    }
  }

  factory ProductViewModel.fromStore(Store<AppState> store) {
    final productState = store.state.product;

    return ProductViewModel(
      pageIndex: productState.pageIndex,
      productPages: productState.productPages,
      onRefresh: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        store.dispatch(const ProductReloadAction());
      },
      onNextPage: () {
        store.dispatch(const ProductIncrementAction());
      },
      onPreviousPage: () {
        store.dispatch(const ProductDecrementAction());
      },
    );
  }
}
