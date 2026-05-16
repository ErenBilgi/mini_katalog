// Sepet öğesi modeli — ürün + adet
class CartItem {
  final int productId;
  final String productName;
  final String productCategory;
  final double productPrice;
  final String productImageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productPrice,
    required this.productImageUrl,
    this.quantity = 1,
  });

  // SharedPreferences için JSON dönüşümleri
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'productCategory': productCategory,
        'productPrice': productPrice,
        'productImageUrl': productImageUrl,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'],
        productName: json['productName'],
        productCategory: json['productCategory'],
        productPrice: (json['productPrice'] as num).toDouble(),
        productImageUrl: json['productImageUrl'],
        quantity: json['quantity'] ?? 1,
      );
}
