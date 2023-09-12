import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleSample extends StatefulWidget {
  const GoogleSample({Key? key}) : super(key: key);

  @override
  State<GoogleSample> createState() => _GoogleSampleState();
}

class _GoogleSampleState extends State<GoogleSample> {
  late GoogleMapController mapController;

  // List<Marker> _markers = [];
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  // final Set<Polyline> _polyline = {};
  List<LatLng> latLen = [
    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
    LatLng(26.850000, 80.949997),
    LatLng(24.879999, 74.629997),
    LatLng(16.166700, 74.833298),
    LatLng(12.971599, 77.594563),
    LatLng(19.0759837, 72.8776559),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: InfoWindow(
          title: 'HOTEL',
          snippet: '5 Star Hotel',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
        endCap: Cap.buttCap,
        geodesic: true,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: false,
        markers: _markers.toSet(),
        polylines: _polyline.toSet(),
        onMapCreated: (GoogleMapController googleController) async {
          mapController = googleController;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(19.0759837, 72.8776559), // tilt: 50.0,
          zoom: 14,
        ),
      ),
    );
  }
}
