import 'package:flutter/material.dart';

import 'product.dart';
import 'product_scope.dart';

class AllProductItem extends StatelessWidget {
  const AllProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductScope(
      child: Builder(
        builder: (context) {
          final controller = ProductScope.of(context);
          final products = controller.currentPageProducts;
          final pageCount = controller.pageCount;
          final pageIndex = controller.pageIndex;

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Không có sản phẩm')),
                  )
                else
                  ...products.map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ProductItem(product: product),
                    ),
                  ),
                if (pageCount > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: controller.canGoPrevious
                            ? controller.decrementPage
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text('Page ${pageIndex + 1}/$pageCount'),
                      IconButton(
                        onPressed: controller.canGoNext
                            ? controller.incrementPage
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.image,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 92,
                  height: 92,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${product.id}'),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giá: ${product.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final String fullName;
  final String email;

  const WelcomeScreen({super.key, required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Xin chào, $fullName',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            const Expanded(child: AllProductItem()),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

