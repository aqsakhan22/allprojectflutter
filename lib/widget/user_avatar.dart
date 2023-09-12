import 'package:flutter/material.dart';

class UserAvatar extends StatefulWidget {
  final String? assetName;

  const UserAvatar({Key? key, this.assetName}) : super(key: key);

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Image.asset("${widget.assetName}"),
          SizedBox(
            height: 5,
          ),
          Text(
            "UserName",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
