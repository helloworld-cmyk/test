import '../product.dart';

class ProductState{
  final List<Product> products;
  final int pageIndex;
  final List<List<Product>> productPages;


  const ProductState({
    this.products = const [],
    this.pageIndex = 0,
    this.productPages = const [],
  });

  ProductState copyWith({
    List<Product>? products,
    int? pageIndex,
    List<List<Product>>? productPages,
  }) {
    return ProductState(
      products: products ?? this.products,
      pageIndex: pageIndex ?? this.pageIndex,
      productPages: productPages ?? this.productPages,
    );
  }
}