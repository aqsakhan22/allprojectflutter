import 'dart:io';
import 'package:firebaseflutterproject/bflow/custom_design/my_clipper.dart';
import 'package:firebaseflutterproject/bflow/custom_icons/my_svg_icon.dart';
import 'package:firebaseflutterproject/bflow/my_methods.dart';
import 'package:firebaseflutterproject/pdf/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';


class MyCurveDesign extends StatelessWidget {
  const MyCurveDesign({
    Key? key,
    this.valueX,
    this.valueY,
    this.iconPath,
    this.title,
  }) : super(key: key);

  final double? valueX;
  final double? valueY;
  final String? iconPath;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper(valueX ?? 0.7, valueX ?? 0.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.grey,
                  const Color(0xFFCFD1D2).withOpacity(0.3),
                  Color(0xFF8E1017),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    // GestureDetector(
                    //   onTap: () => Navigator.pop(context),
                    //   child: MySvgIcon(
                    //     iconPath: 'assets/images/back_arrow.svg',
                    //     mHeight: 4.h,
                    //   ),
                    // ),
                    (title!.contains('Profile'))
                        ? GestureDetector(
                            onTap: () async {
                              return await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text(
                                    "Are you sure you want to log out?",
                                    style: TextStyle(color: Color(0xFF8E1017)),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(_).pop(false),
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => exit(0),
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () => MyMethods().launchDialer(),
                                child: MySvgIcon(
                                  iconPath: 'assets/images/phone.svg',
                                  mHeight: 3.h,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const ProfileScreen(),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: MySvgIcon(
                                  iconPath: 'assets/images/person.svg',
                                  mHeight: 4.h,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MySvgIcon(
                    iconPath: iconPath ?? "",
                    mHeight: 5.h,
                    color: Colors.red,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
