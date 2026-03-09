import 'dart:math';

import 'package:flutter/material.dart';
import 'package:first_app/screens/welcome/inheritedwidget.dart';
import 'package:first_app/screens/welcome/product.dart';
import 'package:first_app/screens/welcome/state.dart';

class ProductStore extends StatefulWidget {
  final Widget child;
  const ProductStore({super.key, required this.child});

  @override
  State<ProductStore> createState() => _ProductStoreState();
}

class _ProductStoreState extends State<ProductStore> {
  late ProductState _state;

  ProductState _initProducts() {
    final sourceProducts = List<Product>.from(allProducts);
    final pages = _rebuildPages(sourceProducts);
    return ProductState(
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
    final shuffledProducts = List<Product>.from(_state.products)..shuffle();
    final pages = _rebuildPages(shuffledProducts);
    setState(() {
      _state = _state.copyWith(
        products: shuffledProducts,
        productPages: pages,
        pageIndex: 0,
      );
    });
  }

  void increment() {
    if (_state.pageIndex < _state.productPages.length - 1) {
      setState(() {
        _state = _state.copyWith(pageIndex: _state.pageIndex + 1);
      });
    }
  }

  void decrement() {
    if (_state.pageIndex > 0) {
      setState(() {
        _state = _state.copyWith(pageIndex: _state.pageIndex - 1);
      });
    }
  }

  void updateState(ProductState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  void initState() {
    super.initState();
    _state = _initProducts();
  }

  @override
  Widget build(BuildContext context) {
    return ProductProvider(
      state: _state,
      updateState: updateState,
      refresh: refresh,
      increment: increment,
      decrement: decrement,
      child: widget.child,
    );
  }
}
