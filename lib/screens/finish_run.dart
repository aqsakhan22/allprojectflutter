import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:screenshot/screenshot.dart';

import '../network/app_url.dart';
import '../network/response/general_response.dart';
import '../utility/top_level_variables.dart';

class FinishRun extends StatefulWidget {
  final List? LatLngList;
  final String? Pace;
  final String? Distance;
  final String? Time;
  final String? Speed;

  const FinishRun({
    Key? key,
    this.LatLngList,
    this.Pace,
    this.Distance,
    this.Time,
    this.Speed,
  }) : super(key: key);

  @override
  State<FinishRun> createState() => _FinishRunState();
}

class _FinishRunState extends State<FinishRun> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final Set<Polyline> _polyline = {};
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> points = [];
  List<LatLng> marekerList = [];
  List<LatLng> latlng = [];
  List<LatLng> latlngSegment1 = [];
  late GoogleMapController controller;

  //Create an instance of ScreenshotController
  late Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("LatLng List ${widget.LatLngList!}, Pace ${widget.Pace}, Distance ${widget.Distance},Time ${widget.Time}");
    print("LLatLng List In FinishRun Screen: ${widget.LatLngList!.map((e) {
      print("LAT In FinishRun Screen: ${e['Lat']} | Lng In FinishRun Screen: ${e['Lng']}\n");
      latlngSegment1.add(
        LatLng(double.parse(e['Lat']), double.parse(e["Lng"])),
      );
      points.add(
        LatLng(double.parse(e['Lat']), double.parse(e["Lng"])),
      );
      marekerList.add(
        LatLng(double.parse(e['Lat']), double.parse(e["Lng"])),
      );
    })}");
    print("Points To Draw Are: ${points}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Format Pace & Moving Time
    final AvgPace = Duration(minutes: ((double.parse(widget.Pace.toString()) * 60)).toInt(), seconds: 0);
    // final MovingTime = Duration(minutes: ((double.parse(widget.Time.toString()) * 60)).toInt(), seconds: 0);
    print("${_printDuration(AvgPace)}");
    // print("${_printDuration(MovingTime)}");
    return Scaffold(
        key: _key,
        drawer: MyNavigationDrawer(),
        appBar: AppBarWidget.textAppBar(
          'Run Finished',
        ),
        bottomNavigationBar: BottomNav(
          scaffoldKey: _key,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            takeScreenshotAndUpload();
          },
          child: Icon(Icons.camera_alt_outlined, color: Colors.black,),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          margin: EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.5,
                    child: GoogleMap(
                      //given camera position
                      initialCameraPosition: CameraPosition(
                        target: latlngSegment1[latlngSegment1.length - 1],
                        zoom: 7.0,
                      ),
                      // on below line we have given map type
                      mapType: MapType.normal,
                      // on below line we have enabled location
                      // myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      // on below line we have enabled compass location
                      compassEnabled: true,
                      // on below line we have added polygon
                      polylines: _polyline,
                      //  polygons: _polygon,
                      // markers: _markers,
                      // displayed google map
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        setState(() {
                          _polyline.add(Polyline(
                            polylineId: PolylineId('line1'),
                            visible: true,
                            //latlng is List<LatLng>
                            points: latlngSegment1,
                            width: 4,
                            color: Colors.blue,
                          ));
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            //Distance
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "Distance",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(" ${double.parse(widget.Distance!).toStringAsFixed(2)} km",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "Avg Pace",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("${double.parse(widget.Pace!).toStringAsFixed(2)} min/km",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            //Distance
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "Moving Time",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("${widget.Time} min",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "Avg Speed",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("${double.parse(widget.Speed!).toStringAsFixed(2)} km/hr",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))
                              ],
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //           width: 130,
                        //           child: Text("Average Heart Rate",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),)) ,
                        //       SizedBox(height: 5,),
                        //       Text("150",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 22))
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  takeScreenshotAndUpload() async {
    screenshotController.capture().then((image) async {
      //Capture Done
      _imageFile = image!;
      final tempDir = await getTemporaryDirectory();
      File screenshotToSend = await new File('${tempDir.path}/screenshot.jpg').writeAsBytes(_imageFile);
      try {
        print("[REQUEST BODY] (screenshotFeedsend): ");
        GeneralResponse response = await AppUrl.apiService.feedsend(
          "No",
          "Finished A Run Just Now. Woohoo...",
          File(screenshotToSend.path)
        );
        print("[RESPONSE BODY] (screenshotFeedsend): ${response.data.toString()}");
        if (response.status == 1) {
          print("[SUCCESS BODY] (screenshotFeedsend): ${response.data.toString()}");
          TopFunctions.showScaffold(response.message);
        } else {
          print("[FAILURE BODY] (screenshotFeedsend): ${response.data.toString()}");
          TopFunctions.showScaffold(response.message);
        }
      } catch (e) {
        print("[EXCEPTION] (screenshotFeedsend): ${e.toString()}");
      }
    }).catchError((onError) {
      print(onError);
      TopFunctions.showScaffold(onError.toString());
    });


  }
}
