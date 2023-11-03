import 'package:firebaseflutterproject/MVVM/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';

class AuthViewModel with ChangeNotifier{
  final _myRepo=AuthRepository();


  Future<dynamic> loginApi(dynamic data,BuildContext context) async{

   _myRepo.loginApi(data);
  }
}