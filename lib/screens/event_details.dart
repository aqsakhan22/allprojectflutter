import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/event_program_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';


class EventDetails extends StatefulWidget {

  final String eventImage;
  final String Title;
  final String BannerImage;
  final String Desc;
  final String DateTimefrom;
  final String Type;
 final String RunKM;
 final String RunnerStatus;
 final String Location;
 final String ID;
 final String Body;

  const EventDetails({Key? key, required this.eventImage, required this.Title, required this.BannerImage, required this.Desc, required this.DateTimefrom, required this.Type, required this.RunKM, required this.RunnerStatus, required this.Location, required this.ID, required this.Body,}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    return d; //KM
  }
  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      appBar: AppBarWidget.textAppBar('EVENTS'),
       body: SingleChildScrollView(
         child:  Container(
           padding: EdgeInsets.symmetric(horizontal: 10.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Row(
                 children: [
                   widget.eventImage != null ?
                   CircleAvatar(
                       radius: 25,
                       backgroundColor: Colors.transparent,
                       backgroundImage: NetworkImage("${AppUrl.mediaUrl}${widget.eventImage}")
                     //AssetImage("assets/homeBack2.png")

                   )

                       :
                   CircleAvatar(
                       radius: 25,
                       backgroundColor: Colors.transparent,
                       backgroundImage: AssetImage("assets/RunWith_Icon.png")
                     //AssetImage("assets/homeBack2.png")

                   ),
                   SizedBox(
                     width: 10,
                   ),
                   Text("${widget.Title}", style: TextStyle(color: Colors.white)),
                   SizedBox(
                     width: 10,
                   ),
                   Icon(
                     Icons.add,
                     color: Colors.white,
                   )
                 ],
               ),
               Row(
                 children: [
                   Text(
                     "${widget.DateTimefrom}",
                     style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                   ),
                   Container(
                     height: 25,
                     child: VerticalDivider(
                       color: Colors.white,
                       indent: 3.0,
                       endIndent: 3.0,
                       thickness: 1.0,
                     ),
                   ),
                   Text(
                     "${widget.DateTimefrom}",
                     style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                   ),
                   Container(
                     height: 25,
                     child: VerticalDivider(
                       color: Colors.white,
                       indent: 3.0,
                       endIndent: 3.0,
                       thickness: 1.0,
                     ),
                   ),
                   Text(
                     "${widget.Type.toString().toUpperCase()}",
                     style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                   ),
                   Container(
                     height: 25,
                     child: VerticalDivider(
                       color: Colors.white,
                       indent: 3.0,
                       endIndent: 3.0,
                       thickness: 1.0,
                     ),
                   ),
                   Text(
                     "${widget.RunKM}",
                     style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                   ),
                 ],
               ),
               ClipRRect(
                 borderRadius: BorderRadius.circular(10), // Image border
                 child: SizedBox.fromSize(
                   // size: Size.fromRadius(48), // Image radius
                     child: Image.network("${AppUrl.mediaUrl}${widget.BannerImage}",
                         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                           if (loadingProgress == null) return child;
                           return Center(
                             child: CircularProgressIndicator(
                               value: loadingProgress.expectedTotalBytes != null
                                   ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                   : null,
                             ),
                           );
                         })
                   //Image.asset("assets/events.png",fit: BoxFit.cover,height: 150),
                 ),
               ),
               SizedBox(
                 height: 10,
               ),
               Text(
                 "${widget.Desc}"
                 // "Registration Fees: 3K – \$400 , 5K – \$500 10K – \$700\nInclusive of Race Singlet, Race Bib, Medal, and Loot Bag\n– 10K gets a Finisher’s Shirt "
                 ,
                 style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
               ),
               SizedBox(
                 height: 10,
               ),
               Html(
                 data:widget.Body,
                 style: {
                   'p': Style(color: Colors.white, fontSize: FontSize.medium),
                 },
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ButtonWidget(
                     btnWidth: 100,
                     onPressed: () async {


                       if (widget.RunnerStatus == "") {
                         widget.Type == "Event"
                             ? showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 contentPadding: EdgeInsets.zero,
                                 backgroundColor: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                 title: Text(
                                   "Program Details",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 16),
                                 ),
                                 content: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.stretch,
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Text(
                                         "Description",
                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                       ),
                                       Text(
                                         "${widget.Title} ",
                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                       ),
                                       Text(
                                         "${widget.Desc}",
                                         style: TextStyle(fontSize: 14),
                                       ),
                                     ],
                                   ),
                                 ),
                                 alignment: Alignment.center,
                                 actions: [
                                   Container(
                                     alignment: Alignment.center,
                                     child: ButtonWidget(
                                       onPressed: () {
                                         try {
                                           EasyLoading.show(status: 'Attending...');
                                           CurrentLocation().getCurrentLocation().then((value) async {
                                             if (widget.Location != null) {
                                               double distance = getDistanceFromLatLonInKm(
                                                   double.parse(widget.Location
                                                       .toString()
                                                       .split(",")[0]),
                                                   double.parse(widget.Location
                                                       .toString()
                                                       .split(",")[1]),
                                                   value!.latitude,
                                                   value.longitude);
                                               final Map<String, dynamic> reqBody = {
                                                 "ClubEvent_ID": widget.ID,
                                                 "Status": "Attended",
                                                 "Run_ID": 0,
                                                 "Lat": value.latitude!.toString(),
                                                 "Lng": value.longitude.toString()
                                               };
                                               if (double.parse((distance * 1000).toStringAsFixed(2)) < 100) {
                                                 GeneralResponse response =
                                                 await AppUrl.apiService.clubeventstatus(reqBody);

                                                 EasyLoading.dismiss();
                                                 if (response.status == 1) {
                                                   TopFunctions.showScaffold("${response.message}");
                                                   Navigator.pop(context);
                                                 } else {
                                                   TopFunctions.showScaffold("${response.message}");
                                                   Navigator.pop(context);
                                                 }
                                               } else {

                                                 EasyLoading.dismiss();
                                                 TopFunctions.showScaffold("You Are far away from destination");
                                                 Navigator.pop(context);
                                               }
                                             } else {
                                               EasyLoading.dismiss();
                                               TopFunctions.showScaffold("Events Location is not Found");
                                             }
                                           });
                                         } catch (e) {
                                           EasyLoading.dismiss();
                                           print("Exception is${e}");
                                         }
                                       },
                                       btnWidth: size.width * 0.3,
                                       text: "OK",
                                       color: CustomColor.grey_color,
                                       textcolor: Colors.black,
                                     ),
                                   ),
                                 ],
                               );
                             })
                             : showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 contentPadding: EdgeInsets.zero,
                                 backgroundColor: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                 title: Container(
                                     padding: EdgeInsets.symmetric(vertical: 5.0),
                                     child: Text(
                                       "Program Details",
                                       textAlign: TextAlign.center,
                                       style: TextStyle(fontSize: 16),
                                     )),
                                 content: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.stretch,
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Text(
                                         "Description",
                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                       ),
                                       Text(
                                         "${widget.Title} ",
                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                       ),
                                       Text(
                                         "${widget.Desc}",
                                         style: TextStyle(fontSize: 14),
                                       ),
                                     ],
                                   ),
                                 ),
                                 alignment: Alignment.center,
                                 actions: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Expanded(
                                         child: ButtonWidget(
                                           onPressed: () {
                                             Navigator.pop(context);
                                           },
                                           btnWidth: size.width * 0.3,
                                           text: "Cancel Event",
                                           color: CustomColor.grey_color,
                                           textcolor: Colors.black,
                                           fontSize: 12,
                                         ),
                                       ),
                                       SizedBox(
                                         width: 10,
                                       ),
                                       Expanded(
                                         child: ButtonWidget(
                                           onPressed: () {
                                             Navigator.of(context).pop();

                                             UserPreferences.eventId = widget.ID;
                                             UserPreferences.eventRun = widget.RunKM;
                                             print("Event run is ${UserPreferences.eventRun}");
                                             Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                     builder: (context) => EventProgramRun(
                                                         title: "EVENT PROGRAM",
                                                         EventId: widget.ID
                                                     )));
                                           },
                                           btnWidth: size.width * 0.3,
                                           text: "Event Program",
                                           color: CustomColor.orangeColor,
                                           textcolor: Colors.white,
                                           fontSize: 12,
                                         ),
                                       ),
                                     ],
                                   )
                                 ],
                               );
                             });
                       } else {
                         TopFunctions.showScaffold(" Attended");
                       }
                     },
                     color: CustomColor.grey_color,
                     textcolor: Colors.black,
                     text: "Register",
                     fontweight: FontWeight.w900,
                   ),

                 ],
               )
             ],
           ),
         ),
       )

    );
  }
}

