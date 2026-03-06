import 'package:get/get.dart';

import '../product.dart';
import 'state.dart';

class ProductController extends GetxController {
  final Rx<ProductState> state = const ProductState().obs;

  @override
  void onInit() {
    super.onInit();
    initialLoad();
  }

  void initialLoad() {
    final List<Product> products = List<Product>.from(allProducts);
    state.value = _buildPagedState(products);
  }

  Future<void> refreshProducts() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final List<Product> products = List<Product>.from(allProducts)..shuffle();
    state.value = _buildPagedState(products);
  }

  void incrementPage() {
    final current = state.value;
    if (current.pageIndex < current.productPages.length - 1) {
      state.value = current.copyWith(pageIndex: current.pageIndex + 1);
    }
  }

  void decrementPage() {
    final current = state.value;
    if (current.pageIndex > 0) {
      state.value = current.copyWith(pageIndex: current.pageIndex - 1);
    }
  }

  ProductState _buildPagedState(List<Product> products) {
    final pageCounts = (products.length / itemsPerPage).ceil();
    final List<List<Product>> productPages = List<List<Product>>.generate(
      pageCounts,
      (index) {
        final start = index * itemsPerPage;
        final end = start + itemsPerPage;
        return products.sublist(start, end > products.length ? products.length : end);
      },
    );

    return ProductState(
      products: products,
      pageIndex: 0,
      productPages: productPages,
    );
  }
}
