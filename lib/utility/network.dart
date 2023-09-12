import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Network {
  String url;

  Network(this.url);

  Future<String> apiRequest(Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/x-www-form-urlencoded');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    //  - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<String> sendData(Map data) async {
    http.Response response = await http.post(Uri.parse("http://ip-api.com/json"));
    if (response.statusCode == 200)
      return (response.body);
    else
      return 'No Data';
  }

  Future<String> getData() async {
    http.Response response = await http.post(Uri.parse("http://ip-api.com/json"));
    if (response.statusCode == 200)
      return (response.body);
    else
      return 'No Data';
  }
}
