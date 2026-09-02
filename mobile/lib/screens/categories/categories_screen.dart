import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/category_model.dart';
import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../cart/cart_screen.dart';
import '../products/category_products_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;
  bool _isLoading = true;
  List<CategoryModel> _apiCategories = [];
  String _searchQuery = '';

  // Rich category catalog matching the visual mockup and API
  final List<Map<String, dynamic>> _catalogItems = [
    {
      'id': 0,
      'name': 'All Categories',
      'icon': Icons.grid_view_rounded,
      'emoji': '✨',
      'itemsCount': '1,450 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 1,
      'name': 'Electronics',
      'icon': Icons.phone_iphone_rounded,
      'emoji': '📱',
      'itemsCount': '245 Items',
      'imageUrl': 'https://phonesstorekenya.com/product/apple-iphone-14-pro/?srsltid=AfmBOooM0c3o88hH8N2N44z0gZsB0CjEWmwPPuRorbVmqgD18pCt9xfB',
    },
    {
      'id': 2,
      'name': 'Laptops & Computers',
      'icon': Icons.laptop_mac_rounded,
      'emoji': '💻',
      'itemsCount': '128 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 3,
      'name': 'Fashion',
      'icon': Icons.checkroom_rounded,
      'emoji': '👗',
      'itemsCount': '362 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 4,
      'name': 'Shoes',
      'icon': Icons.snowshoeing_rounded,
      'emoji': '👟',
      'itemsCount': '158 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 5,
      'name': 'Beauty',
      'icon': Icons.brush_rounded,
      'emoji': '💄',
      'itemsCount': '214 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 6,
      'name': 'Home & Kitchen',
      'icon': Icons.chair_rounded,
      'emoji': '🛋️',
      'itemsCount': '276 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 7,
      'name': 'Sports',
      'icon': Icons.sports_basketball_rounded,
      'emoji': '🏀',
      'itemsCount': '189 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 8,
      'name': 'Books',
      'icon': Icons.menu_book_rounded,
      'emoji': '📚',
      'itemsCount': '132 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 9,
      'name': 'Accessories',
      'icon': Icons.watch_outlined,
      'emoji': '👜',
      'itemsCount': '95 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=80',
    },
    {
      'id': 10,
      'name': 'Toys & Games',
      'icon': Icons.sports_esports_rounded,
      'emoji': '🎮',
      'itemsCount': '112 Items',
      'imageUrl': 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=400&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _apiService.getCategories();
      if (mounted && categories.isNotEmpty) {
        setState(() {
          _apiCategories = categories;
        });
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayCategories = [];

    if (_apiCategories.isNotEmpty) {
      displayCategories.add({
        'id': 0,
        'name': 'All Categories',
        'icon': Icons.grid_view_rounded,
        'emoji': '✨',
        'itemsCount': '${_apiCategories.length * 15} Items',
        'imageUrl': 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=400&auto=format&fit=crop&q=80',
      });

      for (var cat in _apiCategories) {
        final match = _catalogItems.firstWhere(
          (c) => c['name'].toString().toLowerCase() == cat.name.toLowerCase(),
          orElse: () => {
            'icon': Icons.category_rounded,
            'emoji': '📦',
            'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=80',
          },
        );

        displayCategories.add({
          'id': cat.id,
          'name': cat.name,
          'icon': match['icon'] ?? Icons.category_rounded,
          'emoji': match['emoji'] ?? '📦',
          'itemsCount': '${(cat.productsCount != null && cat.productsCount! > 0) ? cat.productsCount : 5} Items',
          'imageUrl': cat.imageUrl ?? match['imageUrl'],
          'model': cat,
        });
      }
    } else {
      displayCategories.addAll(_catalogItems);
    }

    final filteredCategories = displayCategories.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final sidebarCategories = filteredCategories.isNotEmpty ? filteredCategories : displayCategories;

    final gridItems = _selectedCategoryIndex == 0
        ? sidebarCategories.where((c) => c['id'] != 0).toList()
        : sidebarCategories.where((c) => c['id'] == displayCategories[_selectedCategoryIndex]['id']).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Categories',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(showBackButton: true),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined, size: 26, color: Color(0xFF1F2937)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Consumer<CartProvider>(
                          builder: (context, cart, _) {
                            if (cart.itemCount <= 0) return const SizedBox.shrink();
                            return Container(
                              width: 18,
                              height: 18,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 8),
                      child: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'Search categories...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF94A3B8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 168,
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 20),
                            itemCount: sidebarCategories.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = sidebarCategories[index];
                              final isSelected = _selectedCategoryIndex == index ||
                                  (_selectedCategoryIndex == 0 && index == 0) ||
                                  (item['id'] == displayCategories[_selectedCategoryIndex]['id'] && _selectedCategoryIndex != 0);

                              final categoryName = item['name'] as String;
                              final categoryIcon = item['icon'] as IconData? ?? Icons.category_rounded;
                              final iconColors = [
                                const Color(0xFFFB923C),
                                const Color(0xFF2DD4BF),
                                const Color(0xFF60A5FA),
                                const Color(0xFFA78BFA),
                                const Color(0xFFF472B6),
                                const Color(0xFF34D399),
                                const Color(0xFFF59E0B),
                                const Color(0xFF22C55E),
                                const Color(0xFF8B5CF6),
                              ];
                              final color = iconColors[index % iconColors.length];

                              return InkWell(
                                onTap: () {
                                  final selectedIndex = displayCategories.indexWhere((c) => c['id'] == item['id']);
                                  setState(() => _selectedCategoryIndex = selectedIndex >= 0 ? selectedIndex : 0);
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  height: 54,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFFDE7DC) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected
                                        ? const Border(left: BorderSide(color: AppColors.primary, width: 4))
                                        : const Border(left: BorderSide(color: Colors.transparent, width: 4)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFFFFE4D6) : const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(categoryIcon, size: 18, color: isSelected ? AppColors.primary : color),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          categoryName,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: isSelected ? const Color(0xFF1F2937) : const Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: gridItems.isEmpty
                                ? _buildEmptyView()
                                : GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: gridItems.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.9,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                    ),
                                    itemBuilder: (context, index) {
                                      return _buildCategoryCard(gridItems[index]);
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              height: 74,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomItem(Icons.home_outlined, 'Home', false),
                  _buildBottomItem(Icons.widgets_rounded, 'Categories', true),
                  _buildBottomItem(Icons.shopping_cart_outlined, 'Cart', false),
                  _buildBottomItem(Icons.favorite_border_rounded, 'Wishlist', false),
                  _buildBottomItem(Icons.person_outline_rounded, 'Account', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26, color: active ? AppColors.primary : const Color(0xFF64748B)),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? AppColors.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        CategoryModel? model;
        if (item['model'] is CategoryModel) {
          model = item['model'] as CategoryModel;
        } else {
          model = CategoryModel(
            id: item['id'] as int,
            name: item['name'] as String,
            slug: (item['name'] as String).toLowerCase().replaceAll(' ', '-'),
            productsCount: int.tryParse(item['itemsCount'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 5,
            image: item['imageUrl'],
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              category: model,
              title: item['name'] as String,
              emoji: item['emoji'] as String?,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  color: const Color(0xFFF4F6F8),
                  child: Image.network(
                    item['imageUrl'] ?? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(item['icon'] as IconData? ?? Icons.category_rounded, size: 44, color: AppColors.primaryLight),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              child: Text(
                item['name'],
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item['itemsCount'] ?? '5 Items',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 14),
            Text(
              'No Categories Found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try searching for another category keyword.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
