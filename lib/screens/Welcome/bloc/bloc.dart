import 'event.dart';
import 'state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../product.dart';
class ProductBloc extends Bloc<ProductEvent, ProductState>{
  ProductBloc(): super(ProductState()){
    on<initialLoad>((event, emit) {
      final List<Product> products = List<Product>.from(allProducts);
      final pageCount = (products.length / itemsPerPage).ceil();
      final List<List<Product>> productPages = List<List<Product>>.generate(pageCount, (index) {
        final start = index * itemsPerPage;
        final end = start + itemsPerPage;
        return products.sublist(start, end > products.length ? products.length : end);
      });
      emit(state.copyWith(products: products, productPages: productPages));
    });

    on<RefreshProducts>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 1));
      final List<Product> products = List<Product>.from(allProducts)..shuffle();
      final pageCount = (products.length / itemsPerPage).ceil();
      final List<List<Product>> productPages = List<List<Product>>.generate(pageCount, (index) {
        final start = index * itemsPerPage;
        final end = start + itemsPerPage;
        return products.sublist(start, end > products.length ? products.length : end);
      });
      emit(state.copyWith(products: products, productPages: productPages, pageIndex: 0));
    });

    on<IncrementPage>((event, emit) {
      if (state.pageIndex < state.productPages.length - 1) {
        emit(state.copyWith(pageIndex: state.pageIndex + 1));
      }
    });

    on<DecrementPage>((event, emit) {
      if (state.pageIndex > 0) {
        emit(state.copyWith(pageIndex: state.pageIndex - 1));
      }
    });
  }
}
