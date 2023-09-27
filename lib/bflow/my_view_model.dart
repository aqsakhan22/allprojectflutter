import 'package:flutter/material.dart';

enum ViewState { idle, busy }

class MyViewModel extends ChangeNotifier {
  var _state = ViewState.idle;
  var _paginatedState = ViewState.idle;
  var _reportsState = ViewState.idle;
  var _searchState = ViewState.idle;

  ViewState get getState => _state;

  ViewState get getReportsState => _reportsState;

  ViewState get getPaginatedState => _paginatedState;

  ViewState get getSearchState => _searchState;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setReportsState(ViewState viewState) {
    _reportsState = viewState;
    notifyListeners();
  }

  void paginatedState(ViewState viewState) {
    _paginatedState = viewState;
    notifyListeners();
  }

  void setSearchState(ViewState viewState) {
    _searchState = viewState;
    notifyListeners();
  }
}
