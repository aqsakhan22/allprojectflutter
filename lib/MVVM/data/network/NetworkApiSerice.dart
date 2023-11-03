import 'dart:convert';
import 'dart:io';

import 'package:firebaseflutterproject/MVVM/data/app_exceptions.dart';
import 'package:firebaseflutterproject/MVVM/data/network/baseApiServices.dart';
import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:firebaseflutterproject/TopVariables.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetAppResponse(String url) async {
    // TODO: implement getGetAppResponse
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = returnReponse(response);
    } on SocketException {
      return throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    // TODO: implement getPostApiResponse
    dynamic responseJson;
    try {
      http.Response response = await http.post(Uri.parse(url), body: data);
      // print("return value is in login ${response.body}");
      responseJson = returnReponse(response);


    } on SocketException {
      return throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnReponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        Utils.flushErrorMessage("Success", TopVaraible.navigatorKey.currentContext!);
        return responseJson;
      case 400:
        Utils.flushErrorMessage("400 CODE", TopVaraible.navigatorKey.currentContext!);
        throw BadRequestException("${response.body}");
      default:
        throw FetchDataException("Error occured  while communicating with server" + "satatus ${response.statusCode.toString()}");
    }
  }
}
