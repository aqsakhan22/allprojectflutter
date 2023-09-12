import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:runwith/dialog/confirmation_dialogbox.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/run_provider.dart';
import 'package:runwith/screens/event_program_run.dart';
import 'package:runwith/screens/finish_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../dialog/progress_dialog.dart';
import '../services/background.dart';
import '../theme/color.dart';
import '../utility/top_level_variables.dart';

//https://developer.spotify.com/documentation/web-api/
//https://www.quora.com/unanswered/How-do-I-connect-a-Spotify-API-with-a-flutter-for-a-mobile-app

//Todo don't remove the better player code will be use in future if we needed
class StartRun extends StatefulWidget {
  const StartRun({Key? key}) : super(key: key);

  @override
  State<StartRun> createState() => _StartRunState();
}

class _StartRunState extends State<StartRun> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MapType _currentMapType = MapType.normal;
  late GoogleMapController mapController;
  String TrackId = "yaha track id use huig";
  Set<Marker> _markers = new Set();
  int counter = 0;
  double distance = 0.0;
  double pace = 0.0;
  double speed = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;
  Location location = Location();
  List<double?> distanceValue = [];
  bool _loading = false;
  bool _connected = false;
  String clientId = "dbca525ea5094035bfaffdf790104549";
  String RedirectUrl = "comspotifytestsdk://SpotifyAuthentication";
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
    print("RuntType is ${UserPreferences.runType} ${UserPreferences.TripLocations}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (UserPreferences.runType.isNotEmpty) {
        print("isRunning noit empty");
        TopVariables.service.on(actionRunningProgress).listen((event) {
          // Call Function
          print("Update Run API Called In Frontend In Start_Run");
          RunProvider().updateRun().then((value) {
            print("Updating Map After Updating Data To Server");
            updateMap(value);
          });
        });

        if (UserPreferences.runType == "RUN PROGRAM" && UserPreferences.isRunning == true) {
          print("Program Run timer is  ${UserPreferences.runProgramtimer} programid ${UserPreferences.programId} ${UserPreferences.programRun} min ");
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
          print("Event program ${UserPreferences.eventRun} ${UserPreferences.eventId} ${UserPreferences.TripLocations}");
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventProgramRun(
                        EventId: UserPreferences.eventId, title: "${UserPreferences.runType}",
                        //   EventRun: UserPreferences.TripLocations[UserPreferences.TripLocations.length - 1]['distance'],
                      )));
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: MyNavigationDrawer(),
        key: _key,
        appBar: AppBarWidget.textAppBar(
          "CASUAL RUN",
        ),
        body: StreamBuilder<ConnectionStatus>(
            stream: SpotifySdk.subscribeConnectionStatus(),
            builder: (context, snapshot) {
              _connected = false;
              var data = snapshot.data;

              if (data != null) {
                print("data value is ${data.connected}");
                _connected = data.connected;
              }
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //spotify button
                      Container(
                          height: 45,
                          child: _connected == false
                              ? ElevatedButton.icon(
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
                              label: Text("Connect with Spotify"))
                              : ElevatedButton.icon(
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
                              label: Text("Disconnect with spotify"))),

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
                                      ), //pace = time / distance
                                      Text(
                                        " ${pace.toStringAsFixed(2)} min/km",
                                        textAlign: TextAlign.center,
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
                      //Google Map Container
                      Container(
                          height: size.height * 0.3,
                          child: FutureBuilder<LocationData?>(
                            future: CurrentLocation().getCurrentLocation(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                              if (snapchat.hasData) {
                                final LocationData currentLocation = snapchat.data;
                                return GoogleMap(
                                  // markers: Set<Marker>.from(myMarkers),
                                  // markers: Set<Marker>.from(myMarkers),
                                  markers: _markers,
                                  mapType: _currentMapType,
                                  zoomControlsEnabled: false,
                                  // onCameraMove: _onCameraMove,
                                  onMapCreated: (GoogleMapController controller) async {
                                    mapController = controller;
                                    final Uint8List markerIcon = await getBytesFromAsset('assets/runimage.jpg', 100);
                                    setState(() {
                                      _markers.add(Marker(markerId: MarkerId("1"), icon: BitmapDescriptor.fromBytes(markerIcon), position: LatLng(currentLocation.latitude!, currentLocation.longitude!)));
                                    });
                                    mapController.animateCamera(CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                                        zoom: 17,
                                      ),
                                    ));
                                    //
                                    // setState(() {
                                    //   final MarkerId markerId = MarkerId(LatLng(currentLocation.latitude!, currentLocation.longitude!).toString());
                                    //   Marker marker = Marker(
                                    //     //icon: BitmapDescriptor.fromBytes(bytes), //for UTintList
                                    //     // icon: markerbitmap, // for assets
                                    //     icon: BitmapDescriptor.fromBytes(
                                    //         markerIcon),
                                    //     //default red one
                                    //     markerId: markerId,
                                    //     draggable: true,
                                    //     position: LatLng(
                                    //         currentLocation.latitude!,
                                    //         currentLocation.longitude!),
                                    //   );
                                    //   WidgetsBinding.instance
                                    //       .addPostFrameCallback(
                                    //           (timeStamp) {
                                    //         setState(() {
                                    //           _markers.add(marker);
                                    //         });
                                    //       });
                                    // });
                                    location.enableBackgroundMode(enable: true);
                                  },
                                  myLocationEnabled: true,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                                    zoom: 15,
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: CustomColor.orangeColor,
                                  ),
                                );
                              }
                            },
                          )),

                      //start run check
                      UserPreferences.isRunning == false
                          ? Container(
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 120,
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {
                                  CustomProgressDialog.showProDialog();
                                  CurrentLocation().getCurrentLocation().then((value) async {
                                    print("Current Location Is: ${value!.latitude}/${value.longitude}");
                                    final Map<String, dynamic> reqBody = {'User_ID': "${UserPreferences.get_Profiledata()['ID'].toString()}", "Linked_ID": 0, "RunType": "Casual", 'StartDateTime': DateTime.now().toString(), 'StartLatLng': "${value.latitude},${value.longitude}"};
                                    print("Sending Data To startrun() Casual run: ${reqBody}");
                                    try {
                                      final response = await AppUrl.apiService.startrun(reqBody);
                                      print("Receiving Data To startrun(): ${response.toString()}");

                                      CustomProgressDialog.hideProDialog();
                                      if (response.status == 1) {
                                        RunProvider.counter = 0;
                                        RunProvider().setCounter();
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
                                              UserPreferences.runType = "Casual";
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
                                  " START RUN ",
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
                                style: ElevatedButton.styleFrom(primary: CustomColor.grey_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/RunHistory");
                                },
                                child: Text(
                                  "PREVIOUS RUNS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                          : Container(
                        height: size.height * 0.1,
                        child: Row(
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
                                                print("Run Finish Called from Start Run");
                                                finishRun();
                                                UserPreferences.isRunning = false;
                                                UserPreferences.isRunningPause = false;
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
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
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
    print("updateMap() isrunning  ${runprogressdetails}");
    if (UserPreferences.isRunning == true) {
      print("UserPreferences.isRunning ${UserPreferences.isRunning}");
      setState(() {
        counter = runprogressdetails['counter'];
        distance = runprogressdetails['distance'];
        pace = runprogressdetails['pace'];
        speed = runprogressdetails['speed'];
        latitude = runprogressdetails['latitude'];
        longitude = runprogressdetails['longitude'];
      });
      final Uint8List markerIcon = await getBytesFromAsset("assets/runimage.jpg", 100);
      if (_markers.isNotEmpty) {
        _markers.clear();
      }
      if (this.mounted) {
        setState(() {
          // Your state change code goes here
          _markers.add(Marker(
            //add start location marker
            markerId: MarkerId(LatLng(runprogressdetails['latitude'], runprogressdetails['longitude']).toString()),
            position: LatLng(runprogressdetails['latitude'], runprogressdetails['longitude']),
            //      flat: true,
            rotation: runprogressdetails['heading'],
            infoWindow: InfoWindow(
              //popup info
              title: '${LatLng(runprogressdetails['latitude'], runprogressdetails['longitude'])}',
              // snippet: 'Start Marker',
            ),
            // icon: markerbitmap
            icon: BitmapDescriptor.fromBytes(markerIcon),
            //Icon for Marker
          ));
        });
      }
      print("Marker is ${_markers}");

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(runprogressdetails['latitude'], runprogressdetails['longitude']!),
          zoom: 17,
        ),
      ));
    } else {
      print("Running has been Finished.");
    }
  }

  Future<void> finishRun() async {
    //TopVariables.isFinishRun = false;
    print("finish run pressed");
    // try {
    final duration = Duration(seconds: counter);
    final Map<String, dynamic> finishReq = {
      "ID": UserPreferences.RunId.toString(),
      "Time": "${duration}",
      "Distance": distance.toString(),
      "Pace": pace.toString(),
      "EndDateTime": DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
      "EndLatLng": "${latitude.toString()},${longitude.toString()}",
      "Speed": speed.toString()
    };
    print("Sending Data to finishrun(): ${finishReq}");
    GeneralResponse response = await AppUrl.apiService.finishrun(finishReq);
    print("Getting Data from finishrun(): ${response.data}");
    CustomProgressDialog.hideProDialog();
    Navigator.pop(context);
    if (response.status == 1) {
      Navigator.pop(context);
      UserPreferences.distanceCueKMMarker = 1;
      UserPreferences.isRunning = false;
      UserPreferences.isRunningPause = false;
      UserPreferences.runType = "";
      TopVariables.service.invoke("stopService");
      UserPreferences.RemovePrefs("triplocations");
      setState(() {
        counter = 0;
        distance = 0.0;
        pace = 0.0;
        speed = 0.0;
      });
      if (response.data['RunLogs'].length > 0) {
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
        print("Finish Run Without Moving: Lat: ${latitude.toString()} Lng${longitude.toString()}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinishRun(
              LatLngList: [
                {"Lat": latitude.toString(), "Lng": longitude.toString()}
              ],
              Pace: "0.0",
              Time: "0.0",
              Distance: "0.0",
              Speed: "0.0",
            ),
          ),
        );
      }
    } else {
      Navigator.pop(context);
      TopFunctions.showScaffold("${response.message.oString()}");
      print("Data Didn't Receive Successfully from finishrun(): ${response.message.toString()}");
    }
    // } catch (e) {
    //   CustomProgressDialog.hideProDialog();
    //   print("Exception Occurs on finishrun(): ${e}");
    // }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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
        //  accessToken: UserPreferences.spotifyToken,
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
    // try {
      var authenticationToken = "";
      if (UserPreferences.spotifyToken.isEmpty) {
        print("authenticationToken => $authenticationToken");
        authenticationToken = await SpotifySdk.getAccessToken(
            clientId: clientId,
            redirectUrl: RedirectUrl,
            scope: 'app-remote-control, '
                'user-modify-playback-state, '
                'playlist-read-private, '
                'playlist-modify-public, '
                'user-read-currently-playing'
            );
        setStatus('Got a token: $authenticationToken');
        UserPreferences.spotifyToken = authenticationToken.toString();
        connectToSpotifyRemote();
      } else {
        connectToSpotifyRemote();
      }
      return authenticationToken;
    // } on PlatformException catch (e) {
    //   setStatus(e.code, message: e.message);
    //   return Future.error('$e.code: $e.message');
    // } on MissingPluginException {
    //   setStatus('not implemented');
    //   return Future.error('not implemented');
    // }
  }

  Future<void> queue() async {
    print("pressed queue");
    try {
      await SpotifySdk.queue(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      print("exceptiuon is ${e}");
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
      print("exceptiuon is ${e}");
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
