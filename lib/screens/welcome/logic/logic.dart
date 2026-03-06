import 'package:signals/signals_flutter.dart';
import 'dart:math';
import '../product.dart';
import 'state.dart';

class WelcomeLogic {
  final state = signal(const ProductState());

  WelcomeLogic() {
    _initProducts();
  }

  void _initProducts() {
    final sourceProducts = List<Product>.from(allProducts);
    final pages = _rebuildPages(sourceProducts);
    state.value = state.value.copyWith(
      products: sourceProducts,
      productPages: pages,
      pageIndex: 0,
    );
  }

  List<List<Product>> _rebuildPages(List<Product> products) {
    if (products.isEmpty) return [];
    final pageCount = (products.length / itemsPerPage).ceil();
    return List<List<Product>>.generate(pageCount, (index) {
      final start = index * itemsPerPage;
      final end = min(start + itemsPerPage, products.length);
      return products.sublist(start, end);
    });
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final shuffledProducts = List<Product>.from(state.value.products)
      ..shuffle();
    final pages = _rebuildPages(shuffledProducts);
    state.value = state.value.copyWith(
      products: shuffledProducts,
      productPages: pages,
      pageIndex: 0,
    );
  }

  void increment() {
    if (state.value.pageIndex < state.value.productPages.length - 1) {
      state.value = state.value.copyWith(pageIndex: state.value.pageIndex + 1);
    }
  }

  void decrement() {
    if (state.value.pageIndex > 0) {
      state.value = state.value.copyWith(pageIndex: state.value.pageIndex - 1);
    }
  }
}

final welcomeLogic = WelcomeLogic();
