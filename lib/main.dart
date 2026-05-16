import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/product.dart';
import 'models/cart_item.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CartItem> _cart = [];
  List<int> _favorites = [];
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── SharedPreferences: Yükle ──────────────────────────────────────

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final favJson = prefs.getStringList('favorites') ?? [];
    final cartJson = prefs.getStringList('cart') ?? [];

    setState(() {
      _favorites = favJson.map((e) => int.parse(e)).toList();
      _cart = cartJson.map((e) {
        return CartItem.fromJson(jsonDecode(e) as Map<String, dynamic>);
      }).toList();
      _dataLoaded = true;
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favorites', _favorites.map((id) => id.toString()).toList());
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'cart', _cart.map((item) => jsonEncode(item.toJson())).toList());
  }

  // ── Sepet işlemleri — HER ZAMAN yeni liste referansı üretilir ─────
  // Bu sayede Flutter değişikliği fark edip kartları yeniden çizer.

  void _addToCart(dynamic item) {
    int id;
    String name, category, imageUrl;
    double price;

    if (item is Product) {
      id = item.id; name = item.name; category = item.category;
      imageUrl = item.imageUrl; price = item.price;
    } else if (item is CartItem) {
      id = item.productId; name = item.productName; category = item.productCategory;
      imageUrl = item.productImageUrl; price = item.productPrice;
    } else {
      return;
    }

    // Mevcut listeyi kopyala, değişikliği kopyada yap
    final newCart = List<CartItem>.from(_cart);
    final idx = newCart.indexWhere((c) => c.productId == id);
    if (idx != -1) {
      // Yeni CartItem nesnesi oluştur (mutasyon değil, yeni referans)
      final old = newCart[idx];
      newCart[idx] = CartItem(
        productId: old.productId,
        productName: old.productName,
        productCategory: old.productCategory,
        productPrice: old.productPrice,
        productImageUrl: old.productImageUrl,
        quantity: old.quantity + 1,
      );
    } else {
      newCart.add(CartItem(
        productId: id, productName: name, productCategory: category,
        productPrice: price, productImageUrl: imageUrl,
      ));
    }

    setState(() => _cart = newCart); // yeni referans → Flutter fark eder
    _saveCart();
  }

  void _removeFromCart(dynamic item) {
    int id;
    if (item is Product) {
      id = item.id;
    } else if (item is CartItem) {
      id = item.productId;
    } else {
      return;
    }

    final newCart = List<CartItem>.from(_cart);
    final idx = newCart.indexWhere((c) => c.productId == id);
    if (idx != -1) {
      if (newCart[idx].quantity > 1) {
        final old = newCart[idx];
        newCart[idx] = CartItem(
          productId: old.productId,
          productName: old.productName,
          productCategory: old.productCategory,
          productPrice: old.productPrice,
          productImageUrl: old.productImageUrl,
          quantity: old.quantity - 1,
        );
      } else {
        newCart.removeAt(idx);
      }
    }

    setState(() => _cart = newCart);
    _saveCart();
  }

  // ── Favori işlemleri — yeni liste referansı ───────────────────────

  void _toggleFavorite(int productId) {
    final newFavs = List<int>.from(_favorites);
    if (newFavs.contains(productId)) {
      newFavs.remove(productId);
    } else {
      newFavs.add(productId);
    }
    setState(() => _favorites = newFavs); // yeni referans
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A1A2E)),
        useMaterial3: true,
      ),
      home: !_dataLoaded
          ? const Scaffold(
              backgroundColor: Color(0xFF1A1A2E),
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : HomeScreen(
              cart: _cart,
              favorites: _favorites,
              onAddToCart: _addToCart,
              onRemoveFromCart: _removeFromCart,
              onToggleFavorite: _toggleFavorite,
            ),
    );
  }
}
