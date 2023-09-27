class AppCredentials {
  AppCredentials._internal();

  static final AppCredentials _instance = AppCredentials._internal();

  factory AppCredentials() => _instance;

  static String? _token;
  static int? _terminalUser;
  static String? _firebaseToken;

  static String? get token => _token;

  static int? get terminalUser => _terminalUser;

  static String? get firebaseToken => _firebaseToken;

  static set setToken(String value) {
    _token = value;
  }

  static set setTerminalUser(int value) {
    _terminalUser = value;
  }

  static set setFirebaseToken(String value) {
    _firebaseToken = value;
  }
}
