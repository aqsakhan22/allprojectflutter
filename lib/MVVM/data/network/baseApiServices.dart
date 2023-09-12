abstract class BaseApiServices {
  Future<dynamic> getGetAppResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
}
