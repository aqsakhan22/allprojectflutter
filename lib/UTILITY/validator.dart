String? validateEmail(String? value) {
  String? _msg;
  RegExp regex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.isEmpty) {
    _msg = "Your email address is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid email address";
  }
  return _msg;
}

String? validatePassword(String? value) {
  String? _msg;
  if (value!.isEmpty) {
    _msg = "Password is required";
  }
  return _msg;
}

String? validateConfirm(String? pwd, String? confirmPwd) {
  String? _msg;
  if (confirmPwd!.isEmpty) {
    _msg = "Password is required";
  } else if (pwd != confirmPwd) {
    _msg = "Confirm Password does not matched.";
  }
  return _msg;
}

String? validatePhoneNum(String? value) {
  String? _msg;
  if (value!.isEmpty) {
    _msg = "Phone Number is required.";
  } else if (value.length < 12) {
    _msg = "Phone Number must be greater than 12 character.";
  }
  return _msg;
}

String? validateInputData(value, validatorRequired) {
  String? _msg;
  if (validatorRequired == true) {
    if (value == null || value == "") {
      _msg = "This field is required.";
    }
  }
  return _msg;
}
