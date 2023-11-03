import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:firebaseflutterproject/TopVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' ;

class AuthProvider extends ChangeNotifier{

  bool _loading=false;
  bool get loading => _loading;

  setLogin(bool value){
    _loading=value;
    notifyListeners();
  }

void login (String email,String password) async{
    setLogin(true);
  // https://reqres.in
  try{
     Response response=await post(Uri.parse("https://reqres.in/api/login"),
       body: {
         "email": email,
         "password": password
       }
     );
     if(response.statusCode == 200){
       print("Login data is ${response.body}");
       setLogin(false);
       Utils.flushErrorMessage("Successfully Login", TopVaraible.navigatorKey.currentContext!);
     }
     else{
       setLogin(false);
       Utils.flushErrorMessage("User Has not been Registered", TopVaraible.navigatorKey.currentContext!);

     }
  }
  catch(e){
    setLogin(false);
    Utils.flushErrorMessage(e.toString(), TopVaraible.navigatorKey.currentContext!);
  }

    notifyListeners();
}


}