import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/running_buddies.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/network.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as IMG;

class FindBuddies extends StatefulWidget {
  const FindBuddies({Key? key}) : super(key: key);

  @override
  State<FindBuddies> createState() => _FindBuddiesState();
}

class _FindBuddiesState extends State<FindBuddies> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final _tabController = TabController(
    length: 2,
    vsync: this,
  );
  bool isLoader = false;
  List<Marker> _markers=[];
  late List<Marker> markersToShow;
  late GoogleMapController map_controller;
  double Locationlat = 0.0;
  double Locationlng = 0.0;
  String countryCode = "pk";
  Mode _mode = Mode.overlay;
  RunningBuddiesProvider? RBprovider;
  double _currentSliderValue = 20;
  List foundbuddies = [];

  @override
  void initState() {
    // TODO: implement initState
    RBprovider = ProvidersUtility.buddiesProvider;
    setState(() {
      isLoader = true;
    });
    RBprovider!.getRunningBuddies({}).then((value) {
      setState(() {
        isLoader = false;
        foundbuddies = RBprovider!.Buddies;
      });
      print("foundbuddies ${foundbuddies}");
    });
    getCountry();

    super.initState();
  }

  void getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    (await n.getData().then((value) {
      print("VALUES ${value}");
      String locationx = jsonDecode(value)["countryCode"];
      print("locatiox ${locationx}");

      setState(() {
        countryCode = locationx.toLowerCase();
      });
    }));
  }

  Future<Uint8List> networkImage(String imgurl) async {
    //assets one
    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(),
    //   "assets/locationavatar.png",
    // );
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl)).buffer.asUint8List();

    return Future.value(bytes);
  }

  Future<void> handePressed() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: TopVariables.GoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search",
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "${countryCode}")]);
    displayPrediction(p!);
  }

  Future<void> onError(PlacesAutocompleteResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.errorMessage}")));
    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("${response.errorMessage}")));
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places =
        GoogleMapsPlaces(apiKey: TopVariables.GoogleApiKey, apiHeaders: await GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    _markers.clear();
    final MarkerId markerId = MarkerId("1");
    Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: markerId,
      draggable: true,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: "${detail.result.name}",
      ),
    );
    _markers.add(marker);
    setState(() {
      Locationlat = lat;
      Locationlng = lng;
      location = detail.result.name;
    });
    print("new lat is ${Locationlat} lng is ${Locationlng}");
    //final c = await googleMapController.future;

    map_controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  String location = "Type in location";

  // Set<Marker> getmarkers() {
  //   //markers to place on map
  //    CurrentLocation().getCurrentLocation().then((value) {
  //      markers.add(Marker( //add first marker
  //        markerId: MarkerId(LatLng(value!.latitude!,value.longitude!).toString()),
  //        position: LatLng(value.latitude!,value.longitude!), //position of marker
  //        infoWindow: InfoWindow( //popup info
  //          title: 'Marker Title First ',
  //          snippet: 'My Custom Subtitle',
  //        ),
  //        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  //      ));
  //    });
  //     //add more markers here
  //   return markers;
  // }

  Uint8List? resizeImage(Uint8List data, width, height) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
    resizedData = Uint8List.fromList(IMG.encodePng(resized));
    return resizedData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget.textAppBar("FIND BUDDIES"),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: CustomColor.white,
                labelStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 14),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.white,
                tabs: [
                  Container(
                    child: Text("By Persons", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    child: Text("By Location", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                // height: size.height * 0.8,
                child: TabBarView(controller: _tabController, physics: NeverScrollableScrollPhysics(), children: [
                  //Left
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (enteredKeyword) {
                              print("entered value is ${enteredKeyword}");
                              List results = [];
                              if (enteredKeyword.isEmpty) {
                                // if the search field is empty or only contains white-space, we'll display all users
                                results = RBprovider!.Buddies;
                              } else {
                                results = RBprovider!.Buddies
                                    .where((user) => user["UserName"].toLowerCase().contains(enteredKeyword.toLowerCase()))
                                    .toList();
                                // we use the toLowerCase() method to make it case-insensitive
                              }

                              // Refresh the UI
                              setState(() {
                                foundbuddies = results;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.transparent)),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Type Name",
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(child: Consumer<RunningBuddiesProvider>(
                            builder: (context, AddBuddy, child) {
                              isLoader == true
                                  ? child = Center(
                                      child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ))
                                  : child = Expanded(
                                      child: foundbuddies.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: foundbuddies.length, // padding: EdgeInsets.zero,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                  padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      foundbuddies[index]['ProfilePhoto'] == null
                                                          ? Image.asset(
                                                              "assets/raw_profile_pic.png",
                                                              height: 70,
                                                              width: 70,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              "${AppUrl.mediaUrl}${foundbuddies[index]['ProfilePhoto']}",
                                                              height: 70,
                                                              width: 70,
                                                              fit: BoxFit.cover,
                                                            ),
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("${foundbuddies[index]['UserName']}",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w700)),
                                                            Text(
                                                                "${foundbuddies[index]['City']} ${foundbuddies[index]['Country']}",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w500)),
                                                            Text("${foundbuddies[index]['Points']}",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height: 20,
                                                            width: size.width * 0.25,
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal: 15.0,
                                                                    ),
                                                                    backgroundColor: CustomColor.grey_color,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(100.0))),
                                                                onPressed: () async {
                                                                  try {
                                                                    final Map<String, dynamic> reqData = {
                                                                      "Friend_ID": foundbuddies[index]['ID'],
                                                                      "Status": "Request"
                                                                    };
                                                                    print("Add Buddy request ${reqData}");
                                                                    GeneralResponse response =
                                                                        await AppUrl.apiService.friendrequest(reqData);
                                                                    if (response.status == 1) {
                                                                      print(
                                                                          "Receiving Data from FRIENDSREQUEST: ${response.toString()}");
                                                                      TopFunctions.showScaffold("${response.message}");
                                                                      AddBuddy.getRunningBuddies({});
                                                                      AddBuddy.notifyListeners();
                                                                      setState(() {
                                                                        foundbuddies = AddBuddy.Buddies;
                                                                      });
                                                                    } else {
                                                                      print(
                                                                          "Data Received Didn't Successfully from Friends: ${response.toString()}");
                                                                    }
                                                                  } catch (e) {
                                                                    print("Friendt Request ${e}");
                                                                  }
                                                                },
                                                                child: Text("ADD BUDDY",
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight.w600))),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                            width: size.width * 0.25,
                                                            height: 20,
                                                            child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                                                    backgroundColor: CustomColor.grey_color,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(100.0))),
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContextcontetx) {
                                                                        return AlertDialog(
                                                                          contentPadding: EdgeInsets.zero,
                                                                          insetPadding: EdgeInsets.all(18.0),
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.0)),
                                                                          content: Container(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(
                                                                                  "Send Messages",
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                      horizontal: 10.0),
                                                                                  child: TextFormField(
                                                                                    maxLength: 100,

                                                                                    onChanged: (value) {},

                                                                                    keyboardType: TextInputType.multiline,
                                                                                    maxLines: 4,
                                                                                    textAlign: TextAlign.center,

                                                                                    style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        color: Colors.black,
                                                                                        fontStyle: FontStyle.normal,
                                                                                        fontWeight: FontWeight.w400),
                                                                                    //or null
                                                                                    decoration: InputDecoration(
                                                                                        // contentPadding: EdgeInsets.symmetric(vertical: 40),
                                                                                        counterStyle:
                                                                                            TextStyle(color: Colors.white),
                                                                                        border: OutlineInputBorder(
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(5.0)),
                                                                                        hintText: "Type a Message",
                                                                                        hintStyle: TextStyle(
                                                                                          height: 3,
                                                                                        ),
                                                                                        fillColor: Colors.white,
                                                                                        filled: true),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              child: ButtonWidget(
                                                                                onPressed: () {
                                                                                  TopFunctions.showScaffold(
                                                                                      "Feature is in progress");
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                color: CustomColor.orangeColor,
                                                                                text: "Send",
                                                                                textcolor: Colors.white,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                child: Text("MESSAGE",
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight.w600))),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              })
                                          : Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Container(
                                                height: size.height * 0.5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Ooppss there is no person with that name :( ",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: CustomColor.white, fontSize: 14, fontWeight: FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {}, icon: Icon(Icons.share, color: CustomColor.white)),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Share this app with your buddy",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: CustomColor.white, fontSize: 14, fontWeight: FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset("assets/facebookbtn.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset("assets/instagrambtn.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset("assets/twitterbtn.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset("assets/linkedinbtn.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset("assets/messenger.png"),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Share.share("Share This RunWith App With Your Friends To Join Club");
                                                          },
                                                          child: Image.asset(
                                                            "assets/Chat.png",
                                                            height: 30,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                              return child;
                            },
                          )),
                        ],
                      )),
                  //Right
                  Container(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          handePressed();
                        },
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Card(
                                child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: ListTile(
                                      title: Text(
                                        location,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      dense: true,
                                    )))),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: ButtonWidget(
                      //       btnWidth: MediaQuery.of(context).size.width * 1,
                      //       onPressed: handePressed,
                      //       text: "Search Place"),
                      // ),
                      // TextFormField(
                      //
                      //   style: TextStyle(color: Colors.black),
                      //   decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      //     border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         borderSide: BorderSide(color: Colors.transparent)
                      //     ),
                      //     fillColor: Colors.white,
                      //     filled: true,
                      //     hintText: "Type in Location",
                      //
                      //
                      //     hintStyle: TextStyle(fontSize: 14),
                      //     // suffixIcon: Icon(Icons.filter_alt_sharp,color: Colors.grey[400],)
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 300,
                            child: FutureBuilder<LocationData?>(
                                future: CurrentLocation().getCurrentLocation(),
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
                                  if (snapchat.hasData) {
                                    final LocationData currentLocation = snapchat.data;
                                    return GoogleMap(
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: true,
                                      scrollGesturesEnabled: true,
                                      onTap: (LatLng latLng) {
                                        _markers.clear();
                                        _markers.add(Marker(markerId: MarkerId(latLng.toString()), position: latLng));
                                        map_controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 12));
                                        setState(() {
                                          Locationlat=latLng.latitude;
                                          Locationlng=latLng.longitude;
                                        });
                                      } ,
                                      //List of marker
                                      markers: _markers.toSet(),
                                      mapType: MapType.normal,

                                      //single marker {}
                                      // markers: markers,
                                      onMapCreated: (GoogleMapController controller) async {
                                        map_controller = controller;
                                        //UtintList
                                        // //String imgurl = "https://www.fluttercampus.com/img/car.png";
                                        // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
                                        //     .load(imgurl))
                                        //     .buffer
                                        //     .asUint8List();
                                        //assets one
                                        // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                                        //   ImageConfiguration(),
                                        //   "assets/locationavatar.png",
                                        // );

                                        //googleMapController.complete(controller);
                                        setState(() {
                                          final MarkerId markerId =
                                              MarkerId(LatLng(currentLocation.latitude!, currentLocation.longitude!).toString());

                                          Marker marker = Marker(
                                            //icon: BitmapDescriptor.fromBytes(bytes), //for UTintList
                                            // icon: markerbitmap, // for assets
                                            icon: BitmapDescriptor.defaultMarker,
                                            //default red one
                                            markerId: markerId,

                                            draggable: true,
                                            onDragEnd: (value) {

                                              _markers.clear();
                                              _markers.add(Marker(markerId: MarkerId(value.toString()), position: LatLng(value.latitude,value.longitude)));
                                              map_controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(value.latitude,value.longitude), 10));
                                              setState(() {
                                                Locationlat=value.latitude;
                                                Locationlng=value.longitude;
                                              });

                                              // value is the new position
                                            },
                                            onDragStart: (LatLng latlng){


                                            }
                                             ,
                                            position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                                          );

                                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                            setState(() {
                                              _markers.add(marker);
                                            });
                                          });
                                        });
                                        // markers[markerId] = marker;
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
                                        zoom: 14.4746,
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: CustomColor.orangeColor,
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Slider(
                        activeColor: CustomColor.orangeColor,
                        inactiveColor: CustomColor.white,
                        value: _currentSliderValue,
                        max: 100,
                        divisions: 5,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: ButtonWidget(
                            btnWidth: MediaQuery.of(context).size.width * 1,
                            onPressed: () async {
                              try {
                                BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                                  ImageConfiguration(

                                  ),
                                  "assets/locationavatar.png",
                                );
                                // String imgurl = "${AppUrl.mediaUrl}media/Nigeria-2023-04-10-11-57-15.jpg";
                                // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl)).buffer.asUint8List();
                                // print("networkl image is ${bytes}");
                                final Map<String, dynamic> reqBody = {
                                  "Lat": Locationlat.toString(),
                                  "Lng": Locationlng.toString(),
                                  "KM": "${_currentSliderValue.toString()}"
                                };
                                print("ReqBody of Search by Location Is ${reqBody}");
                                GeneralResponse response = await AppUrl.apiService.runnersbylocations(reqBody);
                                print("Length of Markers Are ${response.data}");
                                _markers.clear();
                                if (response.status == 1) {
                                  TopFunctions.showScaffold("${response.message}");
                                  (response.data as List).forEach((e) async {
                                    String image="${AppUrl.mediaUrl}${e['ProfilePhoto']}";
                                    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(image)).load(image)).buffer.asUint8List();
                                    Uint8List resSizeImage=resizeImage(bytes,100,100)!;
                                    print("ProfilePhoto Marker ${image} ${bytes}");
                                    if(e['ProfilePhoto'] != null ){
                                      setState(() {
                                        _markers.add(Marker(
                                          //add first marker
                                            markerId: MarkerId(LatLng(double.parse(e['Lat']), double.parse(e['Lng'])).toString()),
                                            position: LatLng(double.parse(e['Lat']), double.parse(e['Lng'])),
                                            //position of marker
                                            infoWindow: InfoWindow( //popup info
                                              title: e['FullName'],
                                              snippet: "Points: ${e['Points']}",
                                            ),
                                            icon: BitmapDescriptor.fromBytes(resSizeImage)
                                          //Icon for Marker
                                        ));
                                      });
                                    }
                                    else{
                                     setState(() {
                                       _markers.add(Marker(
                                           markerId: MarkerId(LatLng(double.parse(e['Lat']), double.parse(e['Lng'])).toString()),
                                           position: LatLng(double.parse(e['Lat']), double.parse(e['Lng'])),
                                           icon: markerbitmap));
                                     }); ;
                                    }
                                    print("After Changes Marker Value is ${_markers.length}");
                                    map_controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(_markers[0].position.latitude, _markers[0].position.longitude), 12));
                                  });
    // setState(() async {
    //
    //                               // print("${(response.data as List).map((e) {
    //                               //   print("Location Data is ${e}");
    //                               //   print("Length of marker is before ${_markers.length}");
    //                               //     e['ProfilePhoto'] != null ?
    //                               //
    //                               //     _markers.add(Marker(
    //                               //             //add first marker
    //                               //             markerId: MarkerId(LatLng(double.parse(e['Lat']), double.parse(e['Lng'])).toString()),
    //                               //             position: LatLng(double.parse(e['Lat']), double.parse(e['Lng'])),
    //                               //             //position of marker
    //                               //             // infoWindow: InfoWindow( //popup info
    //                               //             //   title: 'Marker Title First ',
    //                               //             //   snippet: 'My Custom Subtitle',
    //                               //             // ),
    //                               //             icon: markerbitmap
    //                               //             //Icon for Marker
    //                               //             )) :
    //                               //     _markers.add(Marker(
    //                               //         //add first marker
    //                               //         markerId: MarkerId(LatLng(double.parse(e['Lat']), double.parse(e['Lng'])).toString()),
    //                               //         position: LatLng(double.parse(e['Lat']), double.parse(e['Lng'])),
    //                               //         icon: markerbitmap
    //                               //         ));
    //                               // })}");
    // });
    //                               print("Length of marker is after ${_markers.length}");
                                  // markers.add(Marker( //add first marker
                                  //   markerId: MarkerId(LatLng(value!.latitude!,value.longitude!).toString()),
                                  //   position: LatLng(value.latitude!,value.longitude!), //position of marker
                                  //   infoWindow: InfoWindow( //popup info
                                  //     title: 'Marker Title First ',
                                  //     snippet: 'My Custom Subtitle',
                                  //   ),
                                  //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                                  // ));
                                }
                              } catch (e) {
                                TopFunctions.showScaffold("${e}");
                              }
                            },
                            text: "Search Area"),
                      )
                      // ButtonTheme(
                      //   alignedDropdown: true,
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //
                      //     height: 40,
                      //     width: 200,
                      //     decoration: BoxDecoration(
                      //         color: CustomColor.grey_color,
                      //         border: Border.all(color: Colors.transparent),
                      //         borderRadius: BorderRadius.circular(5.0)),
                      //     child: DropdownButton(
                      //       icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                      //       onChanged: (String? value) {
                      //         // This is called when the user selects an item.
                      //
                      //         print("${value}");
                      //         setState(() {
                      //           // RuningGearType = value!;
                      //         });
                      //       },
                      //       alignment: Alignment.center,
                      //       // menuMaxHeight:100,
                      //       isExpanded: true,
                      //       underline: SizedBox(),
                      //
                      //       iconEnabledColor: Colors.white,
                      //       hint: Text(
                      //         "3Km",
                      //         style: TextStyle(color: Colors.black, fontSize: 14,fontWeight:FontWeight.w600),
                      //       ),
                      //
                      //       items: ['1km', '2km', '3km', '4km']
                      //           .map((e) => DropdownMenuItem(
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 e,
                      //                 style: TextStyle(
                      //                     color: Colors.black, fontSize: 14),
                      //               ),
                      //             ],
                      //           ),
                      //           value: e))
                      //           .toList(),
                      //       // onChanged: (value) {  },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ))
                ]),
              )
            ],
          )),
    );
  }
}
