import 'dart:async';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class GeoFenceexample extends StatefulWidget {
  const GeoFenceexample({Key? key}) : super(key: key);

  @override
  State<GeoFenceexample> createState() => _GeoFenceexampleState();
}

class _GeoFenceexampleState extends State<GeoFenceexample> {
  final String title="";
  TextEditingController latitudeController = new TextEditingController(text: "19.0759837");
  TextEditingController longitudeController = new TextEditingController(text: "72.8776559");
  TextEditingController radiusController = new TextEditingController(text: "80");
  double? lat;
  double? lng;

  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position? position;
  late GoogleMapController mapController;
  List<Circle> circles = [];
  List<Marker> myMarkers = [];
  Location location = Location();
  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
    mapController.dispose();

    super.dispose();
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition();
    print("LOCATION => ${position!.toJson()}");
   setState(() {
     isReady = (position != null) ? true : false;
     circles.add(
         Circle(
             circleId: CircleId(LatLng(position!.latitude,
                 position!.longitude).toString()),
             center: LatLng(position!.latitude,
                 position!.longitude),
             radius: double.parse(radiusController.text),
             fillColor: Colors.orange.shade50,
             strokeWidth: 2


         )
     );
     lat=position!.latitude;
     lng=position!.longitude;

     print("lat and lng is ${lat} ${lng} ${circles}");
   });
  }


  setLocation() async {
    await getCurrentPosition();
    // print("POSITION => ${position!.toJson()}");
   setState(() {
     latitudeController =
         TextEditingController(text: position!.latitude.toString());
     longitudeController =
         TextEditingController(text: position!.longitude.toString());
   });
    print("latitudeController ${latitudeController.text} ${longitudeController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo fence"),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              print("isReady ${isReady}");
              if (isReady) {
                setState(() {
                  setLocation();
                });
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: latitudeController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(

                  border: InputBorder.none, hintText: 'Enter pointed latitude'),
            ),
            TextField(
              controller: longitudeController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter pointed longitude'),
            ),
            TextField(
              controller: radiusController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter radius in meter'),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              color: Colors.red,
              height:300,
              child: GoogleMap(
                circles:circles.toSet(),
                markers: myMarkers.toSet(),
                onMapCreated: (GoogleMapController controller){
                  mapController = controller;

                  location.onLocationChanged
                      .listen((event) async {
                    BitmapDescriptor markerbitmap =
                    await BitmapDescriptor.fromAssetImage(
                      ImageConfiguration(),
                      "assets/carimage.png",
                    );

                    if (this.mounted) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        setState(() {
                          latitudeController.text=event.latitude.toString();
                          longitudeController.text=event.longitude.toString();
                          if (myMarkers.isNotEmpty) {
                            myMarkers.clear();

                          } else {
                            // print("else condition markers ${tripsDetails.getUpdated!['idleSec1']}");
                            myMarkers.add(Marker(
                              //add first marker
                                rotation: event.heading!,
                                markerId: MarkerId(
                                    "${LatLng(event.latitude!, event.longitude!)}"),
                                position: LatLng(
                                    event.latitude!,
                                    event.longitude!),
                                icon: markerbitmap

                            ));

                          }
                        });
                      });
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(event.latitude!,
                                  event.longitude!),
                              zoom: 17,
                            ),
                          ));
                    }
                  });

                  // setState(() {
                  //   myMarkers.add(
                  //       Marker(
                  //           markerId: MarkerId(LatLng(double.parse(latitudeController.text), double.parse(longitudeController.text)).toString()),
                  //           position: LatLng(double.parse(latitudeController.text), double.parse(longitudeController.text)),
                  //           icon: BitmapDescriptor.defaultMarker
                  //
                  //       )
                  //   );
                  //   circles.add(
                  //       Circle(
                  //           circleId: CircleId(LatLng(double.parse(latitudeController.text), double.parse(longitudeController.text)).toString()),
                  //           center: LatLng(double.parse(latitudeController.text), double.parse(longitudeController.text)),
                  //           radius: double.parse(radiusController.text),
                  //           fillColor: Colors.orange.shade50,
                  //           strokeWidth: 2
                  //
                  //
                  //       )
                  //   );
                  // });





                },
                myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target:LatLng(double.parse(latitudeController.text),double.parse(longitudeController.text)),
                    zoom: 17,
                  ),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Start"),
                  onPressed: () {
                    print("starting geoFencing Service");
                    EasyGeofencing.startGeofenceService(
                        pointedLatitude: lat.toString(),
                        pointedLongitude: lng.toString(),
                        radiusMeter: radiusController.text,
                        eventPeriodInSeconds: 5);
                    if (geofenceStatusStream == null) {
                      geofenceStatusStream = EasyGeofencing.getGeofenceStream()!
                          .listen((GeofenceStatus status) {
                        print("stream status is ${status.toString()}");
                        setState(() {
                          geofenceStatus = status.toString();
                        });
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  child: Text("Stop"),
                  onPressed: () {
                    print("stop");
                    EasyGeofencing.stopGeofenceService();
                    geofenceStatusStream!.cancel();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "Geofence Status: \n\n\n" + geofenceStatus,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

    );
  }
}
