import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:runwith/dialog/confirmation_dialogbox.dart';
import 'package:runwith/dialog/progress_dialog.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/run_provider.dart';
import 'package:runwith/screens/finish_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/services/background.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

//Todo don't remove the better player code will be use in future if we needed
class EventProgramRun extends StatefulWidget {
  final String? title;
  final String? day;
  final String? desc;
  final String? Run;
  final String? programId;
  final String? EventId;
  final String? EventRun;


  const EventProgramRun({Key? key, this.title, this.day, this.desc, this.Run, this.programId, this.EventId, this.EventRun}) : super(key: key);

  @override
  State<EventProgramRun> createState() => _EventProgramRunState();
}

class _EventProgramRunState extends State<EventProgramRun> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late GoogleMapController mapController;
  String TrackId = "yaha track id use huig";

  // LatLng _initialPosition = LatLng(24.9517415, 67.1229219);

  Timer? timer;
  static Duration myDuration = const Duration(seconds: 0);
  int counter = 0;
  double distance = 0.0;
  double pace = 0.0;
  double speed = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;

  List<double?> distanceValue = [];
  bool _loading = false;
  bool _connected = false;
  String clientId = "f40605796f48441cbb8517a7c52146d6";
  String RedirectUrl = "spotifyconnection://app.runwith.io/spotify.php";
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true,
    ),
  );
  late ImageUri? currentTrackImageUri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("Event Run Program ${UserPreferences.eventId} ${UserPreferences.TripLocations}");
      if(UserPreferences.runType.isNotEmpty){
        TopVariables.service.on(actionRunningProgress).listen((event) {
          // Call Function
          print("Update Run API Called In Frontend In EVENT PROGRAM");
          RunProvider().updateRun().then((value) {
            print("Updating Map After Updating Data To Server");
            updateMap(value);
          });
        });
        if (UserPreferences.runType == "RUN PROGRAM" && UserPreferences.isRunning == true && UserPreferences.runProgramtimer > 0) {
          print("Timer will be started");
          myDuration = Duration(seconds: UserPreferences.runProgramtimer);
          startTimer();
        }
        if (UserPreferences.runType == "RUN PROGRAM" && UserPreferences.isRunning == true && UserPreferences.runProgramtimer > 0) {
          print("Timer will be started");
          myDuration = Duration(seconds: UserPreferences.runProgramtimer);
          startTimer();
        }
        if(UserPreferences.runType == "RUN PROGRAM" && UserPreferences.isRunning == true ){


        }




      }

    });



  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // timer!.cancel();
  }

  TimeStart() {
    int RunSeconds = int.parse(widget.Run.toString()) * 60;
    myDuration = Duration(seconds: RunSeconds);
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => timer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(seconds: 0));
  }

  void setCountDown() {
    final reduceSecondsBy = 1;

    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      UserPreferences.runProgramtimer = seconds;
      if (seconds < 0) {
        timer!.cancel();
        myDuration = Duration(seconds: 0);
        UserPreferences.runProgramtimer = 0;
        finishRun();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inDays > 0 ? (myDuration.inDays * 24) + myDuration.inHours.remainder(24) : myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: MyNavigationDrawer(),
        key: _key,
        appBar: AppBarWidget.textAppBar(
          '${widget.title == null ? "CASUAL RUN" : widget.title}',
        ),
        body:StreamBuilder<ConnectionStatus>(
          stream: SpotifySdk.subscribeConnectionStatus(),
            builder: (context, snapshot) {
              _connected = false;
              var data = snapshot.data;
              print("Data is ${data}");
              if (data != null) {
                print("data value is ${data.connected}");
                _connected = data.connected;
              }

              return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child:   Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //spotify button
                        Container(
                          // width: size.width * 0.8,
                            height: 45,
                            child:  _connected == false ?
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColor.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  // connectToSpotifyRemote();
                                  getAccessToken();
                                },
                                icon: Image.asset(
                                  "assets/spotify.png",
                                  height: 20,
                                ),
                                label: Text("Connect with spotify"))
                                :
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColor.subBtn,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  disconnect();
                                },
                                icon: Image.asset(
                                  "assets/spotify.png",
                                  height: 20,
                                ),
                                label: Text("Disconnect with spotify"))

                        ),
                        //spotify cards
                        _connected ? _buildPlayerStateWidget() : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        //meters
                        Container(
                          height: size.height * 0.15,
                          decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TOTAL DISTANCE RUN",
                                style: TextStyle(color: Colors.black, fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${(distance * 1000).toStringAsFixed(2)} meters",
                                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //3 cards
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: size.height * 0.14,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Text(
                                            "Your running speed is",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${speed.toStringAsFixed(2)} km/hr",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: size.height * 0.14,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Text(
                                            "Your pace is",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        //pace = time / distance
                                        Text(
                                          " ${pace.toStringAsFixed(2)} min/km",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: size.height * 0.14,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Text(
                                            "Your running time is:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${(counter / 60).round()} min",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        (widget.title == "RUN PROGRAM")
                            ? Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            height: size.height * 0.3,
                            decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: UserPreferences.isRunning == false
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "PROGRAM DETAILS:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    child: Text(
                                      "Description",
                                      style: TextStyle(color: CustomColor.black, fontSize: 14, fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${widget.desc}",
                                  style: TextStyle(color: CustomColor.black),
                                ),
                              ],
                            )
                                : Container(
                              alignment: Alignment.center,
                              width: size.width,
                              child: Text(
                                "${"${hours}:${minutes}:${seconds}"}",
                                style: TextStyle(color: Colors.red, fontSize: 45, fontWeight: FontWeight.w800),
                              ),
                            ))
                            : SizedBox(),

                        //for Event Program distance show
                        widget.title == "EVENT PROGRAM"
                            ? Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: size.height * 0.3,
                          decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(10.0)),
                          alignment: Alignment.center,
                          child: Text(
                            "${(distance * 1000).toStringAsFixed(2)} meters",
                            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                        )
                            : SizedBox(),

                        //Run Program buttons
                        widget.title == "RUN PROGRAM"
                            ? Column(
                          children: [
                            UserPreferences.isRunning == false
                                ? Container(
                              width: size.width,
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {

                                  CustomProgressDialog.showProDialog();
                                  CurrentLocation().getCurrentLocation().then((value) async {
                                    print("Current Location Is: ${value!.latitude}/${value.longitude}");
                                    final Map<String, dynamic> reqBody = {
                                      'User_ID': "${UserPreferences.get_Profiledata()['ID'].toString()}",
                                      "Linked_ID": widget.programId, "RunType": "Program",
                                      'StartDateTime': DateTime.now().toString(),
                                      'StartLatLng': "${value.latitude},${value.longitude}"
                                    };
                                    print("Sending Data To startrun() PROGRAM: ${reqBody}");
                                    try {
                                      final response = await AppUrl.apiService.startrun(reqBody);
                                      print("Receiving Data To startrun(): ${response.toString()}");

                                      CustomProgressDialog.hideProDialog();
                                      if (response.status == 1) {
                                        RunProvider.counter=0;
                                        RunProvider().setCounter();
                                        print("response.status == 1");
                                        await initializeService().then((value) {

                                          TopVariables.service.startService().then((value) {
                                            //Run After Service Start
                                            print("Background Service Started In Foreground In Start_Run");

                                            UserPreferences.RemovePrefs("triplocations");
                                            setState(() {
                                              UserPreferences.isRunning = true;
                                              UserPreferences.isRunningPause = false;
                                              UserPreferences.RunId = response.data['Run_ID'].toString();
                                              UserPreferences.runType = "RUN PROGRAM";
                                            });

                                            TopVariables.service.invoke(actionStartRunning, {
                                              "updateInterval": 5,
                                            });
                                            TimeStart();

                                            TopVariables.service.on(actionRunningProgress).listen((event) {
                                              // Call Function
                                              print("Update Run API Called In Frontend In Start_Run");
                                              RunProvider().updateRun().then((value) {
                                                print("Updating Map After Updating Data To Server");
                                                updateMap(value);
                                              });
                                            });

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                    "${response.message}",
                                                    style: TextStyle(color: Colors.white),
                                                  )),
                                            );

                                            CustomProgressDialog.hideProDialog();
                                          });
                                        });
                                      } else {
                                        print("Failed Data To startrun: ${response.toString()}");
                                        CustomProgressDialog.hideProDialog();
                                      }
                                    } catch (e) {
                                      print("Exception Error: startrun(): ${e.toString()}");
                                      CustomProgressDialog.hideProDialog();
                                    }
                                  });
                                },
                                child: Text(
                                  "START PROGRAM",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(primary: CustomColor.grey_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 120,
                                  height: size.height * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        UserPreferences.isRunningPause = !UserPreferences.isRunningPause;
                                      });
                                    },
                                    child: Text(
                                      "${UserPreferences.isRunningPause == false ? "PAUSE RUN" : "CONTINUE RUN"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    style: ElevatedButton.styleFrom(primary: CustomColor.grey_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    height: size.height * 0.05,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmationDialog(
                                                  onClickedYes: () {
                                                    CustomProgressDialog.showProDialog();
                                                    print("Run Finish Called");
                                                    finishRun();
                                                    myDuration = Duration(seconds: 0);
                                                    UserPreferences.runProgramtimer = 0;

                                                    // Navigator.pop(context);
                                                  },
                                                  onClickedNo: () {
                                                    Navigator.pop(context);
                                                  },
                                                  btnWidth: 70,
                                                  btnHeight: 30,
                                                  desc: 'Are you sure you want to finish run?',
                                                  textWidth: size.width * 0.6,
                                                  textcolor: Colors.black,
                                                  btncolor: Colors.black,
                                                  textfontsize: 14,
                                                  btnfontsize: 14,
                                                );
                                              });
                                        },
                                        child: Text(
                                          "FINISH RUN",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: CustomColor.grey_color,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        ))),
                              ],
                            )
                          ],
                        )
                            : SizedBox(),

                        //Event Program checks button start and finish etc
                        widget.title == "EVENT PROGRAM"
                            ? Column(
                          children: [
                            UserPreferences.isRunning == false
                                ? Container(
                              width: size.width,
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {
                                  print("EVENT PROGRAM ${widget.EventId} ${UserPreferences.eventRun}KM");
                                  // CustomProgressDialog.showProDialog();
                                  CurrentLocation().getCurrentLocation().then((value) async {


                                    final Map<String, dynamic> reqBody = {'User_ID': "${UserPreferences.get_Profiledata()['ID'].toString()}", "Linked_ID": widget.EventId, "RunType": "Event", 'StartDateTime': DateTime.now().toString(), 'StartLatLng': "${value!.latitude},${value.longitude}"};
                                    print("Sending Data To startrun() Event: ${reqBody}");
                                    try {
                                      final response = await AppUrl.apiService.startrun(reqBody);
                                      CustomProgressDialog.hideProDialog();
                                      if (response.status == 1) {
                                        RunProvider.counter=0;
                                        RunProvider().setCounter();
                                        print("response.status == 1");
                                        await initializeService().then((value) {

                                          TopVariables.service.startService().then((value) {
                                            //Run After Service Start
                                            print("Background Service Started In Foreground In Start_Run");
                                            print("Started Run_ID Is: ${response.data['Run_ID']}");

                                            UserPreferences.RemovePrefs("triplocations");
                                            setState(() {
                                              UserPreferences.isRunning = true;
                                              UserPreferences.isRunningPause = false;
                                              UserPreferences.RunId = response.data['Run_ID'].toString();
                                              UserPreferences.runType = "EVENT PROGRAM";
                                            });

                                            TopVariables.service.invoke(actionStartRunning, {
                                              "updateInterval": 5,
                                            });

                                            TopVariables.service.on(actionRunningProgress).listen((event) {
                                              // Call Function
                                              print("Update Run API Called In Frontend In Start_Run");
                                              RunProvider().updateRun().then((value) {
                                                print("Updating Map After Updating Data To Server");
                                                updateMap(value);
                                              });
                                            });

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                    "${response.message}",
                                                    style: TextStyle(color: Colors.white),
                                                  )),
                                            );

                                            CustomProgressDialog.hideProDialog();
                                          });
                                        });
                                      } else {
                                        print("Failed Data To startrun: ${response.toString()}");
                                        CustomProgressDialog.hideProDialog();
                                      }
                                    } catch (e) {
                                      print("Exception Error: startrun(): ${e.toString()}");
                                      CustomProgressDialog.hideProDialog();
                                    }
                                  });
                                },
                                child: Text(
                                  "Start event Run",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(primary: CustomColor.grey_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 120,
                                  height: size.height * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        UserPreferences.isRunningPause = !UserPreferences.isRunningPause;
                                      });
                                    },
                                    child: Text(
                                      "${UserPreferences.isRunningPause == false ? "PAUSE RUN" : "CONTINUE RUN"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    style: ElevatedButton.styleFrom(primary: CustomColor.grey_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                ),
                                Container(
                                    width: 120,
                                    height: size.height * 0.05,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmationDialog(
                                                  onClickedYes: () {
                                                    CustomProgressDialog.showProDialog();
                                                    print("Run Finish Called");
                                                    finishRun();

                                                    // Navigator.pop(context);
                                                  },
                                                  onClickedNo: () {
                                                    Navigator.pop(context);
                                                  },
                                                  btnWidth: 70,
                                                  btnHeight: 30,
                                                  desc: 'Are you sure you want to finish run?',
                                                  textWidth: size.width * 0.6,
                                                  textcolor: Colors.black,
                                                  btncolor: Colors.black,
                                                  textfontsize: 14,
                                                  btnfontsize: 14,
                                                );
                                              });
                                        },
                                        child: Text(
                                          "FINISH RUN",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: CustomColor.grey_color,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        ))),
                              ],
                            )
                          ],
                        )
                            : SizedBox(),

                      ],
                    ),
                  )

              );


            }

        ),

        bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: InkWell(
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                  child: Image.asset(
                    "assets/Menu.png",
                    width: 40,
                    height: 40,
                  ),
                )),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Notifications');
                    },
                    icon: Image.asset(
                      "assets/Notification.png",
                      width: 40,
                      height: 40,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SearchClubs');
                    },
                    icon: Image.asset(
                      "assets/Search.png",
                      width: 40,
                      height: 40,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/socialfeed');
                    },
                    icon: Image.asset(
                      "assets/SocialFeed.png",
                      width: 40,
                      height: 40,
                    )),
                IconButton(
                  onPressed: null,
                  icon: Image.asset(
                    "assets/run_man.png",
                    color: Colors.grey,
                  ),
                )
              ],
            )));
  }

  Future<void> updateMap(Map<String, dynamic> runprogressdetails) async {
    print("updateMap() EVENT PROGRAM ${runprogressdetails} ");



    if (UserPreferences.isRunning == true) {
      print("Runnuig is ${UserPreferences.isRunning}");
      setState(() {
        counter = runprogressdetails['counter'];
        distance = runprogressdetails['distance'];
        pace = runprogressdetails['pace'];
        speed = runprogressdetails['speed'];
        latitude = runprogressdetails['latitude'];
        longitude = runprogressdetails['longitude'];
      });
      if (widget.title.toString() == "EVENT PROGRAM") {
        print("distance type ${(distance * 1000) >= (double.parse(UserPreferences.eventRun) * 1000)}");

        if ((distance * 1000) >= (double.parse(UserPreferences.eventRun) * 1000)) {
          finishRun();
        }
      }
      if (widget.title == "RUN PROGRAM") {
        if ( (counter / 60) >= int.parse(UserPreferences.programRun) ) {
            finishRun();

        }
      }
      print("Event run is ${UserPreferences.eventRun} ${widget.title}");
    } else {
      print("Running has been Finished.");
    }
  }


  Future<void> finishEventProgram (double lat,double lng) async{
    print("finish run program called");
    try {
      final Map<String, dynamic> reqBody = {
        "ClubEvent_ID": UserPreferences.eventId,
        "Status": "Attended",
        "Run_ID": UserPreferences.RunId,
        "Lat": lat,
        "Lng": lng};
      print("REQUEST BODY OF EVENT PROGRAM IS ${reqBody}");
      GeneralResponse response = await AppUrl.apiService.clubeventstatus(reqBody);

      if (response.status == 1) {
        TopFunctions.showScaffold("${response.message}");
        UserPreferences.isRunning = false;
        UserPreferences.isRunningPause = false;
        TopVariables.service.invoke("stopService");
        UserPreferences.eventId = "";
        UserPreferences.eventRun = "";
        UserPreferences.runType="";
        TopVariables.service.invoke("stopService");
        UserPreferences.RemovePrefs("triplocations");

      } else {
        TopFunctions.showScaffold("${response.message}");
        Navigator.pop(context);
      }

    } catch (e) {
      TopFunctions.showScaffold("${e}");

    }


  }

  Future<void> finishRunProgram (double lat,double lng) async{
    try {
      final Map<String, dynamic> reqBody = {
        "ClubProgramDesc_ID": UserPreferences.programId.toString(),
        "Status": "Completed", "Run_ID": UserPreferences.RunId,
        "Lat": lat.toString(), "Lng": lng.toString()
      };
      GeneralResponse response = await AppUrl.apiService.clubprogramstatus(reqBody);
      if (response.status == 1) {
        TopFunctions.showScaffold("${response.message}");
      }

    } catch (e) {
      TopFunctions.showScaffold("${e}");

    }
    UserPreferences.runProgramtimer = 0;
    UserPreferences.programRun = "";
    UserPreferences.programId = "";
    UserPreferences.runType = "";
    UserPreferences.isRunning = false;
    UserPreferences.isRunningPause = false;
    TopVariables.service.invoke("stopService");

    UserPreferences.RemovePrefs("triplocations");
    timer!.cancel();



  }
  Future<void> finishRun() async {
    print("FINISH RUN FUNCTION IS RUNNING");
    try {
      final Map<String, dynamic> finishReq = {
        "ID": UserPreferences.RunId.toString(),
        "Time": "${(counter / 60).toString()}",
        "Distance": distance.toString(),
        "Pace": pace.toString(),
        "EndDateTime": DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
        "EndLatLng": "${latitude.toString()},${longitude.toString()}"
      };
      print("Sending Data to finishrun(): ${finishReq}");
      GeneralResponse response = await AppUrl.apiService.finishrun(finishReq);
      print("Getting Data from finishrun(): ${response.data}");
      CustomProgressDialog.hideProDialog();
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {
        counter = 0;
        distance = 0.0;
        pace = 0.0;
        speed = 0.0;
      });
      if (response.status == 1) {
        if (widget.title == "RUN PROGRAM") {
          print("RUN TYPE IS RUn PROGRAM");
          finishRunProgram(latitude,longitude);
          if (response.data['RunLogs'].length > 0) {
            print("RUNLOGS is greater than 0");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishRun(
                      LatLngList: response.data['RunLogs'],
                      Pace: response.data['Pace'].toString(),
                      Time: response.data['Time'].toString(),
                      Distance: response.data['Distance'].toString(),
                      Speed: response.data['Speed'].toString(),

                    )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishRun(LatLngList: [
                      {"Lat": latitude.toString(), "Lng": longitude.toString()}
                    ])));
          }
        }

        if(UserPreferences.runType == "EVENT PROGRAM"){
          print("RUN TYPE IS EVENT PROGRAM");
          finishEventProgram(latitude,longitude);
          print("Data Received Successfully from finishrun(): ${response.toString()} Pace ${response.data['Pace']} Time  ${response.data['Time']}Distance  ${response.data['Distance']} ");
          if (response.data['RunLogs'].length > 0) {
            print("RUNLOGS is greater than 0");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishRun(
                      LatLngList: response.data['RunLogs'],
                      Pace: response.data['Pace'].toString(),
                      Time: response.data['Time'].toString(),
                      Distance: response.data['Distance'].toString(),
                      Speed: response.data['Speed'].toString(),
                    )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishRun(LatLngList: [
                      {"Lat": latitude.toString(), "Lng": longitude.toString()}
                    ])));
          }

        }
        UserPreferences.distanceCueKMMarker = 1;


      } else {
        print("Data Didn't Receive Successfully from finishrun(): ${response.toString()}");
      }
    } catch (e) {
      CustomProgressDialog.hideProDialog();
      print("Exception Occurs on finishrun(): ${e}");
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                // width: 50,
                icon: Icon(
                  Icons.queue_music,
                  color: Colors.white,
                ),
                onPressed: queue,
              ),
              IconButton(
                //  width: 50,
                icon: Icon(
                  Icons.playlist_play,
                  color: Colors.white,
                ),
                onPressed: play,
              ),
              IconButton(
                // width: 50,
                icon: Icon(
                  Icons.repeat,
                  color: Colors.white,
                ),
                onPressed: toggleRepeat,
              ),
              IconButton(
                //  width: 50,
                icon: Icon(
                  Icons.shuffle,
                  color: Colors.white,
                ),
                onPressed: toggleShuffle,
              ),
              IconButton(
                //  width: 50,
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                onPressed: disconnect,
              ),
            ],
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedIconButton(
                width: 50,
                onPressed: addToLibrary,
                icon: Icons.favorite,
              ),
              SizedIconButton(
                width: 50,
                onPressed: () => checkIfAppIsActive(context),
                icon: Icons.info,
              ),
            ],
          ),*/
        ],
      ),
    );
  }
  Future<void> connectToSpotifyRemote() async {
    print("Connecting Remote");
    try {
      setState(() {
        _loading = true;
      });

      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: RedirectUrl,
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public, '
            'user-read-currently-playing'
            'user-read-private'
            'user-read-email',
        accessToken: UserPreferences.spotifyToken,
      );
      print("Remote ${result}");
      setStatus(result ? 'connect to spotify successful' : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });

      // if(UserPreferences.spotifyToken.isEmpty){
      //   print("access token is empty");
      //   var result = await SpotifySdk.connectToSpotifyRemote(
      //       clientId: '00062cf894414e29b5158c040fbc96b5',
      //       redirectUrl: 'https://ansariacademy.com/RunWith/spotify.php');
      //   print("Remote ${result}");
      //   setStatus(result
      //       ? 'connect to spotify successful'
      //       : 'connect to spotify failed');
      //   setState(() {
      //     _loading = false;
      //   });
      //
      // }
      // else{
      //   print("access token is not empty");
      //  var result = await SpotifySdk.connectToSpotifyRemote(
      //     clientId: clientId,
      //     accessToken: UserPreferences.spotifyToken,
      //     //  redirectUrl: 'https://ansariacademy.com/Run-With-KT/spotify.php'
      //     redirectUrl: "https://ansariacademy.com/RunWith/spotify.php",
      //   );
      //
      //   print("Init Spotify else ${result.toString()}");
      // }

    } on PlatformException catch (e) {
      print("Exception is message ${e.message} code ${e.code} stacktrace ${e.details}");
      if (e.code == "CouldNotFindSpotifyApp") {
        print("CouldNotFindSpotifyApp");
        Fluttertoast.showToast(msg: "${e.code}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
      if (e.code == "NotLoggedInException") {
        print("NotLoggedInException");
        Fluttertoast.showToast(msg: "The user must go to the Spotify and log-in", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }
  Future<String> getAccessToken() async {
    print("get access token pressed");
    try {
      var authenticationToken="";
      if(UserPreferences.spotifyToken.isEmpty){
        authenticationToken = await SpotifySdk.getAccessToken(
            clientId: clientId,
            redirectUrl: RedirectUrl,
            scope: 'app-remote-control, '
                'user-modify-playback-state, '
                'playlist-read-private, '
                'playlist-modify-public, '
                'user-read-currently-playing'
          // scope: 'app-remote-control, '
          //     'user-modify-playback-state, '
          //     'playlist-read-private, '
          //     'playlist-modify-public, '
          //     'user-read-currently-playing'
          //     'user-read-private user-read-email'

        );
        UserPreferences.spotifyToken = authenticationToken.toString();
        setStatus('Got a token: $authenticationToken');
        connectToSpotifyRemote();

      }

      else{
        connectToSpotifyRemote();
      }
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }


  Future<void> queue() async {
    try {
      await SpotifySdk.queue(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m').then((value) {
        print("play value is ${value}");
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    print("Set Status is ${message}");
    var text = message ?? '';
    _logger.i('$code$text');
  }


  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;

        currentTrackImageUri = track?.imageUri;
        // print("track is ${track!.uri}");
        var playerState = snapshot.data;
        // print("playerState is ${playerState!.track!.uri}");

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  //  width: 50,
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                  onPressed: skipPrevious,
                ),
                playerState.isPaused
                    ? IconButton(
                        // width: 50,
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: resume,
                      )
                    : IconButton(
                        //  width: 50,
                        icon: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: pause,
                      ),
                IconButton(
                  //  width: 50,
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: skipNext,
                ),
              ],
            ),
            Text(
              "Title ${track.name}",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Singer Name ${track.artist.name}",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),

            // Text('${track.name} by ${track.artist.name} from the album ${track.album.name}',style: TextStyle(color: Colors.white),),

            _connected
                ? spotifyImageWidget(track.imageUri)
                : const Text(
                    'Connect to see an image...',
                    style: TextStyle(color: Colors.white),
                  ),
          ],
        );
      },
    );
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: Image.memory(
              snapshot.data!,
              width: 100,
            ));
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      pause();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
        _connected = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }
}
