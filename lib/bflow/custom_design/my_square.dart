import 'package:firebaseflutterproject/bflow/custom_design/my_colors.dart';
import 'package:firebaseflutterproject/bflow/custom_icons/my_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class MySquare extends StatelessWidget {
  const MySquare({Key? key, required this.iconPath, required this.title})
      : super(key: key);

  final String iconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      child: Container(
        decoration: BoxDecoration(
          color: kBoxColor,
          borderRadius: BorderRadius.circular(5.w),
          boxShadow: const [
            BoxShadow(
              color: kLightRed,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MySvgIcon(
              iconPath: iconPath,
              mHeight: 8.h,
              color: kLightRed,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
