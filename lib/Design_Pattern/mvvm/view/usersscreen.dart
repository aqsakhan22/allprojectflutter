import 'package:firebaseflutterproject/Design_Pattern/mvvm/MyViewModel.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/model/user.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/viewmodel/userViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserModel users=UserModel();
  UserList userList=UserList();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    final instance = Provider.of<UserViewModel>(context, listen: false);
    // instance.usersApi(users);
     instance.usersApiList();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User dretails"),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            final instance = Provider.of<UserViewModel>(context, listen: false);
            instance.usersApiList();
          }, child: Text("check data")),


          Consumer<UserViewModel>(
              builder: (context, model, child) {
              return  (model.getSearchState == ViewState.idle) ?
              Expanded(child: ListView.builder(shrinkWrap: true,
                  itemCount: model.usersList.users.length,
                  itemBuilder: (BuildContext context,int index){

                    return Text("hello ${model.usersList.users[index].id}");
                  }))

                    :
           CircularProgressIndicator(
             color: Colors.red,
           );
          })
        ],
      ),
    );
  }
}
