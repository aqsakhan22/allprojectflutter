import 'dart:convert';

import 'package:firebaseflutterproject/Design_Pattern/mvvm/model/user.dart';
import 'package:http/http.dart' as http;
class UserClient{

  // this is for when data is in {} map of map
  Future<UserModel> getUsers(UserModel users) async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
     var response = await http.get(url,);
     print('get all data of users is ${response.body} ${response.statusCode}');
      // var response = await http.post(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer ${AppCredentials.token}',
      //   },
      //   body: research.toJson(),
      // );

      print('morning news api response: ${response.body}');
      var parsed = jsonDecode(response.body);
      return UserModel.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<UserModel>> getUsersList() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
     var response = await http.get(url,);
     List<dynamic> parsed = jsonDecode(response.body);
      print("Decoded parse data is ${parsed}");
      return  List<UserModel>.from(parsed.map((x) => UserModel.fromJson(x)));
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}