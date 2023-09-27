class AppState {

  AppState._internal();

  static final AppState _instance = AppState._internal();

  factory AppState() => _instance;

  // String? _token;
  // String? _fcmToken;
  // int? _terminalUser;
  int? _screenId;
  int? _reportId;
  String? _reportTitle;

  // String? get getToken => _token;
  //
  // String? get getFCMToken => _fcmToken;
  //
  // int? get getTerminalUser => _terminalUser;

  int? get getScreenId => _screenId;

  int? get getReportId => _reportId;

  String? get getReportTitle => _reportTitle;

  // void setToken(String token) {
  //   _token = token;
  // }
  //
  // void setFCMToken(String token) {
  //   _fcmToken = token;
  // }
  //
  // void setTerminalUser(int value) {
  //   _terminalUser = value;
  // }

  void setScreenId(int id) {
    _screenId = id;
  }

  void setReportId(int id) {
    _reportId = id;
  }

  void setReportTitle(String title) {
    _reportTitle = title;
  }
}
