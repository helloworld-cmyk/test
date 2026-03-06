import 'dart:math';
import 'package:flutter/material.dart';
import '../product.dart';
import 'state.dart';

class ProductProvider extends ChangeNotifier {
  ProductState _state = const ProductState();

  ProductState get state => _state;

  ProductProvider() {
    _initProducts();
  }

  void _initProducts() {
    final sourceProducts = List<Product>.from(allProducts);
    final pages = _rebuildPages(sourceProducts);
    _state = _state.copyWith(
      products: sourceProducts,
      productPages: pages,
      pageIndex: 0,
    );
    notifyListeners();
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
    final shuffledProducts = List<Product>.from(_state.products)..shuffle();
    final pages = _rebuildPages(shuffledProducts);
    _state = _state.copyWith(
      products: shuffledProducts,
      productPages: pages,
      pageIndex: 0,
    );
    notifyListeners();
  }

  void increment() {
    if (_state.pageIndex < _state.productPages.length - 1) {
      _state = _state.copyWith(pageIndex: _state.pageIndex + 1);
      notifyListeners();
    }
  }

  void decrement() {
    if (_state.pageIndex > 0) {
      _state = _state.copyWith(pageIndex: _state.pageIndex - 1);
      notifyListeners();
    }
  }
}
