class Product {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final String size;
  final String audio;
  final String colors;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.audio,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'],
        size: json['size'] ?? '-',
        audio: json['audio'] ?? '-',
        colors: json['colors'] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'size': size,
        'audio': audio,
        'colors': colors,
      };
}
