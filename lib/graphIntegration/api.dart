
import 'dart:convert';

import 'package:firebaseflutterproject/graphIntegration/Graph.dart';
import 'package:http/http.dart' as http;
class Api {
  Future<Graph> graphApi(String category) async {
    print("category is ${category}");
    try {
      var url = Uri.parse('http://15.206.35.78/api/v1/graphdata');
      var response = await http.post(
        url,
        body: {
          'period': category,
        },
      );

      print("graph Api is ${response.body}");

      var parsed = jsonDecode(response.body);
      print("parsed data is ${parsed}");
      return Graph.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}