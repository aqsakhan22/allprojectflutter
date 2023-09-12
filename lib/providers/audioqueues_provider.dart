import 'package:flutter/foundation.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/top_level_variables.dart';

class AudioQueuesProvider extends ChangeNotifier {
  List audioQueues = [];

  Future<Map<String, dynamic>> getAudioQueues() async {
    Map<String, dynamic> results = {};
    final Map<String, dynamic> reqBody = {};
    try {
      print("[REQUEST BODY] (getAudioQueues): ${reqBody.toString()}");
      GeneralResponse response = await AppUrl.apiService.audioQueues(reqBody);
      print("[RESPONSE BODY] (getAudioQueues): ${response.data.toString()}");
      if (response.status == 1) {
        print("[SUCCESS BODY] (getAudioQueues): ${response.data.toString()}");
        audioQueues = response.data as List;
        results = {
          "status": true,
          "message": response.message,
          "data": response.data
        };
        notifyListeners();
        return results;
      } else {
        print("[FAILURE BODY] (getAudioQueues): ${response.data.toString()}");
        results = {
          "status": false,
          "message": response.message,
          "data": response.data
        };
        return results;
      }
    } catch (e) {
      print("[EXCEPTION] (getAudioQueues): ${e.toString()}");
      results = {"status": false, "message": e.toString(), "data": {}};
      return results;
    }
  }

}
