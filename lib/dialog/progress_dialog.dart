import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '/theme/color.dart';
import '/utility/top_level_variables.dart';

class CustomProgressDialog {
  static final ProgressDialog _progressDialog = ProgressDialog(
    context: TopVariables.appNavigationKey.currentContext,
  );

  static void showProDialog() {
    return _progressDialog.show(
      max: 100,
      hideValue: true,
      msg: 'Please Wait...',
      progressType: ProgressType.valuable,
      backgroundColor: CustomColor.white,
      progressBgColor: CustomColor.primary,
      // msgColor: CustomColor.white,
      progressValueColor: CustomColor.primary,
    );
  }

  static void hideProDialog() {
    if(_progressDialog.isOpen()){
      _progressDialog.close();
    }
  }

  static void showProgressDialogBox(BuildContext context1, bool value) {
    // show the dialog
    value == true
        ? CustomProgressDialog.showProDialog()
        : CustomProgressDialog.hideProDialog();
  }
}
