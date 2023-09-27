import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:firebaseflutterproject/pdf/view/pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';
import '../morning.dart';


class MorningList extends StatelessWidget {
  const MorningList({Key? key, this.researchData, this.searchData})
      : super(key: key);

  final ResearchData? researchData;
  final SearchData? searchData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Morning list on tap is");
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: PDFScreen(
            researchData: researchData,
            searchData: searchData,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 13.w),
              child: Container(
                height: 17.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7E8EA),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF707070),
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: View(researchData: researchData, searchData: searchData),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Container(
                height: 13.h,
                width: 28.w,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/bma_logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class View extends StatefulWidget {
  const View({Key? key, this.researchData, this.searchData}) : super(key: key);

  final ResearchData? researchData;
  final SearchData? searchData;

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  String date = '';

  @override
  void initState() {
    super.initState();

    try {
      if (widget.researchData?.createdAt != null) {
        DateTime dateTime = DateTime.parse(widget.researchData!.createdAt!);
        date = DateFormat('EEE, d MMM yyyy HH:mm:ss').format(dateTime);
      } else if (widget.searchData?.createdAt != null) {
        DateTime dateTime = DateTime.parse(widget.searchData!.createdAt!);
        date = DateFormat('EEE, d MMM yyyy HH:mm:ss').format(dateTime);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.researchData?.title ?? widget.searchData?.title ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFFC3161C),
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 7.sp,
            ),
          ),
          Text(
            widget.researchData?.description ??
                widget.searchData?.description ??
                "",
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              color: const Color(0xFF231F20),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }
}
