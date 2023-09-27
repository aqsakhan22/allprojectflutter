



import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/profile/api/api_client.dart';
import 'package:firebaseflutterproject/profile/model/delete_profile.dart';
import 'package:firebaseflutterproject/profile/model/profile.dart';
import 'package:firebaseflutterproject/profile/model/update_profile.dart';

class ProfileVM extends MyViewModel {
  var profile = Profile();
  String mobileNumberError = "";
  String emailError = "";

  Future<void> profileApi() async {
    setState(ViewState.busy);
    try {
      profile = await ApiClient().profileApi();
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  bool profileFormValidations(UpdateProfile updateProfile) {
    bool isValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(updateProfile.email!);

    if (updateProfile.email!.isNotEmpty &&
        emailError == "* valid email required" &&
        isValid == true) {
      emailError = "";
      setState(ViewState.idle);
    }

    if (updateProfile.mobileNumber!.isNotEmpty &&
        mobileNumberError == '* 11 digits mobile number required' &&
        updateProfile.mobileNumber!.length == 11) {
      mobileNumberError = "";
      setState(ViewState.idle);
    }

    if (updateProfile.email!.isEmpty || isValid == false) {
      emailError = "* valid email required";
      setState(ViewState.idle);
      return false;
    }

    if (updateProfile.mobileNumber!.isEmpty ||
        updateProfile.mobileNumber!.length != 11) {
      mobileNumberError = '* 11 digits mobile number required';
      setState(ViewState.idle);
      return false;
    }

    return true;
  }

  Future<UpdateProfile?> updateProfileApi(UpdateProfile updateProfile) async {
    setState(ViewState.busy);

    try {
      updateProfile.mobileNumber =
          updateProfile.mobileNumber.toString().substring(1, 11);

      var response = await ApiClient().updateProfileApi(updateProfile);
      setState(ViewState.idle);
      return response;
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<UpdateProfile> singleUpdateProfileApi(String value) async {
    setState(ViewState.busy);
    try {
      var response = await ApiClient().singleUpdateProfileApi(value);
      setState(ViewState.idle);
      return response;
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<DeleteProfile> deleteProfileApi() async {
    setState(ViewState.busy);
    try {
      var response = await ApiClient().deleteProfileApi();
      setState(ViewState.idle);
      return response;
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }
}
