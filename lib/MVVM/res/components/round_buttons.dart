import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
 final  bool loading;
 final VoidCallback onPressed;
  const RoundButton({Key? key, required this.title,  this.loading=false, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading == true ?
        Center(
          child: CircularProgressIndicator(),
        )
        :

      ElevatedButton
      (
        onPressed: onPressed,
        child: Text(title)
    );
  }
}
