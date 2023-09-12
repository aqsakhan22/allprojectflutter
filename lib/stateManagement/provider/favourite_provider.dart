import 'package:flutter/foundation.dart';

class FavouriteProvider with ChangeNotifier {
  List _selectedItems = [];

  List get selectedItems => _selectedItems;

  void addItems(int index) {
    _selectedItems.add(index);
    notifyListeners();
  }

  void removeItems(int index) {
    _selectedItems.remove(index);
    notifyListeners();
  }
}
