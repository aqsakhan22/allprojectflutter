import 'package:flutter/cupertino.dart';
import 'package:runwith/models/user.dart';

import '../utility/shared_preference.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic> data_login = {};
  String AuthToken = "";
  User _user = User(
    ProfilePhoto: '',
    UserName: '',
    Designation: '',
    DateOfBirth: '',
    Height: '',
    Weight: '',
    Gender: '',
    Country: '',
    State: '',
    City: '',
    Phone: '',
    MeasurementUnit: '',
    RunBefore: 'false',
    FastestTime: '',
    AMTimeStart: '',
    AMTimeEnd: '',
    PMTimeStart: '',
    PMTimeEnd: '',
    PreferredDays: '',
    RunningProgram: '',
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void update() {
    data_login = UserPreferences.get_Login();
    AuthToken = UserPreferences.AuthToken;
    notifyListeners();
  }

  void update_login(Map<String, dynamic> incoming_data_login) {
    print("LOGIN DAYA IS ${incoming_data_login}");
    data_login = incoming_data_login;
    update_authToken(incoming_data_login['AuthToken']);
    UserPreferences.set_Login(incoming_data_login);
    UserPreferences.clubId = incoming_data_login['Club_ID'];
    print("Club id after login is ${UserPreferences.clubId}");
    notifyListeners();
  }

  void update_authToken(String token) {
    AuthToken = token;
    UserPreferences.AuthToken = token;
    notifyListeners();
  }
}
