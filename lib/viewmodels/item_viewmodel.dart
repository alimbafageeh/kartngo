import 'package:flutter/material.dart';
import '../models/item.dart';
import '../data/database_helper.dart';

class ItemViewModel extends ChangeNotifier {
  List<Item> _items = [];
  bool _isLoaded = false; // prevent infinite reload
  List<Item> get items => _items;

  Future<void> loadItems() async {
    if (_isLoaded) return;
    _isLoaded = true;

    _items = await DatabaseHelper.instance.fetchItems();

    if (_items.isEmpty) {
      await _insertDefaultItems();
      _items = await DatabaseHelper.instance.fetchItems();
    }
    await DatabaseHelper.instance.seedDemoItems();
    _items = await DatabaseHelper.instance.fetchItems();

    notifyListeners();
  }

  Future<void> _insertDefaultItems() async {
    final defaults = [
      Item(name: "Double Whopper", price: 29.57, image: "assets/double_whooper.png", category: "أفضل العروض"),
      Item(name: "Steakhouse XL", price: 35.65, image: "assets/steak_house_xl.png", category: "أفضل العروض"),
      Item(name: "Chicken Steakhouse", price: 37.39, image: "assets/chicken_steakhouse.png", category: "أفضل العروض"),
      Item(name: "Steakhouse", price: 30.43, image: "assets/steak_house_xl.png", category: "أفضل العروض"),
      Item(name: "Bacon", price: 35.99, image: "assets/bacon.png", category: "أفضل العروض"),
      Item(name: "Big King", price: 30.13, image: "assets/big_king.png", category: "أفضل العروض"),
      Item(name: "Flame Grill", price: 19.99, image: "assets/flame_grill.png", category: "أفضل العروض"),
      Item(name: "Texas", price: 32.97, image: "assets/texas.png", category: "أفضل العروض"),
    ];

    for (var item in defaults) {
      await DatabaseHelper.instance.insertItem(item);
    }
  }

}
