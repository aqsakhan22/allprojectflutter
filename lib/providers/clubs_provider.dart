import 'package:flutter/foundation.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/top_level_variables.dart';

import '../utility/shared_preference.dart';

class ClubsProvider extends ChangeNotifier {
  List clubsList = [];
  List myClubsList = [];

  Future<void> getClubs(Map<String, dynamic> reqData) async {
    print("reqdata in clubs is ${reqData}");
    try {
      GeneralResponse response = await AppUrl.apiService.clubs(reqData);
      print("Receiving Data from CLUBS: ${response.toString()}");
      if (response.status == 1) {
        print("Data Received Successfully from CLUBS: ${response.data}");
        clubsList = response.data as List;
        notifyListeners();
      } else {
        print(
            "Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<Map<String, dynamic>> myClubs() async {
    Map<String, dynamic> results = {};
    final Map<String, dynamic> reqBody = {};
    try {
      print("[REQUEST BODY] (myclubs): ${reqBody.toString()}");
      GeneralResponse response = await AppUrl.apiService.myclubs(reqBody);
      print("[RESPONSE BODY] (myclubs): ${response.data.toString()}");
      if (response.status == 1) {
        print("[SUCCESS BODY] (myclubs): ${response.data.toString()}");
        myClubsList = response.data as List;
        results = {
          "status": true,
          "message": response.message,
          "data": response.data
        };
        notifyListeners();
        return results;
      } else {
        print("[FAILURE BODY] (myclubs): ${response.data.toString()}");
        results = {
          "status": false,
          "message": response.message,
          "data": response.data
        };
        return results;
      }
    } catch (e) {
      print("[EXCEPTION] (myclubs): ${e.toString()}");
      results = {"status": false, "message": e.toString(), "data": {}};
      return results;
    }
  }

  Future<Map<String, dynamic>> clubActivate(Map<String, dynamic> reqBody) async {
    Map<String, dynamic> results = {};
    try {
      print("[REQUEST BODY] (clubactivate): ${reqBody.toString()}");
      GeneralResponse response = await AppUrl.apiService.clubactivate(reqBody);
      print("[RESPONSE BODY] (clubactivate): ${response.data.toString()}");
      if (response.status == 1) {
        UserPreferences.clubId = reqBody['Club_ID'];
        print("[SUCCESS BODY] (clubactivate): ${response.data.toString()}");
        TopFunctions.showScaffold(response.message);
        results = {
          "status": true,
          "message": response.message,
          "data": response.data
        };
        notifyListeners();
        return results;
      } else {
        print("[FAILURE BODY] (clubactivate): ${response.data.toString()}");
        TopFunctions.showScaffold(response.message);
        results = {
          "status": false,
          "message": response.message,
          "data": response.data
        };
        return results;
      }
    } catch (e) {
      print("[EXCEPTION] (clubactivate): ${e.toString()}");
      results = {"status": false, "message": e.toString(), "data": {}};
      return results;
    }
  }
}
