
import 'package:flutter/cupertino.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';

class SocialfeedsProvider extends ChangeNotifier {
  List socialFeeds = [];

  Future<void> Feeds(int page) async {
    print("Page no in api is ${page}");

    try {
      final Map<String, dynamic> reqData = {
        "Page_No":page
      };
      GeneralResponse response = await AppUrl.apiService.feeds(reqData);
      print("All Social Feeds is ${response.data}");
      if (response.status == 1) {
        socialFeeds=response.data as List;
        notifyListeners();

      }
      else{
        socialFeeds=[];
        notifyListeners();
        notifyListeners();

      }
    }
    catch (e) {
      print("EXCEPTIOM OF chat IS ${e}");
    }
  }


}
