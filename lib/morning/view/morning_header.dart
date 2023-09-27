import 'dart:io';
import 'package:firebaseflutterproject/bflow/custom_design/my_clipper.dart';
import 'package:firebaseflutterproject/bflow/custom_icons/my_svg_icon.dart';
import 'package:firebaseflutterproject/bflow/my_methods.dart';
import 'package:firebaseflutterproject/bflow/reports_filter.dart';
import 'package:firebaseflutterproject/pdf/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class MorningHeader extends StatelessWidget {
  const MorningHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper(0.7, 0.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF8E1017),
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
              if (Platform.isAndroid) SizedBox(height: 1.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    // Consumer<BaseDataVM>(
                    //   builder: (_, model, __) {
                    //     return GestureDetector(
                    //       onTap: () {
                    //         model.updateDate('');
                    //         model.updateSector('');
                    //         model.updateCompany('');
                    //
                    //         model.updateSectorIndex('');
                    //         model.updateCompanyIndex('');
                    //
                    //         model.mySearch.success = false;
                    //
                    //         Navigator.pop(context);
                    //       },
                    //       child: MySvgIcon(
                    //         iconPath: 'assets/images/back_arrow.svg',
                    //         mHeight: 4.h,
                    //       ),
                    //     );
                    //   },
                    // ),
                    SizedBox(
                      width: 50.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MySvgIcon(
                            iconPath: 'assets/images/morning_news.svg',
                            mHeight: 5.h,
                            color: Color(0xFF8E1017),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              "Morning News",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF8E1017),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
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
              SizedBox(height: 2.h),
              const ReportsFilter(),
            ],
          ),
        ),
      ],
    );
  }
}
