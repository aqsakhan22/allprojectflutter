import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';


class AppCircle extends StatelessWidget {
  const AppCircle({Key? key, required this.iconUrl, required this.circleHeight})
      : super(key: key);

  final String iconUrl;
  final double circleHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: 5.h,
      decoration: const BoxDecoration(
        color: Color(0xFF8E1017),
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF0013), Color(0xFF8F1218)],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          iconUrl,
          height: circleHeight,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
