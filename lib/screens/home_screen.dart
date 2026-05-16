import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../data/products_data.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_widget.dart';
import '../utils/page_transitions.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

enum SortOption { defaultSort, priceLow, priceHigh }

class HomeScreen extends StatefulWidget {
  final List<CartItem> cart;
  final List<int> favorites;
  final Function(dynamic) onAddToCart;
  final Function(dynamic) onRemoveFromCart;
  final Function(int) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.cart,
    required this.favorites,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onToggleFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _allProducts = getProducts();
  List<Product> _filteredProducts = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';
  SortOption _sortOption = SortOption.defaultSort;
  bool _showFavoritesOnly = false;
  bool _isLoading = true;

  final List<String> _categories = [
    'Tümü', 'Smartphone', 'Kulaklık', 'Bilgisayar',
    'Tablet', 'Ses Sistemi', 'Akıllı Saat',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cart != widget.cart ||
        oldWidget.favorites != widget.favorites) {
      setState(() {});
    }
  }

  void _filterProducts(String query) =>
      setState(() { _searchQuery = query; _applyAll(); });

  void _selectCategory(String cat) =>
      setState(() { _selectedCategory = cat; _applyAll(); });

  void _setSort(SortOption opt) =>
      setState(() { _sortOption = opt; _applyAll(); });

  void _toggleFavoritesFilter() =>
      setState(() { _showFavoritesOnly = !_showFavoritesOnly; _applyAll(); });

  void _applyAll() {
    List<Product> result = _allProducts.where((p) {
      final matchSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCat =
          _selectedCategory == 'Tümü' || p.category == _selectedCategory;
      final matchFav =
          !_showFavoritesOnly || widget.favorites.contains(p.id);
      return matchSearch && matchCat && matchFav;
    }).toList();

    switch (_sortOption) {
      case SortOption.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.defaultSort:
        break;
    }
    _filteredProducts = result;
  }

  void _goToDetail(Product product) {
    Navigator.push(context, SlidePageRoute(
      page: ProductDetailScreen(
        product: product,
        cart: widget.cart,
        favorites: widget.favorites,
        onAddToCart: widget.onAddToCart,
        onRemoveFromCart: widget.onRemoveFromCart,
        onToggleFavorite: widget.onToggleFavorite,
      ),
    ));
  }

  void _goToCart() {
    Navigator.push(context, SlidePageRoute(
      page: CartScreen(
        cart: widget.cart,
        onAddToCart: widget.onAddToCart,
        onRemoveFromCart: widget.onRemoveFromCart,
      ),
    ));
  }

  // Karttaki sepet ikonuna basınca: sepette varsa çıkar, yoksa ekle
  void _cartToggle(Product product) {
    final isInCart = widget.cart.any((i) => i.productId == product.id);
    if (isInCart) {
      widget.onRemoveFromCart(product);
    } else {
      widget.onAddToCart(product);
    }
  }

  int get _totalCartQty =>
      widget.cart.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildSearchAndSort()),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildCategorySelector()),
            SliverToBoxAdapter(child: _buildResultHeader()),
            _isLoading
                ? _buildShimmerGrid()
                : _filteredProducts.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState())
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = _filteredProducts[index];
                              return ProductCard(
                                product: product,
                                cart: widget.cart,
                                favorites: widget.favorites,
                                onTap: () => _goToDetail(product),
                                // Toggle: sepette varsa çıkar, yoksa ekle
                                onAddToCart: () => _cartToggle(product),
                                onToggleFavorite: () =>
                                    widget.onToggleFavorite(product.id),
                              );
                            },
                            childCount: _filteredProducts.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: const Color(0xFFF5F5F7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Discover',
                  style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.5,
                  )),
              Text('Find your perfect device.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
          GestureDetector(
            onTap: _goToCart,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white, size: 22),
                ),
                if (_totalCartQty > 0)
                  Positioned(
                    right: -4, top: -4,
                    child: Container(
                      width: 18, height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30), shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$_totalCartQty',
                            style: const TextStyle(
                              color: Colors.white, fontSize: 10,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8, offset: const Offset(0, 2),
                )],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Search products',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _filterProducts('');
                          },
                          child: Icon(Icons.close,
                              color: Colors.grey[400], size: 18),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _toggleFavoritesFilter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: _showFavoritesOnly ? Colors.red[50] : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8, offset: const Offset(0, 2),
                )],
              ),
              child: Icon(
                _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                color: _showFavoritesOnly ? Colors.red : Colors.grey[500],
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _showSortSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: _sortOption != SortOption.defaultSort
                    ? const Color(0xFF1A1A2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8, offset: const Offset(0, 2),
                )],
              ),
              child: Icon(
                Icons.sort,
                color: _sortOption != SortOption.defaultSort
                    ? Colors.white
                    : Colors.grey[500],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sırala',
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                )),
            const SizedBox(height: 16),
            _sortTile('Varsayılan', SortOption.defaultSort),
            _sortTile('Ucuzdan Pahalıya', SortOption.priceLow),
            _sortTile('Pahalıdan Ucuya', SortOption.priceHigh),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String label, SortOption option) {
    final bool selected = _sortOption == option;
    return GestureDetector(
      onTap: () { _setSort(option); Navigator.pop(context); },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A1A2E) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF1A1A2E),
                )),
            const Spacer(),
            if (selected) const Icon(Icons.check, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(
          color: const Color(0xFF1A1A2E).withOpacity(0.3),
          blurRadius: 16, offset: const Offset(0, 6),
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(right: -20, top: -20,
                child: Container(width: 120, height: 120,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05)))),
            Positioned(right: 30, bottom: -30,
                child: Container(width: 100, height: 100,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05)))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('GIFT STORE',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 10, fontWeight: FontWeight.w600,
                                  letterSpacing: 1)),
                        ),
                        const SizedBox(height: 8),
                        const Text('En İyi\nTeknoloji',
                            style: TextStyle(color: Colors.white, fontSize: 22,
                                fontWeight: FontWeight.w700, height: 1.2)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text('Keşfet →',
                              style: TextStyle(color: Color(0xFF1A1A2E),
                                  fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.devices_other,
                      color: Colors.white24, size: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => _selectCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [if (!isSelected) BoxShadow(
                  color: Colors.black.withOpacity(0.05), blurRadius: 4)],
              ),
              child: Text(cat,
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Text(
            _showFavoritesOnly
                ? '${_filteredProducts.length} Favori'
                : '${_filteredProducts.length} Ürün',
            style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (_sortOption != SortOption.defaultSort) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _sortOption == SortOption.priceLow ? '↑ Fiyat' : '↓ Fiyat',
                style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const ShimmerProductCard(),
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12,
          mainAxisSpacing: 12, childAspectRatio: 0.72,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              _showFavoritesOnly ? Icons.favorite_border : Icons.search_off,
              size: 60, color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              _showFavoritesOnly
                  ? 'Henüz favori eklemedin'
                  : '"$_searchQuery" için sonuç bulunamadı',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
