import 'package:firebaseflutterproject/bflow/custom_design/my_curve_design.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/profile/view/profile_body.dart';
import 'package:firebaseflutterproject/profile/view_model/profile_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final instance = Provider.of<ProfileVM>(context, listen: false);
      instance.profileApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
           Expanded(
            flex: 1,
            child: MyCurveDesign(
              iconPath: 'assets/images/person.svg',
              title: 'User Profile',
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Consumer<ProfileVM>(
                builder: (context, model, child) {
                  return (model.getState == ViewState.idle)
                      ? const ProfileBody()
                      : const Center(
                          child: CircularProgressIndicator(color: Color(0xFFC3161C)),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
