import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runwith/providers/auth_provider.dart';
import 'package:runwith/providers/quotes_provider.dart';
import 'package:runwith/screens/logo_slider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/screens/spotifySample/example.dart';
import 'package:runwith/utility/ProvidersUtility.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';

import '../network/app_url.dart';
import '../network/response/general_response.dart';
import '../providers/audioqueues_provider.dart';
import '../services/background.dart';
import '../utility/top_level_variables.dart';
import '../widget/bottom_bar_widget.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  ImagePicker imagePicker = ImagePicker();
  late AuthProvider authProvider;
  QuoteProvider? quoteProvider;
  AudioQueuesProvider? audioQueuesProvider;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String quote = "";

  @override
  void initState() {
    TopVariables.service.startService().then((value) {
      //Run After Service Start
      print("Background Service Started In Foreground In Home");
      TopVariables.service.on(actionStartBGServices);
    });
    super.initState();
    quoteProvider = ProvidersUtility.quoteProvider;
    quoteProvider!.getQuotes().then((value) {
      setState(() {
        quote = ProvidersUtility.quoteProvider!.quotes[0]['Quote'];
      });
    });
    audioQueuesProvider = ProvidersUtility.audioQueuesProvider;
    audioQueuesProvider!.getAudioQueues().then((value) {

    });
  }

  @override
  Widget build(BuildContext context) {
    dahboardAPI();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      appBar: AppBarWidget.imageAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ElevatedButton(onPressed: (){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => Video_player_Ex()));
              // }, child: Text("video player")),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SpotifyIOS()));
              }, child: Text("Spotofy")),
              SizedBox(
                height: 20,
              ),
              Text(
                "${quote}",
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800),
              ),
              Container(
                child: Divider(
                  height: 40,
                  color: Colors.white,
                  thickness: 1.0,
                ),
              ),
              //Single Tile
              Container(
                  width: size.width * 1,
                  height: size.height * 0.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/RunningProgram');
                    },
                    child: Stack(
                      children: [
                        Container(
                            width: size.width * 1,
                            child: Image.asset(
                              "assets/homeBack.jpg",
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: ButtonWidget(
                            btnWidth: 100.0,
                            btnHeight: 30.0,
                            onPressed: () {
                              Navigator.pushNamed(context, '/RunningProgram');
                            },
                            color: Colors.black,
                            text: "LETS RUN",
                            textcolor: Colors.white,
                            fontSize: 10,
                            fontweight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              //Double Tile
              Container(
                width: size.width * 1,
                height: size.height * 0.2,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/SearchClubs');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: size.width * 0.46,
                              height: size.height * 0.2,
                              child: Image.asset(
                                "assets/homeBack1.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 5,
                              child: ButtonWidget(
                                btnWidth: 120.0,
                                btnHeight: 30.0,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/SearchClubs');
                                },
                                color: Colors.black,
                                text: "COMMUNITY",
                                textcolor: Colors.white,
                                fontSize: 10,
                                fontweight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/ViewEvents');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: size.width * 0.46,
                              height: size.height * 0.2,
                              child: Image.asset(
                                "assets/homeBack2.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 5,
                              child: ButtonWidget(
                                btnWidth: 100.0,
                                btnHeight: 30.0,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/ViewEvents');
                                },
                                color: Colors.black,
                                text: "Events",
                                textcolor: Colors.white,
                                fontSize: 10,
                                fontweight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "SPONSORS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 15,
              ),
              //Logo Slider
              Divider(
                height: 20,
                color: Colors.white,
                thickness: 1,
              ),
              SizedBox(
                height: 20,
              ),
              SponsersLogo(),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 20,
                color: Colors.white,
                thickness: 1,
              ),
              // ElevatedButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => RefereshScreen()));
              // }, child: Text("hello"))

              //drawer and button

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
    );
  }

  Future<void> dahboardAPI() async {
    // Dashboard API Call For Login Check
    try {
      CurrentLocation().getCurrentLocation().then((value) async {
        final Map<String, dynamic> reqData = {
          "Lat": value!.latitude.toString(),
          "Lng": value.longitude.toString()
        };
        print("Sending Data to dashboard(): ${reqData}");
        GeneralResponse response = await AppUrl.apiService.dashboard(reqData);
        print("Receiving Data from dashboard(): ${response.toString()}");
        if (response.status == 1) {
          print(
              "Data Received Successfully from dashboard(): ${response.data}");
          UserPreferences.set_Profiledata(response.data);
          print(
              "DateOfBirth is  ${UserPreferences.get_Profiledata()['DateOfBirth']}");
        } else {
          print(
              "Data Received Didn't Successfully from dashboard(): ${response.toString()}");
        }
      });
    } catch (e) {
      print("Exception Occurs on dashboard(): ${e.toString()}");
    }
    // Dashboard API Call For Login Check
  }
}
