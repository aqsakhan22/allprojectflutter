import 'package:firebaseflutterproject/profile/view/profile_form.dart';
import 'package:flutter/material.dart';


class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE7E8EA),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF707070),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: const ProfileForm(),
      ),
    );
  }
}
