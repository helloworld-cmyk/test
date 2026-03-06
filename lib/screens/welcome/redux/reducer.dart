import 'action.dart';
import 'state.dart';
import '../product.dart';


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


ProductState productReducer(ProductState state, dynamic action) {
  if (action is ProductInitAction){
    final List<Product> products = List<Product>.from(allProducts);
    return _buildPagedState(products);
  }
  if (action is ProductReloadAction){
    final List<Product> products = List<Product>.from(allProducts)..shuffle();
    return _buildPagedState(products);
  }
  if (action is ProductIncrementAction){
    final nextPageIndex = state.pageIndex + 1;
    if (nextPageIndex < state.productPages.length) {
      return state.copyWith(pageIndex: nextPageIndex);
    }
  }
  if (action is ProductDecrementAction){
    final prevPageIndex = state.pageIndex - 1;
    if (prevPageIndex >= 0) {
      return state.copyWith(pageIndex: prevPageIndex);
    }
  }
  return state;
}