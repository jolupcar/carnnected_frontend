import 'package:flutter/material.dart';

class CountPurchase with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increase() {
    _count++;
    notifyListeners();
  }

  void decrease() {
    _count--;
    notifyListeners();
  }
}

class MyCart with ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  int get totalPrice => items.fold(0, (total, current) => total + current.price);

  void add(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }
}

class CartItem {
  final String itemList;
  final String name;
  final int price;

  CartItem(this.itemList, this.name, this.price);
}