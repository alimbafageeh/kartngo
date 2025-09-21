import 'package:flutter/foundation.dart';
import '../models/item.dart';

class CartViewModel extends ChangeNotifier {
  final Map<Item, int> _cartItems = {};

  Map<Item, int> get cartItems => _cartItems;

  void addItem(Item item) {
    if (_cartItems.containsKey(item)) {
      _cartItems[item] = _cartItems[item]! + 1;
    } else {
      _cartItems[item] = 1;
    }
    notifyListeners();
  }

  void removeItem(Item item) {
    if (_cartItems.containsKey(item) && _cartItems[item]! > 0) {
      _cartItems[item] = _cartItems[item]! - 1;
      if (_cartItems[item] == 0) {
        _cartItems.remove(item);
      }
      notifyListeners();
    }
  }

  int getItemQuantity(Item item) {
    return _cartItems[item] ?? 0;
  }

  int get totalItems {
    return _cartItems.values.fold(0, (sum, qty) => sum + qty);
  }

  double get totalPrice {
    return _cartItems.entries
        .fold(0, (sum, entry) => sum + entry.key.price * entry.value);
  }
}
