import 'package:flutter/foundation.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/top_level_variables.dart';

class QuoteProvider extends ChangeNotifier {
  List quotes = [];

  Future<Map<String, dynamic>> getQuotes() async {
    Map<String, dynamic> results = {};
    final Map<String, dynamic> reqBody = {};
    try {
      print("[REQUEST BODY] (getQuotes): ${reqBody.toString()}");
      GeneralResponse response = await AppUrl.apiService.quotes(reqBody);
      print("[RESPONSE BODY] (getQuotes): ${response.data.toString()}");
      if (response.status == 1) {
        print("[SUCCESS BODY] (getQuotes): ${response.data.toString()}");
        quotes = response.data as List;
        results = {
          "status": true,
          "message": response.message,
          "data": response.data
        };
        notifyListeners();
        return results;
      } else {
        print("[FAILURE BODY] (getQuotes): ${response.data.toString()}");
        results = {
          "status": false,
          "message": response.message,
          "data": response.data
        };
        return results;
      }
    } catch (e) {
      print("[EXCEPTION] (getQuotes): ${e.toString()}");
      results = {"status": false, "message": e.toString(), "data": {}};
      return results;
    }
  }

}
