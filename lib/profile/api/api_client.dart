import 'dart:convert';
import 'package:firebaseflutterproject/bflow/api_urls.dart';
import 'package:firebaseflutterproject/bflow/app_credentials.dart';
import 'package:firebaseflutterproject/profile/model/delete_profile.dart';
import 'package:firebaseflutterproject/profile/model/profile.dart';
import 'package:firebaseflutterproject/profile/model/update_profile.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Profile> profileApi() async {
    try {
      var url = Uri.parse('$baseUrl/get_user');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AppCredentials.token}',
        },
      );

      print('profile api response: ${response.body}');

      var parsed = jsonDecode(response.body);
      return Profile.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<UpdateProfile> updateProfileApi(UpdateProfile updateProfile) async {
    try {
      var url = Uri.parse('$baseUrl/users');

      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer ${AppCredentials.token}',
        },
        body: updateProfile.toJson(),
      );

      print('update profile api response: ${response.body}');

      var parsed = jsonDecode(response.body);
      return UpdateProfile.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<UpdateProfile> singleUpdateProfileApi(String value) async {
    print('patch methoddd: $value');
    try {
      var url = Uri.parse('$baseUrl/users');

      var response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer ${AppCredentials.token}',
        },
        body: (value.contains('@'))
            ? {'email': value}
            : {'mobile_number': value.substring(1, 11)},
      );

      print('single update profile api response: ${response.body}');

      var parsed = jsonDecode(response.body);
      return UpdateProfile.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<DeleteProfile> deleteProfileApi() async {
    try {
      var url = Uri.parse('$baseUrl/delete_account');

      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppCredentials.token}',
        },
      );
      print('delete profile api response: ${response.body}');

      var parsed = jsonDecode(response.body);
      return DeleteProfile.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
