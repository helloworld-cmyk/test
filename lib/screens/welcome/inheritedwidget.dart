import 'package:flutter/material.dart';
import 'package:first_app/screens/welcome/state.dart';

class ProductProvider extends InheritedWidget {
  final ProductState state;
  final void Function(ProductState newState) updateState;
  final Future<void> Function() refresh;
  final VoidCallback increment;
  final VoidCallback decrement;

  const ProductProvider({
    super.key,
    required this.state,
    required this.updateState,
    required this.refresh,
    required this.increment,
    required this.decrement,
    required super.child,
  });

  static ProductProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ProductProvider>();
    assert(provider != null, 'ProductProvider not found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(ProductProvider oldWidget) {
    return oldWidget.state != state;
  }
}
