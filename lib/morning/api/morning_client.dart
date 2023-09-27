import 'dart:convert';
import 'package:firebaseflutterproject/bflow/api_urls.dart';
import 'package:firebaseflutterproject/bflow/app_credentials.dart';
import 'package:http/http.dart' as http;
import '../morning.dart';


class MorningClient {
  Future<Research> researchReportApi(Research research) async {
    print('${research.createdAt} ${research.reportTypeId} ${research.reportCategoryId} ${research.page}');

    print(AppCredentials.token);

    try {
      var url = Uri.parse('$baseUrl/getallresearches');

      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AppCredentials.token}',
        },
        body: research.toJson(),
      );

      print('morning news api response: ${response.body}');

      var parsed = jsonDecode(response.body);
      return Research.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
