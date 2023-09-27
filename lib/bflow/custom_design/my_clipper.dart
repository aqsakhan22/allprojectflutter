import 'package:flutter/cupertino.dart';

class MyClipper extends CustomClipper<Path> {
  double? startHeight;
  double? endHeight;

  MyClipper(double? a, double? b) {
    startHeight = a;
    endHeight = b;
  }

  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);

    var firstControlPoint =
        Offset(size.width * 0.05, size.height * startHeight!);
    var firstEndPoint = Offset(size.width * 0.3, size.height * startHeight!);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width * 0.7, size.height * startHeight!);

    var secondControlPoint =
        Offset(size.width - size.width * 0.05, size.height * startHeight!);
    var secondEndPoint = Offset(size.width, size.height * endHeight!);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

//var firstControlPoint = Offset(size.width * 0.05, size.height * startHeight!);
//     var firstEndPoint = Offset(size.width * 0.3, size.height * 0.8);
//
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);
//
//     path.lineTo(size.width * 0.7, size.height * 0.8);
//
//     var secondControlPoint =
//         Offset(size.width - size.width * 0.05, size.height * 0.8);
//     var secondEndPoint = Offset(size.width, size.height * 0.6);
//
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);
