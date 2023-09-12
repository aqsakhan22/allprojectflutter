import 'package:location/location.dart';

class CurrentLocation {
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location.instance;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      print("GRANTED");
      if (_permissionGranted != PermissionStatus.granted) {
        print("NOT GRANTED");
        return null;
      }
    }
    _locationData = await location.getLocation();
    print('Location Data Received: ${_locationData}');
    return _locationData;
  }
}
