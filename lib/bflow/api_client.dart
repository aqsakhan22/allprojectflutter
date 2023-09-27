import 'dart:convert';
import 'package:firebaseflutterproject/bflow/api_urls.dart';
import 'package:firebaseflutterproject/bflow/app_credentials.dart';
import 'package:firebaseflutterproject/bflow/auto_suggest.dart';
import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:http/http.dart' as http;
import '../../morning/morning.dart';

class ApiClient {
  Future<Research> reportsApi(Research research) async {
    print(
        '${research.createdAt} ${research.reportTypeId} ${research.reportCategoryId}');

    try {
      var url = Uri.parse('$baseUrl/getallresearches');

      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${AppCredentials.token}'},
        body: research.toJson(),
      );

      print('reports api response: ${response.body}');
      var parsed = jsonDecode(response.body);
      return Research.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<AutoSuggest> autoSuggestApi(AutoSuggest autoSuggest) async {
    print('${autoSuggest.title} ${autoSuggest.page}');

    try {
      var url = Uri.parse('$baseUrl/autosuggest');

      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${AppCredentials.token}'},
        body: autoSuggest.toJson(),
      );

      print('auto-suggest api response: ${response.body}');
      var parsed = jsonDecode(response.body);
      return AutoSuggest.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Search> searchApi(Search search) async {
    print(
        'search title is title: ${search.title} time: ${search.createdAt} sectorId: ${search.sectorId} companyId: ${search.companyId} page: ${search.page}');

    try {
      var url = Uri.parse('$baseUrl/search');

      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer ${AppCredentials.token}'},
        body: search.toJson(),
      );

      print('search api response: ${response.body}');
      var parsed = jsonDecode(response.body);
      return Search.fromJson(parsed);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
