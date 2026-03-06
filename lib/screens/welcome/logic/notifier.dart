import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state.dart';
import '../product.dart';


final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<ProductState>{
  @override
  ProductState build(){
    final List<Product> products = List<Product>.from(allProducts);
    return _buildPagedState(products);
  }

  void initialLoad(){
    final List<Product> products = List<Product>.from(allProducts);
    state = _buildPagedState(products);
  }

  Future<void> refreshProducts() async{
    await Future<void>.delayed(const Duration(seconds: 1));
    final List<Product> products = List<Product>.from(allProducts)..shuffle();
    state = _buildPagedState(products);
  }

  ProductState _buildPagedState(List<Product> products) {
    final pageCounts = (products.length / itemsPerPage).ceil();
    final List<List<Product>> productPages = List<List<Product>>.generate(pageCounts, (index) {
      final start = index * itemsPerPage;
      final end = start + itemsPerPage;
      return products.sublist(start, end > products.length ? products.length : end);
    });

    return ProductState(
      products: products,
      pageIndex: 0,
      productPages: productPages,
    );
  }

  void incrementPage(){
    if (state.pageIndex < state.productPages.length - 1) {
      state = state.copyWith(pageIndex: state.pageIndex + 1);
    }
  }

  void decrementPage(){
    if (state.pageIndex > 0) {
      state = state.copyWith(pageIndex: state.pageIndex - 1);
    }
  }

}