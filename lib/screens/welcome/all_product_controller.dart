import 'dart:math';

import 'package:flutter/foundation.dart';

import 'product.dart';

class AllProductState {
  final List<List<Product>> productPages;
  final int pageIndex;

  const AllProductState({required this.productPages, required this.pageIndex});

  AllProductState copyWith({
    List<List<Product>>? productPages,
    int? pageIndex,
  }) {
    return AllProductState(
      productPages: productPages ?? this.productPages,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  int get pageCount => productPages.length;

  List<Product> get currentPageProducts =>
      pageCount == 0 ? <Product>[] : productPages[pageIndex];
}

class AllProductController {
  final List<Product> _sourceProducts;
  late final ValueNotifier<AllProductState> state;

  AllProductController({List<Product>? initialProducts})
    : _sourceProducts = List<Product>.from(initialProducts ?? allProducts) {
    state = ValueNotifier(
      AllProductState(productPages: _buildPages(_sourceProducts), pageIndex: 0),
    );
  }

  static List<List<Product>> _buildPages(List<Product> source) {
    final pageCount = (source.length / itemsPerPage).ceil();
    return List<List<Product>>.generate(pageCount, (index) {
      final start = index * itemsPerPage;
      final end = min(start + itemsPerPage, source.length);
      return source.sublist(start, end);
    });
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _sourceProducts.shuffle();
    state.value = state.value.copyWith(
      productPages: _buildPages(_sourceProducts),
      pageIndex: 0,
    );
  }

  void incrementPage() {
    final current = state.value;
    if (current.pageIndex >= current.pageCount - 1) {
      return;
    }

    state.value = current.copyWith(pageIndex: current.pageIndex + 1);
  }

  void decrementPage() {
    final current = state.value;
    if (current.pageIndex <= 0) {
      return;
    }

    state.value = current.copyWith(pageIndex: current.pageIndex - 1);
  }

  void dispose() {
    state.dispose();
  }
}
