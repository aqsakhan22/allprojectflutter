import 'package:flutter/widgets.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/shared_preference.dart';

class RunningProgramProvider extends ChangeNotifier{

  List Events=[];
  Future<void> runningEvents() async {
    try {
      final Map<String, dynamic> reqBody = {"Club_ID": UserPreferences.clubId};

      GeneralResponse response = await AppUrl.apiService.clubevents(reqBody);
      print("Events is ${response.data}");
      Events=response.data;
      notifyListeners();

      // print("eventDetails details is ${eventDetails}");

    } catch (e) {
      print("Exception runningProgram ${e}");
    }
  }

}