import 'package:flutter/material.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/widget/button_widget.dart';
class ConfirmationDialog extends StatefulWidget {
  final String? desc;
  final double? textfontsize;
  final double? btnfontsize;
   final Color? textcolor;
   final Color? btncolor ;
   final double? btnWidth;
   final double? btnHeight;
   final double? textWidth;
  final VoidCallback? onClickedYes;
  final VoidCallback? onClickedNo;

  const ConfirmationDialog({Key? key,  this.desc, this.btncolor, this.btnWidth, this.btnHeight, this.textfontsize, this.btnfontsize, this.textcolor, this.textWidth,this.onClickedYes,this.onClickedNo}) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),

      content:
      Container(
      height: 130,


        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.textWidth,

                child: Text("${widget.desc}",textAlign: TextAlign.center, style: TextStyle(color: widget.textcolor,fontSize: widget.textfontsize,fontWeight: FontWeight.w800),)
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                 Container(
                   width: widget.btnWidth,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         elevation: 0.0,
                         backgroundColor: CustomColor.black,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0))),
                     onPressed:  widget.onClickedYes,
                     child: Text("YES",style: TextStyle(fontSize: 14),)),
                 ),
                SizedBox(width: 10,),
                Container(
                  width: widget.btnWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: CustomColor.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed:  widget.onClickedNo,
                    child: Text("NO",style: TextStyle(fontSize: 14),)),
                ),



              ],
            )
          ],
        )
      ),


    );
  }
}
