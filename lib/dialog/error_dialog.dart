import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/widget/button_widget.dart';
import '../theme/color.dart';
import '../utility/top_level_variables.dart';

class ErrorDialog extends StatefulWidget {
  final String description;

  const ErrorDialog({Key? key, required this.description}) : super(key: key);

  @override
  _ErrorDialog createState() => _ErrorDialog();
}

class _ErrorDialog extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return

      AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        content:
        Container(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              Text("Error",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),

                Text(
                    widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                )
              ,

            ],
          ),
        ),
        actions: [
          Container(
              alignment: Alignment.center ,

              child: ButtonWidget(
                onPressed: (){
                  Navigator.pop(context);
                },
                color: CustomColor.grey_color,
                textcolor: Colors.black,
                text: "OK",
                fontweight: FontWeight.w600,
              )

          )
        ],
      );
  }
}

bool isErrorDialogShowing = false;

showErrorDialog(String errorDetail) {
  CustomProgressDialog.hideProDialog();
  if (!isErrorDialogShowing) {
    isErrorDialogShowing = true;
    showDialog(
        barrierDismissible: false,
        context: TopVariables.appNavigationKey.currentContext!,
        builder: (BuildContext context) {
          return ErrorDialog(
            description: errorDetail,
          );
        });
  }
}
