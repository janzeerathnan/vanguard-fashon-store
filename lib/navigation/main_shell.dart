import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../screens/home_screen.dart';
import '../screens/product_listing_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductListingScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _StitchBottomNav(
        currentIndex: _currentIndex,
        cartCount: CartProvider.instance.itemCount,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _StitchBottomNav extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _StitchBottomNav({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home_rounded,
        'label': 'Home'
      },
      {
        'icon': Icons.grid_view_outlined,
        'activeIcon': Icons.grid_view_rounded,
        'label': 'Shop'
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'activeIcon': Icons.shopping_bag_rounded,
        'label': 'Cart'
      },
      {
        'icon': Icons.person_outline_rounded,
        'activeIcon': Icons.person_rounded,
        'label': 'Profile'
      },
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border:
            const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isSelected = currentIndex == i;
            final isCart = i == 2;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          width: isSelected ? 52 : 44,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              isSelected
                                  ? item['activeIcon'] as IconData
                                  : item['icon'] as IconData,
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.textMuted,
                              size: isSelected ? 24 : 22,
                            ),
                          ),
                        ),
                        // Cart badge
                        if (isCart && cartCount > 0)
                          Positioned(
                            top: -4,
                            right: -2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  cartCount > 9 ? '9+' : '$cartCount',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.inter(
                        fontSize: isSelected ? 11 : 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color:
                            isSelected ? AppColors.accent : AppColors.textMuted,
                      ),
                      child: Text(item['label'] as String),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
