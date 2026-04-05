import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartProvider _cart = CartProvider.instance;

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;

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
        title: Text('My Cart',
            style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text('Clear Cart',
                        style: GoogleFonts.playfairDisplay(
                            color: AppColors.textPrimary)),
                    content: Text('Remove all items from your cart?',
                        style:
                            GoogleFonts.inter(color: AppColors.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          _cart.clear();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('Clear',
                            style: GoogleFonts.inter(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Clear',
                  style:
                      GoogleFonts.inter(color: AppColors.error, fontSize: 14)),
            ),
        ],
      ),
      body: items.isEmpty ? _buildEmpty() : _buildCart(items),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.accent, size: 50),
          ),
          const SizedBox(height: 24),
          Text('Your cart is empty',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Add items to get started',
              style:
                  GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (r) => false),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCart(List<CartItem> items) {
    return Column(
      children: [
        // Item count badge
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Text(
                '${_cart.itemCount} item${_cart.itemCount == 1 ? '' : 's'}',
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // Cart items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: items.length,
            itemBuilder: (ctx, i) => _CartItemTile(
              item: items[i],
              onIncrement: () => setState(() => _cart.incrementQty(i)),
              onDecrement: () => setState(() => _cart.decrementQty(i)),
              onRemove: () => setState(() => _cart.removeItem(i)),
            ),
          ),
        ),

        // Summary card
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              _SummaryRow(
                  label: 'Subtotal',
                  value: '\$${_cart.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              _SummaryRow(
                  label: 'Shipping',
                  value: '\$${_cart.shipping.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 10),
              _SummaryRow(
                label: 'Total',
                value: '\$${_cart.total.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Checkout button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              icon: const Icon(Icons.lock_outline_rounded, size: 20),
              label: Text(
                'Proceed to Checkout  ·  \$${_cart.total.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorHex = item.selectedColor;
    Color swatch;
    try {
      swatch = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      swatch = AppColors.accent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.8),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 90,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 90, height: 100, color: AppColors.surface),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.brand,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                        letterSpacing: 0.5)),
                const SizedBox(height: 3),
                Text(item.product.name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text('Size: ${item.selectedSize}',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.divider, width: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent),
                    ),
                    // Stepper
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepBtn(icon: Icons.remove, onTap: onDecrement),
                          SizedBox(
                            width: 28,
                            child: Text('${item.quantity}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                          ),
                          _StepBtn(icon: Icons.add, onTap: onIncrement),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMuted, size: 18),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: AppColors.textSecondary, size: 16),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
