import 'package:flutter/material.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/edit_gear.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

class GearList extends StatefulWidget {
  const GearList({Key? key}) : super(key: key);

  @override
  State<GearList> createState() => _GearListState();
}

class _GearListState extends State<GearList> {
  List GearList = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    RnunngGearList();
    super.initState();
  }

  void RnunngGearList() async {
    try {
      Map<String, dynamic> reqBody = {};
      GeneralResponse response = await AppUrl.apiService.runninggears(reqBody);
      print("RUNNING GEAR LIST is ${response.data}");
      setState(() {
        GearList = response.data;
      });
    } catch (e) {
      print("EXCEPTION ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.textAppBar("RUNNING GEAR"),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: GearList.isEmpty
            ? Center(
                child: Text(
                  "No Data Found.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shrinkWrap: true,
                itemCount: GearList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Container(
                          padding: EdgeInsets.only(right: 10, left: 10.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage("${AppUrl.mediaUrl}${GearList[index]['Photo']}"),
                          )),
                      title: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "${GearList[index]['Type']}",
                            style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                          )),
                      subtitle: Text("${GearList[index]['TotalRun']}", style: TextStyle(fontSize: 12, color: Colors.black)),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditGear(
                                        Type: "${GearList[index]['Type']}",
                                        photo: "${GearList[index]['Photo']}",
                                        Model: "${GearList[index]['Brand']}",
                                        YearMake: "${GearList[index]['YearOfMake']}",
                                        Yearpurchased: "${GearList[index]['YearOfPurchased']}",
                                        ID: "${GearList[index]['ID']}",
                                        TotalRun: "${GearList[index]['TotalRun']}",
                                        Descriptioon: "${GearList[index]['Description']}",
                                      )));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
