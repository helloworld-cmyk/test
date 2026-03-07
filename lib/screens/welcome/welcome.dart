import 'package:flutter/material.dart';
import 'state.dart';

class AllProductItem extends StatefulWidget {
  const AllProductItem({super.key});

  @override
  State<AllProductItem> createState() => _AllProductItemState();
}

class _AllProductItemState extends State<AllProductItem> {
  late final AllProductController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AllProductController();
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = _controller.pageCount;
    final currentPageProducts = _controller.currentPageProducts;
    final displayedPage = pageCount == 0 ? 0 : _controller.pageIndex + 1;

    return RefreshIndicator(
      onRefresh: () async {
        await _controller.refreshProducts();
        if (!mounted) {
          return;
        }

        setState(() {});
      },
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
                onPressed: () => setState(_controller.decrementPage),
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Page $displayedPage/$pageCount'),
              IconButton(
                onPressed: () => setState(_controller.incrementPage),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
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
