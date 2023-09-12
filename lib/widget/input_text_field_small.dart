import 'package:flutter/material.dart';

class TextFieldSmall extends StatelessWidget {
  const TextFieldSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.transparent)),
        fillColor: Colors.white,
        filled: true,
        hintText: "Type Name",
        hintStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}
