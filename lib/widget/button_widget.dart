import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? text;
  final String? icon;
  final Color? color;
  final Color? textcolor;
  final double? fontSize;
  final FontWeight? fontweight;
  final double? btnWidth;
  final double? btnHeight;

  const ButtonWidget(
      {Key? key,
      this.onPressed,
      this.text,
      this.icon,
      this.color,
      this.textcolor,
      this.fontSize,
      this.fontweight,
      this.btnWidth,
      this.btnHeight})
      : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: widget.btnWidth,
        height: widget.btnHeight,
        child: FractionallySizedBox(
          child: widget.icon == null
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: widget.color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))
                  ),
                  onPressed: widget.onPressed,
                  child: Text(
                    "${widget.text}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.textcolor,
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontweight),
                  ),
                )
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: widget.color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onPressed: widget.onPressed,
                  icon: widget.icon == null
                      ? SizedBox()
                      : Image.asset(
                          widget.icon!,
                          width: 15,
                        ),
                  label: Text(
                    "${widget.text}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textcolor,
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontweight,
                      // fontStyle: FontStyle.normal
                    ),
                  )),
        ));
  }
}
