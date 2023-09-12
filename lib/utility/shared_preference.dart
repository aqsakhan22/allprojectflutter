import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

initializePreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class UserPreferences {
  static Future<void> set_Login(
      Map<String, dynamic> incoming_data_login) async {
    await prefs.setString("data_login", jsonEncode(incoming_data_login));
  }

  static Map<String, dynamic> get_Login() {
    return jsonDecode(prefs.getString("data_login") ?? "{}");
  }

  static String get AuthToken => prefs.getString('AuthToken') ?? "";

  static set AuthToken(String? incoming_AuthToken) {
    prefs.setString('AuthToken', incoming_AuthToken!);
  }

  static int get LoginLevel => prefs.getInt('LoginLevel') ?? 0;

  static set LoginLevel(int? incoming_LoginLevel) {
    prefs.setInt('LoginLevel', incoming_LoginLevel!);
  }

  static bool get IsLogin => prefs.getBool('IsLogin') ?? false;

  static set IsLogin(bool? incoming_IsLogin) {
    prefs.setBool('IsLogin', incoming_IsLogin!);
  }





  static String get RunId => prefs.getString('RunId') ?? "";

  static set RunId(String? RunId) {
    prefs.setString('RunId', RunId!);
  }

  static void RemovePrefs(String name) {
    prefs.remove("${name}");
  }

  static bool get isRunning => prefs.getBool('isRunning') ?? false;

  static set isRunning(bool? isRunning) {
    prefs.setBool('isRunning', isRunning!);
  }

  static bool get isRunningPause => prefs.getBool('isRunningPause') ?? false;

  static set isRunningPause(bool? isRunningPause) {
    prefs.setBool('isRunningPause', isRunningPause!);
  }

  static String get clubId => prefs.getString('clubId') ?? "";

  static set clubId(String? clubId) {
    prefs.setString('clubId', clubId!);
  }

  static String get programRun => prefs.getString('programRun') ?? "";

  static set programRun(String? programRun) {
    prefs.setString('programRun', programRun!);
  }

  static String get programId => prefs.getString('programId') ?? "";

  static set programId(String? programId) {
    prefs.setString('programId', programId!);
  }

  static String get eventId => prefs.getString('eventId') ?? "";

  static set eventId(String? eventId) {
    prefs.setString('eventId', eventId!);
  }

  static String get eventRun => prefs.getString('eventRun') ?? "";

  static set eventRun(String? eventRun) {
    prefs.setString('eventRun', eventRun!);
  }

  static Future<void> set_Profiledata(Map<String, dynamic> profileData) async {
    await prefs.setString("profileData", jsonEncode(profileData));
  }

  static Map<String, dynamic> get_Profiledata() {
    return jsonDecode(prefs.getString("profileData") ?? "{}");
  }

  static String get spotifyToken =>
      prefs.getString(
        "SpotifyToken",
      ) ??
      '';

  static set spotifyToken(String spotifyToken) {
    prefs.setString("SpotifyToken", spotifyToken);
  }

  static int get runProgramtimer =>
      prefs.getInt(
        "runProgramtimer",
      ) ??
      0;

  static set runProgramtimer(int runProgramtimer) {
    prefs.setInt("runProgramtimer", runProgramtimer);
  }

  static int get distanceCueKMMarker => prefs.getInt('distanceCueKMMarker') ?? 1;

  static set distanceCueKMMarker(int? distanceCueKMMarker) {
    prefs.setInt('distanceCueKMMarker', distanceCueKMMarker!);
  }
  static String get runType => prefs.getString('runType') ?? "";

  static set runType(String? runType) {
    prefs.setString('runType', runType!);
  }


  // static List<dynamic> getripLocations() {
  //   var jsonStringDecode = jsonDecode(prefs.getString("triplocations")!);
  //   return jsonStringDecode;
  // }
  //
  // static Future<void> setTripLocations(List<dynamic> locations) async {
  //   String encodeStringData = jsonEncode(locations);
  //
  //   prefs.setString("triplocations", encodeStringData);
  // }

  static List get TripLocations => jsonDecode(prefs.getString("triplocations") ?? "[]");

  static set TripLocations(List TripLocations) {
    prefs.setString('triplocations', jsonEncode(TripLocations));
  }
}
