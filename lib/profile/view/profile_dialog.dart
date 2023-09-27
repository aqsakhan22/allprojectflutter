import 'package:firebaseflutterproject/bflow/flows/call_flow.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/profile/model/update_profile.dart';
import 'package:firebaseflutterproject/profile/view_model/profile_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void updateDialog(BuildContext context, [UpdateProfile? updateProfile, GlobalKey<FormState>? formKey]) {
  showDialog(
    context: context,
    builder: (BuildContext mCxt) {
      return AlertDialog(
        title: const Text('Update profile'),
        content: const Text('Do you want to update your profile ?'),
        actions: [
          Consumer<ProfileVM>(
            builder: (_, model, __) {
              return (model.getState == ViewState.idle)
                  ? ElevatedButton(
                      onPressed: () async {
                        formKey?.currentState?.save();

                        // print(updateProfile?.email);
                        // print(updateProfile?.mobileNumber);
                        // print(model.profile.profileData?.email);
                        // print(model.profile.profileData?.mobileNumber);

                        if (model.profile.profileData?.email != updateProfile?.email &&
                            '0${model.profile.profileData?.mobileNumber}' != updateProfile?.mobileNumber) {
                          // print('hit api');
                          // CallFlow().toastMessage('hit put api');

                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            final instance = Provider.of<ProfileVM>(context, listen: false);
                            instance.updateProfileApi(updateProfile!).then((value) {
                              CallFlow().toastMessage(value?.message);
                              Navigator.pop(mCxt);

                              if (value!.message.toString().contains('updated success')) {
                                instance.profileApi();
                              }
                            });
                          });
                        } else if (model.profile.profileData?.email != updateProfile?.email
                            && '0${model.profile.profileData?.mobileNumber}' == updateProfile?.mobileNumber) {
                          // CallFlow().toastMessage('hit patch api with email');

                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            final instance = Provider.of<ProfileVM>(context, listen: false);
                            instance.singleUpdateProfileApi(updateProfile?.email ?? "").then((value) {
                              if (value.message.toString().contains('already exist')) {
                                CallFlow().toastMessage('${updateProfile?.email} ${value.message}');
                              } else if (value.message.toString().contains('updated success')) {
                                instance.profileApi();
                              } else {
                                CallFlow().toastMessage(value.message);
                              }

                              Navigator.pop(mCxt);
                            });
                          });
                        } else if (model.profile.profileData?.email == updateProfile?.email
                            && '0${model.profile.profileData?.mobileNumber}' != updateProfile?.mobileNumber) {
                          // CallFlow()
                          //     .toastMessage('hit patch api with mobile number');

                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            final instance = Provider.of<ProfileVM>(context, listen: false);
                            instance.singleUpdateProfileApi(updateProfile?.mobileNumber ?? "").then((value) {
                              if (value.message.toString().contains('updated success')) {
                                instance.profileApi();
                              } else if (value.message.toString().contains('already exist')) {
                                CallFlow().toastMessage('${updateProfile?.mobileNumber} ${value.message}');
                              } else {
                                CallFlow().toastMessage(value.message);
                              }

                              Navigator.pop(mCxt);
                            });
                          });
                        } else {
                          CallFlow().toastMessage('please provide new data to update');
                          Navigator.pop(mCxt);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'YES',
                        style: TextStyle(color: Color(0xFFC3161C)),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Color(0xFFC3161C)),
                    );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(mCxt),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'NO',
              style: TextStyle(color: Color(0xFFC3161C)),
            ),
          ),
        ],
      );
    },
  );
}

void deleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext mCxt) {
      return AlertDialog(
        title: const Text('Delete profile'),
        content: const Text('Do you want to delete your profile ?'),
        actions: [
          Consumer<ProfileVM>(
            builder: (_, model, __) {
              return (model.getState == ViewState.idle)
                  ? ElevatedButton(
                      onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          final instance = Provider.of<ProfileVM>(context, listen: false);
                          instance.deleteProfileApi().then((value) {
                            CallFlow().toastMessage(value.message);
                            Navigator.pop(mCxt);

                            if (value.message.toString().contains('success')) {
                              Navigator.pushNamed(context, 'login');
                            }
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'YES',
                        style: TextStyle(color: Color(0xFFC3161C)),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Color(0xFFC3161C)),
                    );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(mCxt),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'NO',
              style: TextStyle(color: Color(0xFFC3161C)),
            ),
          ),
        ],
      );
    },
  );
}
