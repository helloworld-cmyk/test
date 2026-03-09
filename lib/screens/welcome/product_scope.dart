import 'dart:math';

import 'package:flutter/widgets.dart';

import 'product.dart';

class ProductController extends ChangeNotifier {
  late List<Product> _sourceProducts;
  late List<List<Product>> _productPages;
  int _pageIndex = 0;

  ProductController() {
    _sourceProducts = List<Product>.from(allProducts);
    _rebuildPages();
  }

  void _rebuildPages() {
    final pageCount = (_sourceProducts.length / itemsPerPage).ceil();
    _productPages = List<List<Product>>.generate(pageCount, (index) {
      final start = index * itemsPerPage;
      final end = min(start + itemsPerPage, _sourceProducts.length);
      return _sourceProducts.sublist(start, end);
    });
  }

  int get pageIndex => _pageIndex;

  int get pageCount => _productPages.length;

  List<Product> get currentPageProducts =>
      _productPages.isEmpty ? <Product>[] : _productPages[_pageIndex];

  bool get canGoPrevious => _pageIndex > 0;

  bool get canGoNext => _pageIndex < pageCount - 1;

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _sourceProducts.shuffle();
    _rebuildPages();
    _pageIndex = 0;
    notifyListeners();
  }

  void incrementPage() {
    if (!canGoNext) return;
    _pageIndex++;
    notifyListeners();
  }

  void decrementPage() {
    if (!canGoPrevious) return;
    _pageIndex--;
    notifyListeners();
  }
}

class _ProductInherited extends InheritedNotifier<ProductController> {
  const _ProductInherited({
    required ProductController notifier,
    required Widget child,
    super.key,
  }) : super(notifier: notifier, child: child);
}

class ProductScope extends StatefulWidget {
  final Widget child;

  const ProductScope({super.key, required this.child});

  static ProductController of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ProductInherited>();
    assert(inherited != null, 'No ProductScope found in context');
    return inherited!.notifier!;
  }

  @override
  State<ProductScope> createState() => _ProductScopeState();
}

class _ProductScopeState extends State<ProductScope> {
  late final ProductController _controller = ProductController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProductInherited(
      notifier: _controller,
      child: widget.child,
    );
  }
}

