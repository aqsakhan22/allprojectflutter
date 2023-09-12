import 'package:flutter/material.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/top_level_variables.dart';

class NotificationProvider extends ChangeNotifier {
  List notifications = [];

  getNotifications() async {
    try {
      GeneralResponse response = await AppUrl.apiService.notifications({});
      if (response.status == 1) {
        notifications = response.data;
        notifyListeners();
      } else {
        TopFunctions.showScaffold(response.message.toString());
        notifyListeners();
      }
    } catch (e) {
      print("[EXCEPTION] (getNotifications) ${e}");
      notifyListeners();
    }
  }
}
