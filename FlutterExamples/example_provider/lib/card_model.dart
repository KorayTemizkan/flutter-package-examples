import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:example_provider/item_model.dart';

class CardModel extends ChangeNotifier {
  final List<Item> _items =
      []; // Değişken tanımlandıktan sonra değeri değiştirilemez + bu değer çalışma anında da atanabilir.
  // _items'teki _ işareti Dart dilinde "bu sadece bu dosyada kullanılabilir" anlamına gelir

  // Unmodifiable, bu listenin sadece okunabilir olmasını sağlar. Dışarıdan erişilemez ama .add ve .clear çalıştırılabilir.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  int get totalPrice => _items.length * 42;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void test() {
    for (Item item in _items) {
      print(item.name);
      print(item.price.toString());
    }
  }
}
