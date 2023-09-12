import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/utility/current_location.dart';

import '../../../utility/shared_preference.dart';
import '../utility/ProvidersUtility.dart';
import 'audioqueues_provider.dart';

class RunProvider extends ChangeNotifier {
  AudioQueuesProvider? audioQueuesProvider;
  Location location = Location();
  late double vehicleSpeed;
  static int counter = 0;
  List<double?> distanceValue = [];
  bool isRun = false;

  setCounter() {
    print("setCounter()");
    counter = 0;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateRun() async {
    audioQueuesProvider = ProvidersUtility.audioQueuesProvider;

    // AudioQueues.playAudiosMotivational();
    print("updateRun() Function Called");
    Future<Map<String, dynamic>> returnFromLocations = CurrentLocation().getCurrentLocation().then((event) async {
      if (UserPreferences.isRunningPause == false && UserPreferences.isRunning == true) {
        print("Incoming Hit From Background After 5 Sec:");
        print("Lat=${event!.latitude!} Lng=${event.longitude!} PluginSpeed=${event.speed!}");
        List DistanceSpeed = calculateDistanceSpeed(event!.latitude!, event.longitude!, event.speed!);
/*
        // Play Intro Audio Queue Till 1KM
        if (DistanceSpeed[1] < 1) {
          AudioQueues.playAudiosIntro();
        }
        // Play Motivational Audio Queue Each After 5 Min
        if ((DateTime.now().minute + DateTime.now().second) % 5 == 0) {
          AudioQueues.playAudiosMotivational();
        }
        // Play DistanceCues Audio Queue On Each KM
        if (DistanceSpeed[1].toInt() > UserPreferences.distanceCueKMMarker) {
          AudioQueues.playAudiosDistanceCues();
        }
*/

        if(DistanceSpeed[1] < 1){
          List<dynamic> audioData = audioQueuesProvider!.audioQueues.where((element) => element["Type"] == "Motivational").toList();
          print("${audioData[0]["File"]}");
        }


        // try {
        Map<String, dynamic> reqBody = {
          "Run_ID": UserPreferences.RunId.toString(),
          "Lat": event.latitude,
          "Lng": event.longitude,
          "DateTime": DateTime.now().toString(),
          "Speed": DistanceSpeed[0],
          "Distance": DistanceSpeed[1],
          "Pace": DistanceSpeed[2]
        };
        print("Sending Data In updaterun(): ${reqBody}");
        final response = await AppUrl.apiService.updaterun(reqBody);
        print("Receiving Data In updaterun(): ${response.toString()}");
        if (response.status == 1) {
          print("Run Progress Updated Successfully");
          return {
            'latitude': event.latitude,
            'longitude': event.longitude,
            'heading': event.heading,
            'speed': DistanceSpeed[0],
            'distance': DistanceSpeed[1],
            'pace': DistanceSpeed[2],
            "counter": counter
          };
        } else {
          print("Run Progress Didnt Update Successfully");
          //ToDo: Fix this else it will send last data 0 that will make all half
          return {
            'latitude': event.latitude,
            'longitude': event.longitude,
            'heading': event.heading,
            'speed': DistanceSpeed[0],
            'distance': DistanceSpeed[1],
            'pace': DistanceSpeed[2],
            "counter": counter
          };
        }
        // } catch (e) {
        //   print("Run Progress Got Exception");
        //   return {'latitude': 0.0, 'longitude': 0.0, 'heading': 0.0, 'distance': 0.0, 'speed': 0.0, 'pace': 0.0};
        // }
      } else {
        print("Running Is Paused Or Finished.");
        return {
          'latitude': event!.latitude,
          'longitude': event.longitude,
          'heading': event.heading,
          'speed': 0.0,
          'distance': 0.0,
          'pace': 0.0,
          'counter': counter
        };
      }
    });
    return returnFromLocations;
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    print("Distance in KM = ${d} & Is Meters = ${d * 1000}");
    return d; //KM
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  List calculateDistanceSpeed(double lat, double lng, double runSpeed) {
    distanceValue = [0.0, 0.0, 0.0]; // Speed,Distance,Pace
    counter = counter + 5;
    int tripLocationLength = prefs.getString("triplocations") == null ? 0 : UserPreferences.TripLocations.length;

    if (tripLocationLength > 0) {
      Map<String, dynamic> lastIndexData = UserPreferences.TripLocations[tripLocationLength - 1];
      double secToMin = 5 / 60;
      double secToHour = 5 / 3600;
      double distanceData = double.parse(getDistanceFromLatLonInKm(lastIndexData['lat'], lastIndexData['lng'], lat, lng).toStringAsFixed(4));
      print("Distance Between Last Point and Current Point = ${distanceData}");
      double speedData = double.parse((distanceData / secToHour).toStringAsFixed(4)); // m/s to Km/ h 1 * 3.6
      print("Speed Between Last Point and Current Point = ${speedData}");
      //Your pace is stated in minutes per mile or minutes per kilometre.
      double paceData = 0.0;
      if(distanceData > 0){
        paceData = double.parse((secToMin / distanceData).toStringAsFixed(4)); // min / km
        // paceData = double.parse((secToMin / (distanceData * 0.621371)).toStringAsFixed(4)); // min / mile
      }
      print("Pace Between Last Point and Current Point = ${paceData}");
      distanceValue = [speedData.abs(), lastIndexData['distance'] + distanceData, paceData.abs()];
    }

    final encodestringListData = [];
    if (tripLocationLength == 0) {
      encodestringListData.add({"lat": lat, "lng": lng, "speed": 0.0, "distance": 0.0, "pace": 0.0, "counter": 0});
      UserPreferences.TripLocations = encodestringListData;
    }
    else {
      print("Previously Saved TripLocations In UserPreferences = ${UserPreferences.TripLocations} ");
      // Remove If The Length Of Data Is More The 5
      if (UserPreferences.TripLocations.length > 5) {
        UserPreferences.TripLocations.removeRange(0, UserPreferences.TripLocations.length - 1);
      }
      print("Last Updated TripLocations In UserPreferences = ${UserPreferences.TripLocations} ");
      encodestringListData.add({
        "lat": lat,
        "lng": lng,
        "speed": distanceValue[0],
        "distance": distanceValue[1],
        "pace": distanceValue[2],
        "counter": counter
      });
      UserPreferences.TripLocations = encodestringListData;
      print("Final Updated TripLocations In UserPreferences = ${UserPreferences.TripLocations} ");
    }

    print("distanceValue = ${distanceValue}");
    notifyListeners();
    return distanceValue;
  }
}
