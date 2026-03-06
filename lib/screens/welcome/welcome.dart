import 'package:flutter/material.dart';
import 'product.dart';

import 'package:signals/signals_flutter.dart';
import 'logic/logic.dart';

class AllProductItem extends StatelessWidget {
  const AllProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final state = welcomeLogic.state.value;
      if (state.productPages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final pageCount = state.productPages.length;
      final currentPageProducts = state.productPages[state.pageIndex];

      return RefreshIndicator(
        onRefresh: welcomeLogic.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ...currentPageProducts.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ProductItem(product: product),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: welcomeLogic.decrement,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('Page ${state.pageIndex + 1}/$pageCount'),
                IconButton(
                  onPressed: welcomeLogic.increment,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      );
    });
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
