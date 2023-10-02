import 'package:flutter/cupertino.dart';

enum ViewState { idle, busy }
class MyViewModel extends ChangeNotifier{
  var state = ViewState.idle;
  // var _searchState = ViewState.idle;
  // ViewState get getSearchState => _searchState;
  void setState(ViewState viewState) {
    print("View state value is ${viewState}");
    state = viewState;
     notifyListeners();
  }

}