import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity + 1,
          price: existing.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void changeQuantity(String productId, direction) {
    if (direction == 0) {
      _items.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity + 1,
          price: existing.price,
        ),
      );
    } else {
      if (_items[productId].quantity > 1 && direction == 1) {
        _items.update(
          productId,
          (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            quantity: existing.quantity - 1,
            price: existing.price,
          ),
        );
      } else {
        removeItem(productId);
      }
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
