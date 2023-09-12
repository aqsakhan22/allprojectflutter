import 'package:flutter/cupertino.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';

class AllPrograms extends ChangeNotifier {
  List Programs = [];

  Future<void> Allprograms(Map<String, dynamic> reqData) async {
    try {
      GeneralResponse response = await AppUrl.apiService.allprograms(reqData);
      print("All Programs data ${response.data}");
      if (response.status == 1) {
        Programs = response.data as List;
        notifyListeners();
      } else {
        print(
            "Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }
}
