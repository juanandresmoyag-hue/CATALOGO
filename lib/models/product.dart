class Product {
  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final category = json['category'];
    final price = json['price'];
    final description = json['description'];

    if (name is! String ||
        category is! String ||
        price is! num ||
        description is! String) {
      throw const FormatException('Registro de producto inválido.');
    }

    return Product(
      name: name,
      category: category,
      price: price.toDouble(),
      description: description,
    );
  }

  final String name;
  final String category;
  final double price;
  final String description;
}

const productCategories = [
  'Desktop',
  'Laptop',
  'Otros',
  'Impresora',
  'Monitor',
  'Mouse',
  'Teclado',
];
