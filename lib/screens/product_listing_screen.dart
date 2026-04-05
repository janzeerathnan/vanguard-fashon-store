import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _sortBy = 'Popular';
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<String> _categories = ['All', 'Dresses', 'Tops', 'Shoes', 'Bags'];
  final List<String> _sortOptions = [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
    'Rating'
  ];

  List<Product> get _filtered {
    var list = sampleProducts.where((p) {
      final matchesCat =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQ = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.brand.toLowerCase().contains(_query.toLowerCase());
      return matchesCat && matchesQ;
    }).toList();

    switch (_sortBy) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        list = list.where((p) => p.isNew).toList() +
            list.where((p) => !p.isNew).toList();
        break;
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'All';
    if (_selectedCategory == 'All' && category != 'All') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedCategory = category);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            Text('Shop', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search products...',
                filled: true,
                fillColor: AppColors.surface,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textMuted, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.textMuted, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Sort + Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final sel = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.accent : AppColors.surface,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color:
                                    sel ? AppColors.accent : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight:
                                    sel ? FontWeight.w600 : FontWeight.w400,
                                color: sel
                                    ? AppColors.background
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Sort dropdown
                GestureDetector(
                  onTap: () => _showSortSheet(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded,
                            color: AppColors.accent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Sort',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Result count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} results',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  _sortBy,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Product Grid / List
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : _isGridView
                    ? _buildGrid()
                    : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) => ProductCard(product: _filtered[i]),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) {
        final p = _filtered[i];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: p),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider, width: 0.8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.network(
                    p.imageUrl,
                    width: 110,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 110,
                      height: 130,
                      color: AppColors.surface,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.brand,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                              letterSpacing: 0.5,
                            )),
                        const SizedBox(height: 4),
                        Text(p.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Text('${p.rating}',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            const SizedBox(width: 4),
                            Text('(${p.reviewCount})',
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${p.price.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: AppColors.background,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text('No products found',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Try a different search or category',
              style:
                  GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Sort By',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ..._sortOptions.map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    setState(() => _sortBy = opt);
                    Navigator.pop(context);
                  },
                  title: Text(opt,
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          color: _sortBy == opt
                              ? AppColors.accent
                              : AppColors.textPrimary,
                          fontWeight: _sortBy == opt
                              ? FontWeight.w600
                              : FontWeight.w400)),
                  trailing: _sortBy == opt
                      ? const Icon(Icons.check_rounded, color: AppColors.accent)
                      : null,
                )),
          ],
        ),
      ),
    );
  }
}
