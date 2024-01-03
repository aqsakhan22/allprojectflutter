import 'package:firebaseflutterproject/graphIntegration/Graph.dart';
import 'package:firebaseflutterproject/graphIntegration/api.dart';
import 'package:flutter/material.dart';


class GraphProvider extends ChangeNotifier {
  String _period = 'daily';
  Future<Graph>? _asyncGraph;
  bool _isDailyPress = false;
  bool _isHistoricalPress = false;
  int _currentIndex = 0;
  final List<String> _titles = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'All Time',
  ];

  String get getPeriod => _period;

  Future<Graph>? get getAsyncGraph => _asyncGraph;

  bool get getDailyPress => _isDailyPress;

  bool get getHistoricalPress => _isHistoricalPress;

  List<String> get getTitles => _titles;

  int get getCurrentIndex => _currentIndex;

  void setPeriod(String data) {
    _period = data;
    notifyListeners();
  }

  void dailyPress(bool press) {
    _isDailyPress = press;
    notifyListeners();
  }

  void historicalPress(bool press) {
    _isHistoricalPress = press;
    notifyListeners();
  }

  Future<Graph>? callApi() {
    _asyncGraph = Api().graphApi(getPeriod);
    notifyListeners();
    return _asyncGraph;
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
