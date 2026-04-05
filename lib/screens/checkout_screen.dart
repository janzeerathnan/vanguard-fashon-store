import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedPayment = 'card';
  String _selectedAddress = 'home';
  bool _isProcessing = false;

  final _nameController = TextEditingController(text: 'Athnan Kader');
  final _phoneController = TextEditingController(text: '+91 99999 88888');
  final _addressController =
      TextEditingController(text: '42 Marina Beach Road');
  final _cityController = TextEditingController(text: 'Chennai');
  final _zipController = TextEditingController(text: '600001');

  final CartProvider _cart = CartProvider.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Checkout',
            style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),
          const SizedBox(height: 8),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(),
              ),
            ),
          ),

          // Bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Address', 'Payment', 'Review'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: _currentStep > stepIdx
                    ? AppColors.accent
                    : AppColors.divider,
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final isCompleted = _currentStep > stepIdx;
          final isActive = _currentStep == stepIdx;
          return GestureDetector(
            onTap: isCompleted
                ? () => setState(() => _currentStep = stepIdx)
                : null,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? AppColors.accent
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted || isActive
                          ? AppColors.accent
                          : AppColors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            color: AppColors.background, size: 18)
                        : Text(
                            '${stepIdx + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? AppColors.background
                                  : AppColors.textMuted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(steps[stepIdx],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isActive || isCompleted
                          ? AppColors.accent
                          : AppColors.textMuted,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildAddressStep();
      case 1:
        return _buildPaymentStep();
      case 2:
        return _buildReviewStep();
      default:
        return _buildAddressStep();
    }
  }

  Widget _buildAddressStep() {
    return Column(
      key: const ValueKey('address'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Saved Addresses'),
        const SizedBox(height: 14),
        _AddressTile(
          label: 'Home',
          address: '42 Marina Beach Road, Chennai 600001',
          icon: Icons.home_outlined,
          isSelected: _selectedAddress == 'home',
          onTap: () => setState(() => _selectedAddress = 'home'),
        ),
        const SizedBox(height: 10),
        _AddressTile(
          label: 'Work',
          address: '14 Anna Salai, Nungambakkam, Chennai 600006',
          icon: Icons.business_outlined,
          isSelected: _selectedAddress == 'work',
          onTap: () => setState(() => _selectedAddress = 'work'),
        ),
        const SizedBox(height: 28),
        _sectionTitle('Or Enter New Address'),
        const SizedBox(height: 14),
        _buildTextField(
            'Full Name', Icons.person_outline_rounded, _nameController),
        const SizedBox(height: 16),
        _buildTextField('Phone Number', Icons.phone_outlined, _phoneController,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(
            'Street Address', Icons.location_on_outlined, _addressController),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildTextField(
                    'City', Icons.location_city_outlined, _cityController)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildTextField(
                    'ZIP Code', Icons.pin_drop_outlined, _zipController,
                    keyboardType: TextInputType.number)),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      key: const ValueKey('payment'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Payment Method'),
        const SizedBox(height: 14),
        _PaymentTile(
          label: 'Credit / Debit Card',
          subtitle: '**** **** **** 4321',
          icon: Icons.credit_card_rounded,
          isSelected: _selectedPayment == 'card',
          onTap: () => setState(() => _selectedPayment = 'card'),
        ),
        const SizedBox(height: 10),
        _PaymentTile(
          label: 'UPI',
          subtitle: 'athnan@upi',
          icon: Icons.account_balance_wallet_outlined,
          isSelected: _selectedPayment == 'upi',
          onTap: () => setState(() => _selectedPayment = 'upi'),
        ),
        const SizedBox(height: 10),
        _PaymentTile(
          label: 'Cash on Delivery',
          subtitle: 'Pay when delivered',
          icon: Icons.local_shipping_outlined,
          isSelected: _selectedPayment == 'cod',
          onTap: () => setState(() => _selectedPayment = 'cod'),
        ),
        if (_selectedPayment == 'card') ...[
          const SizedBox(height: 28),
          _sectionTitle('Card Details'),
          const SizedBox(height: 14),
          _buildTextField('Card Number', Icons.credit_card_rounded,
              TextEditingController(text: '**** **** **** 4321')),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(
                      'Expiry Date',
                      Icons.calendar_today_outlined,
                      TextEditingController(text: '12/27'))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildTextField('CVV', Icons.lock_outline_rounded,
                      TextEditingController(text: '***'))),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('Cardholder Name', Icons.person_outline_rounded,
              TextEditingController(text: 'Athnan Kader')),
        ],
        const SizedBox(height: 24),
        // Promo code
        _sectionTitle('Promo Code'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Enter promo code',
                  prefixIcon: Icon(Icons.discount_outlined,
                      size: 20, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final items = _cart.items;
    return Column(
      key: const ValueKey('review'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Order Items (${items.length})'),
        const SizedBox(height: 14),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item.product.imageUrl,
                        width: 60,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 60, height: 70, color: AppColors.surface)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                            'Size: ${item.selectedSize}  ·  Qty: ${item.quantity}',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent)),
                ],
              ),
            )),
        const SizedBox(height: 20),
        _sectionTitle('Shipping To'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: AppColors.accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Athnan Kader',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text('42 Marina Beach Road, Chennai 600001',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _sectionTitle('Order Summary'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              _row('Subtotal', '\$${_cart.subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _row('Shipping', '\$${_cart.shipping.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _row('Discount', '-\$0.00'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: AppColors.divider),
              ),
              _row('Total', '\$${_cart.total.toStringAsFixed(2)}',
                  isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isLast = _currentStep == 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _isProcessing
              ? null
              : () {
                  if (isLast) {
                    _placeOrder();
                  } else {
                    setState(() => _currentStep++);
                  }
                },
          child: _isProcessing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: AppColors.background, strokeWidth: 2),
                )
              : Text(
                  isLast
                      ? 'Place Order  ·  \$${_cart.total.toStringAsFixed(2)}'
                      : 'Continue',
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  void _placeOrder() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      _cart.clear();
      setState(() => _isProcessing = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B3B1F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.success, size: 44),
                ),
                const SizedBox(height: 24),
                Text('Order Placed!',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Text(
                  'Your order #STT-2606 has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/home'));
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
      ),
    );
  }

  Widget _row(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
                color:
                    isTotal ? AppColors.textPrimary : AppColors.textSecondary)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: isTotal ? 17 : 13,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: isTotal ? AppColors.accent : AppColors.textPrimary)),
      ],
    );
  }
}

// ─── Reusable Tiles ─────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final String label;
  final String address;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTile({
    required this.label,
    required this.address,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color:
                      isSelected ? AppColors.accent : AppColors.textSecondary,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(address,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accent, size: 22),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color:
                      isSelected ? AppColors.accent : AppColors.textSecondary,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accent, size: 22),
          ],
        ),
      ),
    );
  }
}
