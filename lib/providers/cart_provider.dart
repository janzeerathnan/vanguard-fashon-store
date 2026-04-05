import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  String selectedSize;
  String selectedColor;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;
}

/// Simple in-memory cart — a singleton so all screens share state.
class CartProvider {
  CartProvider._();
  static final CartProvider instance = CartProvider._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.totalPrice);

  double get shipping => _items.isEmpty ? 0.0 : 12.99;

  double get total => subtotal + shipping;

  void addItem({
    required Product product,
    required String size,
    required String color,
    int qty = 1,
  }) {
    final existingIndex = _items.indexWhere(
      (i) =>
          i.product.id == product.id &&
          i.selectedSize == size &&
          i.selectedColor == color,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += qty;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: qty,
        selectedSize: size,
        selectedColor: color,
      ));
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  void incrementQty(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
    }
  }

  void decrementQty(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  void clear() => _items.clear();
}
