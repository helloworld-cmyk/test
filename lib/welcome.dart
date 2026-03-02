import 'dart:math';

import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String price;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

const List<Product> allProducts = [
  Product(
    id: 1,
    name: 'Tai nghe Bluetooth',
    price: '590.000đ',
    image: 'https://picsum.photos/seed/p1/480/320',
  ),
  Product(
    id: 2,
    name: 'Bàn phím cơ',
    price: '1.290.000đ',
    image: 'https://picsum.photos/seed/p2/480/320',
  ),
  Product(
    id: 3,
    name: 'Chuột không dây',
    price: '420.000đ',
    image: 'https://picsum.photos/seed/p3/480/320',
  ),
  Product(
    id: 4,
    name: 'Màn hình 24 inch',
    price: '3.450.000đ',
    image: 'https://picsum.photos/seed/p4/480/320',
  ),
  Product(
    id: 5,
    name: 'Webcam HD',
    price: '790.000đ',
    image: 'https://picsum.photos/seed/p5/480/320',
  ),
  Product(
    id: 6,
    name: 'Giá đỡ laptop',
    price: '350.000đ',
    image: 'https://picsum.photos/seed/p6/480/320',
  ),
  Product(
    id: 7,
    name: 'Sạc nhanh 65W',
    price: '490.000đ',
    image: 'https://picsum.photos/seed/p7/480/320',
  ),
  Product(
    id: 8,
    name: 'Loa mini',
    price: '560.000đ',
    image: 'https://picsum.photos/seed/p8/480/320',
  ),
  Product(
    id: 9,
    name: 'Ổ cứng SSD 1TB',
    price: '1.890.000đ',
    image: 'https://picsum.photos/seed/p9/480/320',
  ),
  Product(
    id: 10,
    name: 'Đèn bàn LED',
    price: '310.000đ',
    image: 'https://picsum.photos/seed/p10/480/320',
  ),
];

const int itemsPerPage = 3;

class AllProductItem extends StatefulWidget {
  const AllProductItem({super.key});

  @override
  State<AllProductItem> createState() => _AllProductItemState();
}

class _AllProductItemState extends State<AllProductItem> {
  late List<Product> _sourceProducts;
  List<List<Product>> _productPages = [];
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
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

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      _sourceProducts.shuffle();
      _rebuildPages();
      _pageIndex = 0;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = _productPages.length;
    final currentPageProducts = _productPages[_pageIndex];

    return RefreshIndicator(
      onRefresh: _onRefresh,
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
                onPressed: _pageIndex > 0
                    ? () => _onPageChanged(_pageIndex - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Page ${_pageIndex + 1}/$pageCount'),
              IconButton(
                onPressed: _pageIndex < pageCount - 1
                    ? () => _onPageChanged(_pageIndex + 1)
                    : null,
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
