import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<CartItem> cart;
  final List<int> favorites;
  final Function(dynamic) onAddToCart;
  final Function(dynamic) onRemoveFromCart;
  final Function(int) onToggleFavorite;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cart,
    required this.favorites,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onToggleFavorite,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Yerel kopyalar — anında güncelleme için
  late List<CartItem> _localCart;
  late List<int> _localFavorites;

  @override
  void initState() {
    super.initState();
    _localCart = _copyCart(widget.cart);
    _localFavorites = List<int>.from(widget.favorites);
  }

  List<CartItem> _copyCart(List<CartItem> source) {
    return source.map((item) => CartItem(
          productId: item.productId,
          productName: item.productName,
          productCategory: item.productCategory,
          productPrice: item.productPrice,
          productImageUrl: item.productImageUrl,
          quantity: item.quantity,
        )).toList();
  }

  // ── Sepet işlemleri ───────────────────────────────────────────────

  void _addToCart(Product p) {
    widget.onAddToCart(p); // global
    setState(() {          // yerel
      final idx = _localCart.indexWhere((c) => c.productId == p.id);
      if (idx != -1) {
        _localCart[idx] = CartItem(
          productId: p.id, productName: p.name,
          productCategory: p.category, productPrice: p.price,
          productImageUrl: p.imageUrl,
          quantity: _localCart[idx].quantity + 1,
        );
      } else {
        _localCart.add(CartItem(
          productId: p.id, productName: p.name,
          productCategory: p.category, productPrice: p.price,
          productImageUrl: p.imageUrl,
        ));
      }
    });
  }

  void _removeFromCart(Product p) {
    widget.onRemoveFromCart(p); // global
    setState(() {               // yerel
      final idx = _localCart.indexWhere((c) => c.productId == p.id);
      if (idx != -1) {
        if (_localCart[idx].quantity > 1) {
          _localCart[idx] = CartItem(
            productId: p.id, productName: p.name,
            productCategory: p.category, productPrice: p.price,
            productImageUrl: p.imageUrl,
            quantity: _localCart[idx].quantity - 1,
          );
        } else {
          _localCart.removeAt(idx);
        }
      }
    });
  }

  // ── Favori işlemi ─────────────────────────────────────────────────

  void _toggleFavorite(int id) {
    widget.onToggleFavorite(id); // global
    setState(() {                // yerel
      if (_localFavorites.contains(id)) {
        _localFavorites.remove(id);
      } else {
        _localFavorites.add(id);
      }
    });
  }

  // ── Hesaplanan değerler ───────────────────────────────────────────

  bool get _isInCart =>
      _localCart.any((item) => item.productId == widget.product.id);

  bool get _isFavorite =>
      _localFavorites.contains(widget.product.id);

  int get _cartQty {
    final idx =
        _localCart.indexWhere((item) => item.productId == widget.product.id);
    return idx != -1 ? _localCart[idx].quantity : 0;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(product),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.category,
                                  style: TextStyle(
                                    fontSize: 13, color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  )),
                              // Favori butonu
                              GestureDetector(
                                onTap: () => _toggleFavorite(product.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _isFavorite
                                        ? Colors.red[50]
                                        : Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorite
                                        ? Colors.red
                                        : Colors.grey[500],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(product.name,
                              style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E), letterSpacing: -0.5,
                              )),
                          const SizedBox(height: 16),
                          const Text('Description',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              )),
                          const SizedBox(height: 8),
                          Text(product.description,
                              style: TextStyle(
                                fontSize: 14, color: Colors.grey[600],
                                height: 1.6,
                              )),
                          const SizedBox(height: 20),
                          const Text('Specifications',
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              )),
                          const SizedBox(height: 12),
                          _buildSpecRow('Size', product.size),
                          const Divider(height: 1),
                          _buildSpecRow('Audio', product.audio),
                          const Divider(height: 1),
                          _buildSpecRow('Colors', product.colors),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(product),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Color(0xFF1A1A2E)),
            ),
          ),
          const Spacer(),
          Text('Back',
              style: TextStyle(
                fontSize: 14, color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      height: 280, color: const Color(0xFFF5F5F7),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Image.network(
          product.imageUrl, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.image_outlined, size: 80, color: Colors.grey[300]),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          Text(value,
              style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16, offset: const Offset(0, -4),
        )],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fiyat',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              Text('\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  )),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isInCart
                ? _buildQuantityControl(product)
                : GestureDetector(
                    onTap: () => _addToCart(product),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Sepete Ekle',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 15,
                              )),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _removeFromCart(product),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 18),
            ),
          ),
          Text('$_cartQty adet',
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15,
              )),
          GestureDetector(
            onTap: () => _addToCart(product),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
