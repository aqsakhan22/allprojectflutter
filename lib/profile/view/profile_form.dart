import 'package:firebaseflutterproject/profile/model/update_profile.dart';
import 'package:firebaseflutterproject/profile/view/profile_dialog.dart';
import 'package:firebaseflutterproject/profile/view_model/profile_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final formKey = GlobalKey<FormState>();
  final updateProfile = UpdateProfile();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 1.h),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        suffixIconColor: Color(0xFFC3161C),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Consumer<ProfileVM>(
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyTitle(icon: Icons.person_outline, title: 'Full Name:'),
              SizedBox(height: 1.5.h),
              Text(
                model.profile.profileData?.name ?? "",
                style: TextStyle(
                  color: const Color(0xFF231F20),
                  fontSize: 11.sp,
                ),
              ),
              const Divider(color: Color(0xFF720812), thickness: 0.7),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyTitle(icon: Icons.email_outlined, title: 'Email:'),
                    Theme(
                      data: themeData,
                      child: TextFormField(
                        initialValue: model.profile.profileData?.email,
                        onSaved: (value) => updateProfile.email = value,
                        style: TextStyle(fontSize: 11.sp),
                        cursorColor: Color(0xFFC3161C),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xFF720812), thickness: 0.7),
                    Text(
                      model.emailError,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const MyTitle(
                        icon: Icons.phone_outlined, title: 'Contact No:'),
                    Theme(
                      data: themeData,
                      child: TextFormField(
                        initialValue:
                            '0${model.profile.profileData?.mobileNumber}',
                        onSaved: (value) => updateProfile.mobileNumber = value,
                        style: TextStyle(fontSize: 11.sp),
                        cursorColor: Color(0xFFC3161C),
                        maxLength: 11,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(suffixIcon: Icon(Icons.edit)),
                      ),
                    ),
                    Text(
                      model.mobileNumberError,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              // const Divider(color: Color(0xFF720812), thickness: 0.7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    title: 'Update',
                    pressMe: () {
                      formKey.currentState?.save();
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        final instance =
                            Provider.of<ProfileVM>(context, listen: false);
                        // instance.updateProfileApi(updateProfile);
                        var response =
                            instance.profileFormValidations(updateProfile);
                        // print(response);

                        if (response) {
                          updateDialog(context, updateProfile, formKey);
                        }
                      });
                    },
                  ),
                  CustomButton(
                    title: 'Delete',
                    pressMe: () => deleteDialog(context),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyTitle extends StatelessWidget {
  const MyTitle({Key? key, required this.icon, required this.title})
      : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFFC3161C),
          size: 2.h,
        ),
        Text(
          ' $title',
          style: TextStyle(color: Color(0xFFC3161C), fontSize: 12.sp),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.title, required this.pressMe})
      : super(key: key);

  final String title;
  final Function pressMe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.w,
      child: ElevatedButton(
        onPressed: () => pressMe(),
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFC3161C)),
        child: Text(title),
      ),
    );
  }
}
