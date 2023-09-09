import 'package:flutter/material.dart';
class GoogleMapSample extends StatefulWidget {
  const GoogleMapSample({Key? key}) : super(key: key);

  @override
  State<GoogleMapSample> createState() => _GoogleMapSampleState();
}

class _GoogleMapSampleState extends State<GoogleMapSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Google Map"),
      ),

    );
  }
}
