

import 'package:firebaseflutterproject/MVVM/data/network/NetworkApiSerice.dart';
import 'package:firebaseflutterproject/MVVM/data/network/baseApiServices.dart';
import 'package:firebaseflutterproject/MVVM/res/appurl.dart';
import 'package:http/http.dart';


class AuthRepository{

  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async{
    try{
      Response response=await _apiServices.getPostApiResponse(AppUrl.login,data);
    return response;
    }
    catch(e){

        }
  }

  Future<dynamic> registerApi(dynamic data) async{
    try{
      Response response=await _apiServices.getPostApiResponse(AppUrl.register ,data);
    return response;
    }
    catch(e){

        }
  }





}