import 'package:flutter/material.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';

import '../network/app_url.dart';

class AppBarWidget {
  static textAppBar(String title) {
    return AppBar(
      elevation: 0.0,
      leading: InkWell(
        onTap: () {
          // Navigator.pushReplacementNamed(TopVariables.appNavigationKey.currentContext!, '/Home');
          Navigator.pop(TopVariables.appNavigationKey.currentContext!);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: Text(
        "${title}",
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
      ),
      actions: [
        Container(
          width: 40,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  TopVariables.appNavigationKey.currentState!.context,
                  '/Chats');
            },
            child: Image.asset("assets/MessageBubble.png"),
          ),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  TopVariables.appNavigationKey.currentState!.context,
                  '/MyProfile');
            },
            child: UserPreferences.get_Profiledata()['ProfilePhoto'] == null
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage("assets/raw_profile_pic.png")),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}")),
                  ),
          ),
        ),
      ],
    );
  }

  static imageAppBar() {
    return AppBar(
      leading: Text(""),
      leadingWidth: 0.0,
      title: Row(
        children: [
          Image.asset(
            "assets/RunWith-WhiteLogo.png",
            width: 200,
          ),
        ],
      ),
      actions: [
        Container(
          width: 40,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(TopVariables.appNavigationKey.currentState!.context, '/Chats');
            },
            child: Image.asset("assets/MessageBubble.png"),
          ),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  TopVariables.appNavigationKey.currentState!.context,
                  '/MyProfile');
            },
            child: UserPreferences.get_Profiledata()['ProfilePhoto'] == null
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage("assets/raw_profile_pic.png")),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}")),
                  ),
          ),
        ),
      ],
    );
  }

  static imageAppBarBack() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.pop(TopVariables.appNavigationKey.currentContext!);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Image.asset(
          "assets/RunWith-WhiteLogo.png",
          width: 140,
        ),
      ),
      actions: [
        Container(
          width: 45,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  TopVariables.appNavigationKey.currentState!.context,
                  '/Chats');
            },
            child: Image.asset("assets/MessageBubble.png"),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  TopVariables.appNavigationKey.currentState!.context,
                  '/MyProfile');
            },
            child: UserPreferences.get_Profiledata()['ProfilePhoto'] == null
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage("assets/raw_profile_pic.png")),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}")),
                  ),
          ),
        ),
      ],
    );
  }
}
