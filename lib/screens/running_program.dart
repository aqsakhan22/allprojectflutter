import 'dart:math';

import 'package:flutter/material.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/event_program_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/screens/program_schedule.dart';
import 'package:runwith/screens/programs_video.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

class RunningProgram extends StatefulWidget {
  const RunningProgram({Key? key}) : super(key: key);

  @override
  State<RunningProgram> createState() => _RunningProgramState();
}

class _RunningProgramState extends State<RunningProgram> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  PageController pageController = PageController(viewportFraction: 1 / 2);
  bool value = false;
  int pageChanged = 0;
  List Videos = [];
  List programDetails = [];
  List eventDetails = [];

  Future<void> VideosApi() async {
    try {
      final Map<String, dynamic> reqData = {};
      GeneralResponse response = await AppUrl.apiService.videos(reqData);
      print("[RECEIVE] (videos): ${response.toString()}");
      if (response.status == 1) {
        print("[SUCCESS] (videos): ${response.data}");
        setState(() {
          Videos = response.data as List;
        });
      } else {
        print("[FAILED] (videos): ${response.toString()}");
      }
    } catch (e) {
      print("[EXCEPTION] (videos) ${e}");
    }
  }

  Future<void> runningProgram() async {
    try {
      final Map<String, dynamic> reqBody = {"Club_ID": UserPreferences.clubId};
      GeneralResponse response = await AppUrl.apiService.clubprograms(reqBody);
      setState(() {
        programDetails = response.data as List;
      });
      print("program details is ${programDetails}");
    } catch (e) {
      print("Exception runningProgram ${e}");
    }
  }

  Future<void> runningEvents() async {
    try {
      final Map<String, dynamic> reqBody = {"Club_ID": UserPreferences.clubId};
      GeneralResponse response = await AppUrl.apiService.clubevents(reqBody);
      setState(() {
        eventDetails = response.data as List;
      });
    } catch (e) {
      print("Exception runningProgram ${e}");
    }
  }

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
  void initState() {
    // TODO: implement initState
    print("club id is ${UserPreferences.clubId}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (UserPreferences.runType.isNotEmpty) {
        print("isRunning noit empty");
        if (UserPreferences.runType == "Casual" && UserPreferences.isRunning == true) {
          Navigator.pushNamed(context, "/StartRun");
        }
        if (UserPreferences.runType == "RUN PROGRAM" && UserPreferences.isRunning == true) {
          print(
              "Program Run timer is  ${UserPreferences.runProgramtimer} programid ${UserPreferences.programId} ${UserPreferences.programRun} min ");
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventProgramRun(
                        programId: UserPreferences.programId,
                        title: "${UserPreferences.runType}",
                      )));
        }
        if (UserPreferences.runType == "EVENT PROGRAM" && UserPreferences.isRunning == true) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventProgramRun(
                        EventId: UserPreferences.eventId,
                        title: "${UserPreferences.runType}",
                      )));
        }
      }
      VideosApi();
      runningProgram();
      runningEvents();
    });
    super.initState();
    print("club id is ${UserPreferences.clubId}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      appBar: AppBarWidget.textAppBar(
        "RUNNING PROGRAM",
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "PERSONAL PROGRAM",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 8,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
                                  color: Colors.white,
                                ),
                                // height: size.height * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Program Schedule",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      // height:270,
                                      child: programDetails.isEmpty
                                          ? Center(
                                              child: Text(
                                                "No Programs",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            )
                                          : ListView.builder(
                                              physics: ScrollPhysics(),
                                              padding: EdgeInsets.symmetric(vertical: 10.0),
                                              shrinkWrap: true,
                                              itemCount: programDetails.length,
                                              itemBuilder: (BuildContext context, int parentIndex) {
                                                return Container(
                                                    child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    programDetails[parentIndex]['ProgramContent'] != null
                                                        ? Text(
                                                            "${programDetails[parentIndex]['Title']}",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    programDetails[parentIndex]['ProgramContent'] != null
                                                        ? ListView.builder(
                                                            padding: EdgeInsets.zero,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                (programDetails[parentIndex]['ProgramContent'] as List).length,
                                                            itemBuilder: (BuildContext context, int childIndex) {
                                                              return SizedBox(
                                                                height: 35,
                                                                child: Row(
                                                                  children: [
                                                                    Checkbox(
                                                                      value: programDetails[parentIndex]['ProgramContent']
                                                                                  [childIndex]['RunnerStatus'] ==
                                                                              null
                                                                          ? false
                                                                          : true,
                                                                      activeColor: Colors.black,
                                                                      // fillColor: MaterialStateProperty.all(Colors.orange),
                                                                      onChanged: programDetails[parentIndex]['ProgramContent']
                                                                                  [childIndex]['Type'] ==
                                                                              "Neutral"
                                                                          ? (value1) {}
                                                                          : (value1) {
                                                                              print("VALUE IS ${value1}");

                                                                              setState(() {
                                                                                programDetails[parentIndex]['ProgramContent']
                                                                                            [childIndex]['Type'] ==
                                                                                        "Manual"
                                                                                    ? programDetails[parentIndex]
                                                                                            ['ProgramContent'][childIndex]
                                                                                        ['RunnerStatus'] = true
                                                                                    : programDetails[parentIndex]
                                                                                            ['ProgramContent'][childIndex]
                                                                                        ['RunnerStatus'] = false;
                                                                              });

                                                                              programDetails[parentIndex]['ProgramContent']
                                                                                          [childIndex]['Type'] ==
                                                                                      "Automatic"
                                                                                  ? showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          contentPadding: EdgeInsets.zero,
                                                                                          backgroundColor: Colors.white,
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius:
                                                                                                  BorderRadius.circular(10.0)),
                                                                                          title: Container(
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                  vertical: 5.0),
                                                                                              child: Text(
                                                                                                "Program Details",
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(fontSize: 16),
                                                                                              )),
                                                                                          content: StatefulBuilder(
                                                                                              builder: (context, setState) {
                                                                                            return Padding(
                                                                                              padding: const EdgeInsets.symmetric(
                                                                                                  horizontal: 10.0,
                                                                                                  vertical: 10.0),
                                                                                              child: Column(
                                                                                                crossAxisAlignment:
                                                                                                    CrossAxisAlignment.stretch,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "Description",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontWeight:
                                                                                                            FontWeight.w600),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "Day is ${programDetails[parentIndex]['ProgramContent'][childIndex]['Day']}",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontWeight:
                                                                                                            FontWeight.w400),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "${programDetails[parentIndex]['ProgramContent'][childIndex]['Description']}",
                                                                                                    style:
                                                                                                        TextStyle(fontSize: 14),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    mainAxisAlignment:
                                                                                                        MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: ButtonWidget(
                                                                                                          onPressed: () {
                                                                                                            setState(() {
                                                                                                              programDetails[parentIndex]
                                                                                                                          [
                                                                                                                          'ProgramContent']
                                                                                                                      [childIndex]
                                                                                                                  [
                                                                                                                  'RunnerStatus'] = false;
                                                                                                            });
                                                                                                            Navigator.pop(
                                                                                                                context);

                                                                                                            print(
                                                                                                                "RunnerStatus ${programDetails[parentIndex]['ProgramContent'][childIndex]['RunnerStatus']}");
                                                                                                          },
                                                                                                          btnWidth:
                                                                                                              size.width * 0.3,
                                                                                                          text: "Cancel Program",
                                                                                                          color: CustomColor
                                                                                                              .grey_color,
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
                                                                                                            Navigator.of(context)
                                                                                                                .pop();
                                                                                                            UserPreferences
                                                                                                                .programId = programDetails[
                                                                                                                        parentIndex]
                                                                                                                    [
                                                                                                                    'ProgramContent']
                                                                                                                [
                                                                                                                childIndex]['ID'];
                                                                                                            UserPreferences
                                                                                                                .programRun = programDetails[
                                                                                                                        parentIndex]
                                                                                                                    [
                                                                                                                    'ProgramContent']
                                                                                                                [
                                                                                                                childIndex]['Run'];
                                                                                                            Navigator.push(
                                                                                                                context,
                                                                                                                MaterialPageRoute(
                                                                                                                    builder:
                                                                                                                        (context) =>
                                                                                                                            EventProgramRun(
                                                                                                                              day:
                                                                                                                                  programDetails[parentIndex]['ProgramContent'][childIndex]['Day'],
                                                                                                                              desc:
                                                                                                                                  programDetails[parentIndex]['ProgramContent'][childIndex]['Description'],
                                                                                                                              title:
                                                                                                                                  "RUN PROGRAM",
                                                                                                                              Run:
                                                                                                                                  programDetails[parentIndex]['ProgramContent'][childIndex]['Run'],
                                                                                                                              programId:
                                                                                                                                  programDetails[parentIndex]['ProgramContent'][childIndex]['ID'],
                                                                                                                            )));
                                                                                                          },
                                                                                                          btnWidth:
                                                                                                              size.width * 0.3,
                                                                                                          text: "Run Program",
                                                                                                          color: CustomColor
                                                                                                              .orangeColor,
                                                                                                          textcolor: Colors.white,
                                                                                                          fontSize: 12,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          }),
                                                                                          alignment: Alignment.center,
                                                                                        );
                                                                                      })
                                                                                  : showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          contentPadding: EdgeInsets.zero,
                                                                                          backgroundColor: Colors.white,
                                                                                          shape: RoundedRectangleBorder(
                                                                                              borderRadius:
                                                                                                  BorderRadius.circular(10.0)),
                                                                                          title: Text(
                                                                                            "Program Details",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontSize: 16),
                                                                                          ),
                                                                                          content: Padding(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                                horizontal: 10.0, vertical: 10.0),
                                                                                            child: Column(
                                                                                              crossAxisAlignment:
                                                                                                  CrossAxisAlignment.stretch,
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: [
                                                                                                Text(
                                                                                                  "Description",
                                                                                                  style: TextStyle(
                                                                                                      fontSize: 14,
                                                                                                      fontWeight:
                                                                                                          FontWeight.w600),
                                                                                                ),
                                                                                                Text(
                                                                                                  "${programDetails[parentIndex]['ProgramContent'][childIndex]['Day']} ",
                                                                                                  style: TextStyle(
                                                                                                      fontSize: 14,
                                                                                                      fontWeight:
                                                                                                          FontWeight.w400),
                                                                                                ),
                                                                                                Text(
                                                                                                  "${programDetails[parentIndex]['ProgramContent'][childIndex]['Description']}",
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
                                                                                                onPressed: () async {
                                                                                                  try {
                                                                                                    CurrentLocation()
                                                                                                        .getCurrentLocation()
                                                                                                        .then((value) async {
                                                                                                      final Map<String, dynamic>
                                                                                                          reqBody = {
                                                                                                        "ClubProgramDesc_ID":
                                                                                                            programDetails[
                                                                                                                        parentIndex]
                                                                                                                    [
                                                                                                                    'ProgramContent']
                                                                                                                [
                                                                                                                childIndex]['ID'],
                                                                                                        "Status": "Completed",
                                                                                                        "Run_ID": 0,
                                                                                                        "Lat": value!.latitude!
                                                                                                            .toString(),
                                                                                                        "Lng": value.longitude
                                                                                                            .toString()
                                                                                                      };
                                                                                                      print(
                                                                                                          "req body is ${reqBody}");
                                                                                                      GeneralResponse response =
                                                                                                          await AppUrl.apiService
                                                                                                              .clubprogramstatus(
                                                                                                                  reqBody);

                                                                                                      if (response.status == 1) {
                                                                                                        TopFunctions.showScaffold(
                                                                                                            "${response.message}");
                                                                                                        Navigator.pop(context);
                                                                                                      }
                                                                                                    });
                                                                                                  } catch (e) {}
                                                                                                },
                                                                                                btnWidth: size.width * 0.3,
                                                                                                text: "OK",
                                                                                                color: CustomColor.grey_color,
                                                                                                textcolor: Colors.black,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      });
                                                                            },
                                                                    ),
                                                                    Container(
                                                                        width: 30,
                                                                        child: Text(
                                                                          "${programDetails[parentIndex]['ProgramContent'][childIndex]['Day']}",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 12),
                                                                        )),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        "${programDetails[parentIndex]['ProgramContent'][childIndex]['Title']}",
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 12),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            })
                                                        : SizedBox()
                                                  ],
                                                ));
                                              }),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            backgroundColor: CustomColor.grey_color,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                                        onPressed: () {
                                          print("program details is ${programDetails}");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ProgramScehdule(
                                                        programschedule: programDetails,
                                                      )));
                                        },
                                        child: Text("View Programs",
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)))
                                  ],
                                ))),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // height: size.height * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Events",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Expanded(
                                      child: eventDetails.isEmpty
                                          ? Center(
                                              child: Text(
                                                "No Events",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            )
                                          : ListView.builder(
                                              physics: ScrollPhysics(),
                                              itemCount: eventDetails.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                DateTime startDate_DT = DateTime.now();
                                                DateTime endDate_DT = DateTime.parse("${eventDetails[index]['DateTimeFrom']}");
                                                Duration diff = endDate_DT.difference(startDate_DT);
                                                print("First Date :" + startDate_DT.toString());
                                                print("Second Date :" + endDate_DT.toString());
                                                print("Difference in Days: " + diff.inDays.toString());
                                                print("Difference in Hours: " + diff.inHours.toString());
                                                print("Difference in Minutes: " + diff.inMinutes.toString());
                                                print("Difference in Seconds: " + diff.inSeconds.toString());
                                                int days = diff.inDays;
                                                int hours = diff.inHours % 24;
                                                int minutes = diff.inMinutes % 60;
                                                int seconds = diff.inSeconds % 60;
                                                print("$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).");
                                                // Get The Time Difference Between Two Dates
                                                return Container(
                                                    padding: EdgeInsets.only(bottom: 5.0, top: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(10), // Image border
                                                          child: SizedBox.fromSize(
                                                            size: Size.fromRadius(40), // Image radius
                                                            child: Image.network(
                                                              "${AppUrl.mediaUrl}${eventDetails[index]['Banner']}",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                flex: 5,
                                                                child: Text(
                                                                  "${eventDetails[index]['Title']}",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 8,
                                                                      fontWeight: FontWeight.w600),
                                                                )),
                                                            Expanded(
                                                                flex: 7,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
                                                                        // width: 30,
                                                                        // decoration: BoxDecoration(
                                                                        //     color: CustomColor.grey_color,
                                                                        //     boxShadow: [
                                                                        //       BoxShadow(
                                                                        //           color: Colors.black.withOpacity(0.2),
                                                                        //           // shadow color
                                                                        //           blurRadius: 20,
                                                                        //           // shadow radius
                                                                        //           offset: Offset(0, 4),
                                                                        //           // shadow offset
                                                                        //           spreadRadius: 0.1,
                                                                        //           // The amount the box should be inflated prior to applying the blur
                                                                        //           blurStyle: BlurStyle.normal // set blur style
                                                                        //       ),
                                                                        //     ]),
                                                                        child: Column(
                                                                          children: [
                                                                            Text("${days}",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w600)),
                                                                            Text("DAYS",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 5,
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(" : ",
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 8,
                                                                            fontWeight: FontWeight.w600)),
                                                                    Expanded(
                                                                      child: Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                                                                        // width: 30,
                                                                        // decoration: BoxDecoration(
                                                                        //     color: CustomColor.grey_color,
                                                                        //     boxShadow: [
                                                                        //       BoxShadow(
                                                                        //           color: Colors.black.withOpacity(0.2),
                                                                        //           // shadow color
                                                                        //           blurRadius: 20,
                                                                        //           // shadow radius
                                                                        //           offset: Offset(0, 4),
                                                                        //           // shadow offset
                                                                        //           spreadRadius: 0.1,
                                                                        //           // The amount the box should be inflated prior to applying the blur
                                                                        //           blurStyle: BlurStyle.normal // set blur style
                                                                        //       ),
                                                                        //     ]),
                                                                        child: Column(
                                                                          children: [
                                                                            Text("${hours}",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w600)),
                                                                            Text("HOURS",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 5,
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(" : ",
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 8,
                                                                            fontWeight: FontWeight.w600)),
                                                                    Expanded(
                                                                      child: Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                                                                        // width: 30,
                                                                        // decoration: BoxDecoration(
                                                                        //     color: CustomColor.grey_color,
                                                                        //     boxShadow: [
                                                                        //       BoxShadow(
                                                                        //           color: Colors.black.withOpacity(0.2),
                                                                        //           // shadow color
                                                                        //           blurRadius: 20,
                                                                        //           // shadow radius
                                                                        //           offset: Offset(0, 4),
                                                                        //           // shadow offset
                                                                        //           spreadRadius: 0.1,
                                                                        //           // The amount the box should be inflated prior to applying the blur
                                                                        //           blurStyle: BlurStyle.normal // set blur style
                                                                        //       ),
                                                                        //     ]),
                                                                        child: Column(
                                                                          children: [
                                                                            Text("${minutes}",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w600)),
                                                                            Text("MINS",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 5,
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ));
                                              })),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: CustomColor.grey_color,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/ViewEvents');
                                      },
                                      child: Text("View Events",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)))
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "VIDEO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 1,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              pageController.animateToPage(--pageChanged,
                                  duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                            },
                            icon: Icon(
                              Icons.arrow_left_sharp,
                              color: Colors.white,
                              size: 48,
                            )),

                        Expanded(
                          child: Videos.isEmpty
                              ? Center(
                                  child: Text(
                                    "No Videos",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(
                                  // width: size.width * 0.5,
                                  height: 100,
                                  child: PageView.builder(
                                    // pageSnapping: true,
                                    padEnds: false,
                                    scrollDirection: Axis.horizontal,
                                    controller: pageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        pageChanged = index;
                                      });
                                      print(pageChanged);
                                    },
                                    itemCount: Videos.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ProgramVideos(
                                                        name: "${Videos[index]['Title']}",
                                                        mediaUrl: "${AppUrl.mediaUrl}${Videos[index]['URL']}",
                                                        desc: "${Videos[index]['Description']}",
                                                        imgUrl: "${AppUrl.mediaUrl}${Videos[index]['BannerImage']}",
                                                      )));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center, // padding: EdgeInsets.only(right: .0),

                                                child: Image.network(
                                                    "${AppUrl.mediaUrl}${Videos[index]['BannerImage']}",
                                                    height: 150,
                                                    fit: BoxFit.cover, loadingBuilder:
                                                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                      child: CircularProgressIndicator(
                                                    color: Colors.orange,
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ));
                                                }),
                                              ),
                                              Container(
                                                alignment: Alignment.center,

                                                //alignment: Alignment.center,
                                                child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: Colors.orangeAccent, // color: Colors.red,

                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 24,
                                                      color: Colors.black,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),

                        // Expanded(
                        //   child:    Container(
                        //
                        //   // width: size.width * 0.5,
                        //   height: 100,
                        //   child:
                        //
                        //
                        //
                        //   PageView.builder(
                        //     // pageSnapping: true,
                        //     padEnds: false,
                        //     scrollDirection: Axis.horizontal,
                        //     controller:pageController,
                        //     onPageChanged: (index) {
                        //       setState(() {
                        //         pageChanged = index;
                        //       });
                        //       print(pageChanged);
                        //     },
                        //     itemCount: videoList.length,
                        //     itemBuilder: (BuildContext context, int index) {
                        //      return  GestureDetector(
                        //        onTap: (){
                        //          Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramVideos(
                        //              name: videoList[index]['name']!,
                        //              mediaUrl:videoList[index]['media_url']!
                        //
                        //          ))
                        //          );
                        //        },
                        //        child:  Container(
                        //          margin: EdgeInsets.only(right: 5),
                        //
                        //          child: Stack(
                        //            children: [
                        //              Container(
                        //                  alignment: Alignment.center  ,
                        //                  child: Image.network("${videoList[index]['thumb_url']}",fit: BoxFit.cover,)),
                        //
                        //              Container(
                        //                alignment: Alignment.center,
                        //
                        //                //alignment: Alignment.center,
                        //                child: CircleAvatar(
                        //                    radius: 15,
                        //                    backgroundColor: Colors.orangeAccent,
                        //                    // color: Colors.red,
                        //
                        //                    child: Icon(Icons.play_arrow,size: 24,color: Colors.black,)),
                        //              )
                        //            ],
                        //          )
                        //
                        //          ,),
                        //      )
                        //
                        //      ;
                        //
                        //     },
                        //
                        //
                        //
                        //
                        //   ),
                        // ), )

                        IconButton(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              pageController.animateToPage(++pageChanged,
                                  duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
                            },
                            icon: Icon(
                              Icons.arrow_right_sharp,
                              color: Colors.white,
                              size: 48,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
