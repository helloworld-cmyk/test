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


