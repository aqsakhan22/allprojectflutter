

import 'package:firebaseflutterproject/Design_Pattern/mvvm/MyViewModel.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/api/userClient.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/model/user.dart';

class UserViewModel extends MyViewModel{
  UserModel users=UserModel(id: null);
  UserList usersList=UserList();
  Future<void> usersApi(UserModel users) async {
    setState(ViewState.busy);
    try {
      users = await UserClient().getUsers(users);
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

 Future<void> usersApiList() async {
    setState(ViewState.busy);
    try {
       usersList.users =  await UserClient().getUsersList();
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }


}