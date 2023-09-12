import '/network/api_service.dart';
import 'package:dio/dio.dart' as dio;

class AppUrl {
  // static const String baseUrl = 'https://ansariacademy.com/RunWith/api';
  // static const String mediaUrl= "https://ansariacademy.com/RunWith/";
  static const String baseUrl = 'https://app.runwith.io/api';
  static const String mediaUrl = 'https://app.runwith.io/';
  static ApiService apiService = ApiService(dio.Dio(),AppUrl.baseUrl);
}
