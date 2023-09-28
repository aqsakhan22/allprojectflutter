import 'package:flutter/cupertino.dart';

enum ViewState { idle, busy }
class MyViewModel extends ChangeNotifier{
  var _state = ViewState.idle;
  var _searchState = ViewState.idle;
  ViewState get getSearchState => _searchState;
  void setState(ViewState viewState) {
    _state = viewState;
    // notifyListeners();
  }

}