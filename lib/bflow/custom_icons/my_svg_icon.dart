import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MySvgIcon extends StatelessWidget {
  const MySvgIcon(
      {Key? key, required this.iconPath, required this.mHeight, this.color})
      : super(key: key);

  final String iconPath;
  final double mHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
      height: mHeight,
      fit: BoxFit.contain,
    );
  }
}
