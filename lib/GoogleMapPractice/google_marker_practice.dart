import 'package:flutter/material.dart';
import 'package:flutterdevelopment/utility/current_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class AvailableJobsNotActivate extends StatefulWidget {
  const AvailableJobsNotActivate({Key? key}) : super(key: key);

  @override
  State<AvailableJobsNotActivate> createState() =>
      _AvailableJobsNotActivateState();
}

class _AvailableJobsNotActivateState extends State<AvailableJobsNotActivate> {
  late GoogleMapController mapController;

  List<Marker> myMarkers = [];
  List<Circle> circles = [];
  List<Polyline> polylines = [];
  List<Polygon> polygon = [];

  MapType _currentMapType = MapType.normal;
  Location location = Location();
  late LocationData locationData;

  List<LatLng> latLen = [
    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
    LatLng(26.850000, 80.949997),
    LatLng(24.879999, 74.629997),
    LatLng(16.166700, 74.833298),
    LatLng(12.971599, 77.594563),
  ];

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Available Jobs"),
        // leading:Icon(Icons.arrow_back,color:CustomColor.primary)
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // height:size.height * 0.5,
              child: FutureBuilder<LocationData?>(
                future: CurrentLocation().getCurrentLocation(),
                builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                  print("snapshot location is ${snapshot.data}");
                  if (snapshot.hasData) {
                    final LocationData locData=snapshot.data;
                    return      GoogleMap(
                      // markers: Set<Marker>.from(myMarkers),
                      mapType: _currentMapType,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      markers: myMarkers.toSet(),
                      circles: circles.toSet(),
                      polylines: polylines.toSet(),
                      polygons: polygon.toSet(),
                      myLocationEnabled: true,

                      // onCameraMove: _onCameraMove,
                      onMapCreated: (GoogleMapController controller){
                        mapController = controller;
                        // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                        //   target: LatLng(locData.latitude!, locData.longitude!),
                        //   zoom: 17,)
                        // ));

                        // mapController.animateCamera(CameraUpdate.newLatLng(LatLng(locData.latitude!, locData.longitude!)));
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                          setState(() {
                            myMarkers.add(
                                Marker(
                                    markerId: MarkerId(LatLng(locData.latitude!, locData.longitude!).toString()),
                                    position: LatLng(locData.latitude!, locData.longitude!),
                                    icon: BitmapDescriptor.defaultMarker

                                )
                            );
                            myMarkers.add(
                                Marker(
                                    markerId: MarkerId(LatLng(locData.latitude!, locData.longitude!).toString()),
                                    position: LatLng(28.679079, 77.069710),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)

                                )
                            );

                            circles.add(
                                Circle(
                                    circleId: CircleId(LatLng(locData.latitude!, locData.longitude!).toString()),
                                    center: LatLng(locData.latitude!, locData.longitude!),
                                    radius: 100,
                                    fillColor: Colors.orange.shade50,
                                    strokeWidth: 2


                                )
                            );
                            circles.add(
                                Circle(
                                    circleId: CircleId(LatLng(locData.latitude!, locData.longitude!).toString()),
                                    center: LatLng(28.679079, 77.069710),
                                    radius: 100,
                                    fillColor: Colors.orange.shade50,
                                    strokeWidth: 2


                                )
                            );

                            // polylines.add(
                            //   Polyline(
                            //       polylineId: PolylineId("1"),
                            //        points: latLen,
                            //     width: 8,
                            //       jointType:JointType.round,
                            //      startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker,refWidth: 20),
                            //      endCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),refWidth: 20),
                            //       geodesic:true,
                            //     patterns: [
                            //       PatternItem.dot,
                            //       // PatternItem.dash(10),
                            //       // PatternItem.gap(10)
                            //     ]
                            //
                            //
                            //
                            //   )
                            // );

                            // polygon.add(
                            //   Polygon(
                            //       polygonId: PolygonId("1"),
                            //     fillColor: Colors.red,
                            //     points: latLen,
                            //     strokeWidth: 5,
                            //     strokeColor: Colors.orange
                            //
                            //
                            //
                            //   )
                            // );



                          });


                        });





                      },
                      initialCameraPosition: CameraPosition(
                        target:LatLng(28.679079, 77.069710),
                        zoom: 17,
                      ),
                    );

                  }

                  else{
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    );
                  }



                },
              )
          ),
          Container(
              child: Text(
                "AVAILABLE JOBS",
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}
