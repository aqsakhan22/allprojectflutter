import 'package:flutter/material.dart';

class InputTextFormField extends StatefulWidget {
  final double? widthSie;
  final String? hintText;
  final String? label;
  final double? fontsize;
  final FormFieldValidator<String>? validateData;
  final TextInputType? keyboardType;
  final ValueChanged<String>? valueChange;
  final EdgeInsets? padding;

  const InputTextFormField(
      {Key? key,
      this.padding,
      this.widthSie,
      this.hintText,
      this.label,
      this.fontsize,
      this.validateData,
      this.keyboardType,
      this.valueChange})
      : super(key: key);

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      width: widget.widthSie,
      child: TextFormField(
        validator: widget.validateData,
        keyboardType: widget.keyboardType,
        onChanged: widget.valueChange,
        obscureText: widget.label == "Password" ? true : false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w100),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.white)),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 10.0, color: Colors.white)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            label: Text(
              "${widget.label}",
              style: TextStyle(color: Colors.white, fontSize: widget.fontsize),
            ),
            labelStyle: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200)),
      ),
    );
  }
}
