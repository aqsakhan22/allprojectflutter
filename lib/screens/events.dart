import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/running_program_provider.dart';
import 'package:runwith/screens/event_details.dart';
import 'package:runwith/screens/event_program_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:share_plus/share_plus.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late RunningProgramProvider runningEvents;
 bool isLoader=true;
  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    return d; //KM
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoader=true;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      runningEvents.runningEvents().then((value) {

       setState(() {
         isLoader=false;
       });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    runningEvents = Provider.of<RunningProgramProvider>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      key: _key,
      appBar: AppBarWidget.textAppBar('EVENTS'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Consumer<RunningProgramProvider>(builder: (context, eventsData, child) {
          if(isLoader == true){
            child=Center(
              child: CircularProgressIndicator(
                color: CustomColor.white,
              ),
            );
          }
   else{

            child =
            eventsData.Events.isEmpty
                ? Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: eventsData.Events.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails(
                            eventImage: eventsData.Events[index]['ClubLogo'],
                            BannerImage: eventsData.Events[index]['Banner'],
                            Title: eventsData.Events[index]['Title'],
                            Desc: eventsData.Events[index]['Description'],
                            DateTimefrom: eventsData.Events[index]['DateTimeFrom'],
                            Type: eventsData.Events[index]['Type'],
                            RunKM: eventsData.Events[index]['RunKM'],
                            RunnerStatus: eventsData.Events[index]['RunnerStatus'] ?? "",
                            Location: eventsData.Events[index]['Location'],
                            ID: eventsData.Events[index]['ID'],
                            Body: eventsData.Events[index]['Body'],





                          )));
                        },
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                eventsData.Events[index]['Title'] != null ?
                                CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage("${AppUrl.mediaUrl}${eventsData.Events[index]['Banner']}")
                                  //AssetImage("assets/homeBack2.png")

                                )

                                    :
                                CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage("assets/RunWith_Icon.png")
                                  //AssetImage("assets/homeBack2.png")

                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("${eventsData.Events[index]['Title']}", style: TextStyle(color: Colors.white)),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${eventsData.Events[index]['DateTimeFrom']}",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                                ),
                                Container(
                                  height: 25,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                    indent: 3.0,
                                    endIndent: 3.0,
                                    thickness: 1.0,
                                  ),
                                ),
                                Text(
                                  "${eventsData.Events[index]['DateTimeTo']}",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                                ),
                                Container(
                                  height: 25,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                    indent: 3.0,
                                    endIndent: 3.0,
                                    thickness: 1.0,
                                  ),
                                ),
                                Text(
                                  "${eventsData.Events[index]['Type'].toString().toUpperCase()}",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                                ),
                                Container(
                                  height: 25,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                    indent: 3.0,
                                    endIndent: 3.0,
                                    thickness: 1.0,
                                  ),
                                ),
                                Text(
                                  "${eventsData.Events[index]['RunKM']}",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Image border
                              child: SizedBox.fromSize(
                                // size: Size.fromRadius(48), // Image radius
                                  child: Image.network("${AppUrl.mediaUrl}${eventsData.Events[index]['Banner']}",
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      })
                                //Image.asset("assets/events.png",fit: BoxFit.cover,height: 150),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${eventsData.Events[index]['Description']}"
                              // "Registration Fees: 3K – \$400 , 5K – \$500 10K – \$700\nInclusive of Race Singlet, Race Bib, Medal, and Loot Bag\n– 10K gets a Finisher’s Shirt "
                              ,
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidget(
                                  btnWidth: 100,
                                  onPressed: () async {
                                    print("OnPressed ${eventsData.Events[index]['Type']}");

                                    if (eventsData.Events[index]['RunnerStatus'] == null) {
                                      eventsData.Events[index]['Type'] == "Event"
                                          ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                              title: Text(
                                                "Program Details",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              content: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Description",
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${eventsData.Events[index]['Title']} ",
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "${eventsData.Events[index]['Description']}",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              actions: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: ButtonWidget(
                                                    onPressed: () {
                                                      try {
                                                        EasyLoading.show(status: 'Attending...');
                                                        CurrentLocation().getCurrentLocation().then((value) async {
                                                          if (eventsData.Events[index]['Location'] != null) {
                                                            double distance = getDistanceFromLatLonInKm(
                                                                double.parse(eventsData.Events[index]['Location']
                                                                    .toString()
                                                                    .split(",")[0]),
                                                                double.parse(eventsData.Events[index]['Location']
                                                                    .toString()
                                                                    .split(",")[1]),
                                                                value!.latitude,
                                                                value.longitude);
                                                            final Map<String, dynamic> reqBody = {
                                                              "ClubEvent_ID": eventsData.Events[index]['ID'],
                                                              "Status": "Attended",
                                                              "Run_ID": 0,
                                                              "Lat": value.latitude!.toString(),
                                                              "Lng": value.longitude.toString()
                                                            };
                                                            if (double.parse((distance * 1000).toStringAsFixed(2)) < 100) {
                                                              GeneralResponse response =
                                                              await AppUrl.apiService.clubeventstatus(reqBody);

                                                              EasyLoading.dismiss();
                                                              if (response.status == 1) {
                                                                TopFunctions.showScaffold("${response.message}");
                                                                Navigator.pop(context);
                                                              } else {
                                                                TopFunctions.showScaffold("${response.message}");
                                                                Navigator.pop(context);
                                                              }
                                                            } else {

                                                              EasyLoading.dismiss();
                                                              TopFunctions.showScaffold("You Are far away from destination");
                                                              Navigator.pop(context);
                                                            }
                                                          } else {
                                                            EasyLoading.dismiss();
                                                            TopFunctions.showScaffold("Events Location is not Found");
                                                          }
                                                        });
                                                      } catch (e) {
                                                        EasyLoading.dismiss();
                                                        print("Exception is${e}");
                                                      }
                                                    },
                                                    btnWidth: size.width * 0.3,
                                                    text: "OK",
                                                    color: CustomColor.grey_color,
                                                    textcolor: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            );
                                          })
                                          : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                              title: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                                  child: Text(
                                                    "Program Details",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 16),
                                                  )),
                                              content: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Description",
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${eventsData.Events[index]['Title']} ",
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "${eventsData.Events[index]['Description']}",
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              actions: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: ButtonWidget(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        btnWidth: size.width * 0.3,
                                                        text: "Cancel Event",
                                                        color: CustomColor.grey_color,
                                                        textcolor: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ButtonWidget(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();

                                                          UserPreferences.eventId = eventsData.Events[index]['ID'];
                                                          UserPreferences.eventRun = eventsData.Events[index]['RunKM'];
                                                          print("Event run is ${UserPreferences.eventRun}");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EventProgramRun(
                                                                    title: "EVENT PROGRAM",
                                                                    EventId: eventsData.Events[index]['ID'],
                                                                  )));
                                                        },
                                                        btnWidth: size.width * 0.3,
                                                        text: "Event Program",
                                                        color: CustomColor.orangeColor,
                                                        textcolor: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      TopFunctions.showScaffold(" Attended");
                                    }
                                  },
                                  color: CustomColor.grey_color,
                                  textcolor: Colors.black,
                                  text: "Register",
                                  fontweight: FontWeight.w900,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ButtonWidget(
                                  btnWidth: 100,
                                  onPressed: () {
                                    Share.share("Share This RunWith App With Your Friends To Join Club");
                                  },
                                  color: CustomColor.grey_color,
                                  textcolor: Colors.black,
                                  text: "SHARE",
                                  fontweight: FontWeight.w900,
                                ),
                              ],
                            )
                          ],
                        ),
                      )

                      ;
                    });
          }

          return child;
        }),
      ),
    );
  }
}
