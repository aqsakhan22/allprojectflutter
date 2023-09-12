import 'package:flutter/cupertino.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/utility/top_level_variables.dart';

class ChatProvider extends ChangeNotifier {
  List personalsData = [];
  List personalChat = [];

  List forumsData = [];
  List forumChat = [];

  List clubsData = [];
  List clubChat = [];

  int pageNo = 1;

  Future<void> getPersonalChatsData(Map<String, dynamic> reqData) async {
    print("All chats reqbody is ${reqData}");
    try {
      GeneralResponse response = await AppUrl.apiService.chats(reqData);
      print("All Chats data ${response.data}");
      if (response.status == 1) {
        personalsData = response.data as List;
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
      TopFunctions.showScaffold("${e}");
    }
  }

  Future<void> getPersonalChat(String id, int page) async {
    try {
      final Map<String, dynamic> reqData = {'ChatInfo_ID': id, "Page_No": page};
      GeneralResponse response = await AppUrl.apiService.chatpersonal(reqData);
      if (response.status == 1) {
        // personalChat = response.data as List;
        personalChat = (response.data as List) + personalChat;  // Appending Incoming List At The Top Of Current Chat List
        notifyListeners();
      } else {
        notifyListeners();
      }
    } catch (e) {
      print("EXCEPTION OF getPersonalChat IS ${e}");
      notifyListeners();
    }
  }

  Future<void> getClubChatsData(Map<String, dynamic> reqData) async {
    try {
      // final Map<String, dynamic> reqData = {
      //   'Type':"Club"
      // };
      GeneralResponse response = await AppUrl.apiService.chats(reqData);
      print("All Clubs data ${response.data}");
      if (response.status == 1) {
        clubsData = response.data as List;
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<void> getClubChat(String ChatInfo_ID, int pageNo) async {
    try {
      final Map<String, dynamic> reqData = {'ChatInfo_ID': ChatInfo_ID, "Page_No": pageNo};
      GeneralResponse response = await AppUrl.apiService.chatclub(reqData);
      print("All forum_chat_clubs Clubs data ${response.data}");
      if (response.status == 1) {
        clubChat = response.data as List;
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<void> getForumChatsData() async {
    try {
      final Map<String, dynamic> reqData = {};
      GeneralResponse response = await AppUrl.apiService.forums(reqData);
      print("All Forums data ${response.data}");
      if (response.status == 1) {
        forumsData = response.data as List;
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<void> getForumChat(String Forum_ID, int Page_No) async {
    try {
      final Map<String, dynamic> reqData = {"Forum_ID": Forum_ID, "Page_No": Page_No};
      GeneralResponse response = await AppUrl.apiService.forumreplies(reqData);
      print("All Forums replies data ${response.data}");
      if (response.status == 1) {
        // forumChat = response.data as List;
        forumChat = (response.data as List) + forumChat;  // Appending Incoming List At The Top Of Current Chat List
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }

  Future<void> chatsStatus(String id, String Type) async {
    try {
      final Map<String, dynamic> reqData = {'ChatInfo_ID': id, "Type": Type};
      print("reqbody pf chat is ${reqData}");
      GeneralResponse response = await AppUrl.apiService.chatstatus(reqData);
      print("All Chats delete/archive/report ${response.data} ${response.status}");
      if (response.status == 1) {
        final Map<String, dynamic> chatReqData = {"Type": "Personal"};
        getPersonalChatsData(chatReqData);
        TopFunctions.showScaffold("${response.message}");
        notifyListeners();
      } else {
        print("Data Received Didn't Successfully from clubs: ${response.toString()}");
      }
    } catch (e) {
      print("EXCEPTIOM OF sponsor IS ${e}");
    }
  }
}
