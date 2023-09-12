import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

import '../utility/top_level_variables.dart';

class RunHistory extends StatefulWidget {
  const RunHistory({Key? key}) : super(key: key);

  @override
  State<RunHistory> createState() => _RunHistoryState();
}

class _RunHistoryState extends State<RunHistory> {
  String googleAPiKey = TopVariables.GoogleApiKey;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  MapType _currentMapType = MapType.normal;
  late GoogleMapController mapController;
  Location location = Location();
  late LocationData locationData;
  List RunHistorydata = [];

  void _onMapCreated(GoogleMapController controller) async {
    bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }
    //
    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }
    locationData = await location.getLocation();
    mapController = controller;

    location.onLocationChanged.listen((event) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(event.latitude!, event.longitude!),
          zoom: 17,
        ),
      ));
    });
  }

  @override
  Future<void> RunigHistory() async {
    print("CALLING RUN HISTORY");
    try {
      GeneralResponse response = await AppUrl.apiService.runhistory();
      if (response.status == 1) {
        setState(() {
          RunHistorydata = response.data;
        });
      }
    } catch (e) {
      print("EXCEPTION RUN HISTORY IS ${e}");
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => RunigHistory());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      appBar: AppBarWidget.textAppBar('PREVIOUS RUN'),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          //margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: [

              RunHistorydata.isEmpty ?
              Center(child: Text("No Previous History",style: TextStyle(color: Colors.white),),)
                  :
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: RunHistorydata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                " ${DateTime.parse(DateTime.now().toString()).compareTo(DateTime.parse(RunHistorydata[index]['EndDateTime'])) > 0 ? "Today" : "Past"}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Distance",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      "${RunHistorydata[index]['Distance']}km/hr",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                height: 40,
                                child: VerticalDivider(
                                  color: Colors.white,
                                  indent: 3.0,
                                  endIndent: 3.0,
                                  thickness: 1.0,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pace",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      "${RunHistorydata[index]['Pace']} min/km",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                height: 40,
                                child: VerticalDivider(
                                  color: Colors.white,
                                  indent: 3.0,
                                  endIndent: 3.0,
                                  thickness: 1.0,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      "${RunHistorydata[index]['Time']} min",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                height: 40,
                                child: VerticalDivider(
                                  color: Colors.white,
                                  indent: 3.0,
                                  endIndent: 3.0,
                                  thickness: 1.0,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Achievements",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/achievements.png",
                                        ),
                                        Text(
                                          "${RunHistorydata[index]['Reward']}",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: size.height * 0.3,
                            child: GoogleMap(
                              // markers: Set<Marker>.from(myMarkers),
                              mapType: _currentMapType,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: false,
                              // onCameraMove: _onCameraMove,
                              onMapCreated: _onMapCreated,
                              myLocationEnabled: false,
                              markers: Set<Marker>.of([
                                Marker(
                                  // given marker id
                                  markerId: MarkerId("${index.toString()}"),
                                  // given marker icon
                                  icon: BitmapDescriptor.defaultMarker,
                                  // given position
                                  position: LatLng(
                                      double.parse(RunHistorydata[index]
                                              ['StartLatLng']
                                          .toString()
                                          .split(",")[0]),
                                      double.parse(RunHistorydata[index]
                                              ['StartLatLng']
                                          .toString()
                                          .split(",")[1])),
                                ),
                                Marker(
                                  // given marker id
                                  markerId: MarkerId("${index.toString()}"),
                                  // given marker icon
                                  icon:
                                      BitmapDescriptor.defaultMarkerWithHue(90),
                                  // given position
                                  position: LatLng(
                                      double.parse(RunHistorydata[index]
                                              ['EndLatLng']
                                          .toString()
                                          .split(",")[0]),
                                      double.parse(RunHistorydata[index]
                                              ['EndLatLng']
                                          .toString()
                                          .split(",")[1])),
                                ),
                              ]),

                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(RunHistorydata[index]
                                            ['EndLatLng']
                                        .toString()
                                        .split(",")[0]),
                                    double.parse(RunHistorydata[index]
                                            ['EndLatLng']
                                        .toString()
                                        .split(",")[1])),
                                zoom: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
