import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function(dynamic) onAddToCart;
  final Function(dynamic) onRemoveFromCart;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Yerel kopya — butonlara basınca hem bu hem global güncellenir
  late List<CartItem> _localCart;

  @override
  void initState() {
    super.initState();
    _localCart = _copyCart(widget.cart);
  }

  // ── Yardımcı: CartItem listesini derin kopyala ────────────────────
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

  // ── Adet artır ────────────────────────────────────────────────────
  void _increase(CartItem item) {
    // Global state'i güncelle
    widget.onAddToCart(item);
    // Yerel state'i anında güncelle
    setState(() {
      final idx =
          _localCart.indexWhere((c) => c.productId == item.productId);
      if (idx != -1) {
        _localCart[idx] = CartItem(
          productId: item.productId,
          productName: item.productName,
          productCategory: item.productCategory,
          productPrice: item.productPrice,
          productImageUrl: item.productImageUrl,
          quantity: _localCart[idx].quantity + 1,
        );
      }
    });
  }

  // ── Adet azalt / sil ──────────────────────────────────────────────
  void _decrease(CartItem item) {
    widget.onRemoveFromCart(item);
    setState(() {
      final idx =
          _localCart.indexWhere((c) => c.productId == item.productId);
      if (idx != -1) {
        if (_localCart[idx].quantity > 1) {
          _localCart[idx] = CartItem(
            productId: item.productId,
            productName: item.productName,
            productCategory: item.productCategory,
            productPrice: item.productPrice,
            productImageUrl: item.productImageUrl,
            quantity: _localCart[idx].quantity - 1,
          );
        } else {
          _localCart.removeAt(idx);
        }
      }
    });
  }

  double get _total =>
      _localCart.fold(0, (sum, i) => sum + i.productPrice * i.quantity);

  int get _totalQty =>
      _localCart.fold(0, (sum, i) => sum + i.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _localCart.isEmpty
                  ? _buildEmptyCart()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount: _localCart.length,
                      itemBuilder: (_, i) => _buildCartItem(_localCart[i]),
                    ),
            ),
            _buildCheckoutBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
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
          const SizedBox(width: 4),
          const Text('Cart',
              style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              )),
          const Spacer(),
          if (_localCart.isNotEmpty)
            Text('$_totalQty ürün',
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: Row(
        children: [
          // Görsel
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 70, height: 70,
              color: const Color(0xFFF5F5F7),
              child: Image.network(
                item.productImageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.image_outlined, color: Colors.grey[300], size: 30),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Bilgiler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(item.productCategory,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                const SizedBox(height: 6),
                Text(
                  '\$${(item.productPrice * item.quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),

          // +/- kontrol
          Column(
            children: [
              GestureDetector(
                onTap: () => _increase(item),
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(height: 4),
              Text('${item.quantity}',
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  )),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _decrease(item),
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: item.quantity > 1 ? Colors.grey[100] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                    color: item.quantity > 1 ? Colors.grey[600] : Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              )),
          const SizedBox(height: 8),
          Text('Add items to start shopping',
              style: TextStyle(fontSize: 13, color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16, offset: const Offset(0, -4),
        )],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Toplam ($_totalQty ürün)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              Text('\$${_total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  )),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (_localCart.isEmpty) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sipariş simülasyonu tamamlandı! 🎉'),
                  backgroundColor: Color(0xFF1A1A2E),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: _localCart.isEmpty
                    ? Colors.grey[300]
                    : const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('Checkout',
                  style: TextStyle(
                    color: _localCart.isEmpty ? Colors.grey[400] : Colors.white,
                    fontWeight: FontWeight.w600, fontSize: 15,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
