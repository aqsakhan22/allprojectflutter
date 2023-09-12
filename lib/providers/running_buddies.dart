import 'package:flutter/foundation.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';

class RunningBuddiesProvider extends ChangeNotifier {
  List Buddies = [];
  List RequestFriends = [];

  // List Accept=[];
  List Acceptfriends = [];

  Future<void> getRunningBuddies(Map<String, dynamic> reqData) async {
    try {
      GeneralResponse response = await AppUrl.apiService.runners(reqData);
      print("Receiving Data from CLUBS: ${response.data}");
      if (response.status == 1) {
        print("Data Received Successfully from Buddies:${response.data}");
        Buddies = response.data as List;
        notifyListeners();
      } else {
        print(
            "Data Received Didn't Successfully from Buddies: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<void> getRunningBuddiesFriends() async {
    try {
      final Map<String, dynamic> reqData = {};
      GeneralResponse response = await AppUrl.apiService.friends(reqData);
      print("Receiving Data from FRIENDS: ${response.data}");
      if (response.status == 1) {
        print("Data Received Successfully from Friends: ${response.data}");
        Acceptfriends = (response.data as List)
            .where((element) => element['Status'] == "Accept")
            .toList();
        print("accept friends ${Acceptfriends}");
        RequestFriends = (response.data as List)
            .where((element) => element['Status'] == "Request")
            .toList();
        notifyListeners();
        print("request friends ${RequestFriends}");
        // print("Dat is${  (response.data as List).map((e){
        //
        //   // if(e['Status'] == "Accept"){
        //   //
        //   //   print("Accept is");
        //   //   Acceptfriends.add(e);
        //   //
        //   // }
        //   // else{
        //   //   RequestFriends.add(e);
        //   // }
        // })}");
        // print("accept friends is ${Acceptfriends}");
        // print("request friends is ${RequestFriends}");

        // friends=response.data as List;

        // Request=response.data as List;
        //    print("${ (response.data as List).map((e){
        //      print("E DATA is ${e}");
        //      if(e['Status'] == "Accept"){
        //        print("ACCEPT IS ${e}");
        //        Accept.add(e);
        //      }
        //      if(e['Status'] == "Request"){
        //        Request.add(e);
        //      }
        //      print("BUDDIES ${e}");
        //
        //    })}");

        notifyListeners();
      } else {
        print(
            "Data Received Didn't Successfully from Friends: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }
}
