import 'dart:convert';
import 'package:firebaseflutterproject/bflow/api_urls.dart';
import 'package:firebaseflutterproject/bflow/app_credentials.dart';
import 'package:firebaseflutterproject/bflow/base_data.dart';

import 'package:http/http.dart' as http;

class NavigationClient {
  Future<BaseData> baseDataApi() async {
    try {
      var url = Uri.parse('$baseUrl/get_base_data');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${AppCredentials.token}'},
      );

      print('base data api response: ${response.body}');
      var parsedJson = jsonDecode(response.body);
      return BaseData.fromJson(parsedJson);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
