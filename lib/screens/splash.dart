import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          width: 500,
          height:500,
          child: Image.asset(
            "assets/RunWith-WhiteLogo.png",
            height: 500,
            width: 500,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
