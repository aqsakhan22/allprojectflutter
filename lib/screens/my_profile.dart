import 'dart:convert';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/providers/auth_provider.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/country_list.dart';
import 'package:runwith/utility/local.dart';
import 'package:runwith/utility/network.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/input_textform_fields.dart';

import '../network/response/general_response.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late AuthProvider authProvider;
  final _formkey = GlobalKey<FormState>();
  final _formkeyAlert = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isCountrySelected = false;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  String runBefore = "No";
  bool maleCheck = false;
  bool otherCheck = false;
  bool femaleCheck = false;
  final hrsController = TextEditingController(text: "0");
  final minController = TextEditingController(text: "0");
  final designation = TextEditingController(text: "");
  String AMtimeText = "";
  String AMfromHrs = "";
  String AMtoHrs = "";
  String AMfromMin = "";
  String AMtoMin = "";
  String PMtimeText = "";
  String PMfromHrs = "";
  String PMtoHrs = "";
  String PMfromMin = "";
  String PMtoMin = "";
  String measurementSelect = "";
  String runingProgramSelect = "";
  List<String> measurements = ["Kilometers", "Miles"];
  List<String> runingProgram = ["5 KM", "10 KM", "Half Marathon", "Full Marathon"];
  String FastestTime = "";
  String FullName = "";
  String DOB = "";
  String DateOfBirth = "";
  String Height = "";
  String weight = "";
  String country = "";
  String State = "";
  String City = "";
  String RunBeforeHrs = "";
  String RunBeforeMin = "";
  String desc = "";
  String gender = "";
  String mobileNo = "";
  Uint8List? runtimeimage;
  List<String> PreferredDays = [];
  List<String> GoalsDetails = [];
  bool network_image = UserPreferences.get_Profiledata()['ProfilePhoto'] == null ? false : true;
  bool monBtn = false;
  bool tuesBtn = false;
  bool wedBtn = false;
  bool thursBtn = false;
  bool friBtn = false;
  bool satBtn = false;
  bool sunBtn = false;
  bool goal_motivated = false;
  bool goal_personal = false;
  bool goal_meet = false;
  String Goal = "";
  String MembershipLevel = "Basic";
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  Local _platformVersion = Local(dialCode: '+92', countryCode: 'GB');
  final tooltipController = JustTheController();

  void getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    (await n.getData().then((value) {
      print("VALUES ${value}");
      String locationx = jsonDecode(value)["countryCode"];
      _platformVersion.countryCode = locationx;
      setState(() {
        _platformVersion.countryCode = locationx;
        _platformVersion.dialCode =
            "+" + countryList.firstWhere((element) => element.isoCode == locationx, orElse: () => countryList.first).phoneCode;
      });
    }));
    print("_platformVersion.dialCode ${_platformVersion.dialCode}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthProvider>(TopVariables.appNavigationKey.currentContext!);
    getCountry();
    print("getProfile ${UserPreferences.get_Profiledata()}");
    setState(() {
      DOB = "${UserPreferences.get_Profiledata()['DateOfBirth'] == null ? "" : UserPreferences.get_Profiledata()['DateOfBirth']}";
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(DOB);
      var outputFormat = DateFormat('dd/MM/yyyy');
      String formattedDOB = outputFormat.format(inputDate);
      DOB = formattedDOB;
      DateOfBirth = "${UserPreferences.get_Profiledata()['DateOfBirth'] == null ? "" : UserPreferences.get_Profiledata()['DateOfBirth']}";
      AMtimeText =
          "${UserPreferences.get_Profiledata()['AMTimeStart'] == null || UserPreferences.get_Profiledata()['AMTimeStart'] == ":" ? "00" : UserPreferences.get_Profiledata()['AMTimeStart']}"
          ":${(UserPreferences.get_Profiledata()['AMTimeEnd'] == null || UserPreferences.get_Profiledata()['AMTimeEnd'] == ":") ? "00" : UserPreferences.get_Profiledata()['AMTimeEnd']}";
      PMtimeText =
          "${(UserPreferences.get_Profiledata()['PMTimeStart'] == null || UserPreferences.get_Profiledata()['PMTimeStart'] == ":") ? "00" : UserPreferences.get_Profiledata()['PMTimeStart']}:"
          "${(UserPreferences.get_Profiledata()['PMTimeEnd'] == null || UserPreferences.get_Profiledata()['PMTimeEnd'] == ":") ? "00" : UserPreferences.get_Profiledata()['PMTimeEnd']}";
    });
    if (UserPreferences.get_Profiledata()['PreferredDays'] != null) {
      String Days = UserPreferences.get_Profiledata()['PreferredDays'].toString();
      if (Days.contains("Monday")) {
        PreferredDays.add("Monday");
        monBtn = true;
      }
      if (Days.contains("Tuesday")) {
        PreferredDays.add("Tuesday");
        tuesBtn = true;
      }
      if (Days.contains("Wednesday")) {
        PreferredDays.add("Wednesday");
        wedBtn = true;
      }
      if (Days.contains("Thursday")) {
        PreferredDays.add("Thursday");
        thursBtn = true;
      }
      if (Days.contains("Friday")) {
        PreferredDays.add("Friday");
        friBtn = true;
      }
      if (Days.contains("Saturday")) {
        PreferredDays.add("Saturday");
        satBtn = true;
      }
      if (Days.contains("Sunday")) {
        PreferredDays.add("Sunday");
        sunBtn = true;
      }
      String goalSet = UserPreferences.get_Profiledata()['Goal'];
      print("Goal set is ${goalSet}");
      if (goalSet.isNotEmpty) {
        if (goalSet.contains("Get Motivated")) {
          setState(() {
            goal_motivated = true;
            GoalsDetails.add("Get Motivated");
          });
        }
        if (goalSet.contains("To run a personal")) {
          setState(() {
            goal_personal = true;
            GoalsDetails.add("To run a personal");
          });
        }
        if (goalSet.contains("Meet people")) {
          setState(() {
            goal_meet = true;
            GoalsDetails.add("Meet people");
          });
        }
      }
      print("Goal detail is ${GoalsDetails}");
    }
    setState(() {
      FullName = UserPreferences.get_Profiledata()['FullName'] == null ? "" : UserPreferences.get_Profiledata()['FullName'];
      desc = UserPreferences.get_Profiledata()['Designation'] == null ? "" : UserPreferences.get_Profiledata()['Designation'];
      designation.text = desc;
      Height = UserPreferences.get_Profiledata()['Height'] == null ? "" : UserPreferences.get_Profiledata()['Height'];
      weight = UserPreferences.get_Profiledata()['Weight'] == null ? "" : UserPreferences.get_Profiledata()['Weight'];
      maleCheck = UserPreferences.get_Profiledata()['Gender'] == "Male" ? true : false;
      otherCheck = UserPreferences.get_Profiledata()['Gender'] == "Other" ? true : false;
      femaleCheck = UserPreferences.get_Profiledata()['Gender'] == "Female" ? true : false;
      countryValue = UserPreferences.get_Profiledata()['Country'] == null ? "Select Country" : UserPreferences.get_Profiledata()['Country'];
      stateValue = UserPreferences.get_Profiledata()['State'] == null ? "Select State" : UserPreferences.get_Profiledata()['State'];
      cityValue = UserPreferences.get_Profiledata()['City'] == null ? "Select City" : UserPreferences.get_Profiledata()['City'];
      mobileNo = UserPreferences.get_Profiledata()['Phone'] == null ? "" : UserPreferences.get_Profiledata()['Phone'];
      measurementSelect = UserPreferences.get_Profiledata()['MeasurementUnit'] == null
          ? "Measurement"
          : UserPreferences.get_Profiledata()['MeasurementUnit'];
      runBefore = UserPreferences.get_Profiledata()['RunBefore'] == null
          ? "No"
          : UserPreferences.get_Profiledata()['RunBefore'] == "Yes"
              ? "Yes"
              : "No";
      FastestTime = UserPreferences.get_Profiledata()['FastestTime'] == null ? "00:00" : UserPreferences.get_Profiledata()['FastestTime'];
      runingProgramSelect = UserPreferences.get_Profiledata()['RunningProgram'] == null
          ? "Select Running Program"
          : UserPreferences.get_Profiledata()['RunningProgram'];
    });
  }

  Future<File> getFileFromNetworkImage(String imageUrl) async {
    print("image from network is ${imageUrl}");
    ;
    var response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final tempPath = await getTemporaryDirectory();
    File file = File(path.join(tempPath.path, '$fileName.png'));
    file.writeAsBytes(response.bodyBytes);
    print("image from network is after ${file}");
    return file;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      drawer: MyNavigationDrawer(),
      appBar: AppBarWidget.textAppBar("MY PROFILE"),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text("AMTimeStart ${UserPreferences.get_Profiledata()['AMTimeStart']}",style: TextStyle(color: CustomColor.white),),
                  // Text("PMTimeStart${UserPreferences.get_Profiledata()['PMTimeStart']}",style: TextStyle(color: CustomColor.white),),
                  // Text("AMTimeStart ${AMtimeText}",style: TextStyle(color: CustomColor.white),),
                  // Text("pMTimeStart ${PMtimeText}",style: TextStyle(color: CustomColor.white),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: CustomColor.grey_color,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/Clubs');
                            },
                            child: Text(
                              "Join Running Club",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  backgroundColor: CustomColor.grey_color,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              onPressed: () {
                                Navigator.pushNamed(context, '/RunningGear');
                              },
                              child: Text(
                                "Running Gear",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14),
                              )))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //profile image
                  InkWell(
                    onTap: () async {
                      XFile? pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 65,
                      );
                      setState(() {
                        _image = File(pickedFile!.path);
                        network_image = false;
                        runtimeimage = _image!.readAsBytesSync();
                      });
                    },
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                            width: 90,
                            height: 90,
                            child: network_image == true
                                ? Image.network('${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}',
                                    fit: BoxFit.cover, width: 90, height: 90,
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
                                : _image == null
                                    ? Image.asset("assets/raw_profile_pic.png")
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      )),
                      ),
                    ),
                  ),
                  //fullname
                  Container(
                    // color: Colors.red,
                    // alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (FullName == "") {
                          return 'Please enter Full Name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        FullName = value;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "${FullName == "" ? "Enter Your Name" : FullName}  ",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Textarea
                  TextFormField(
                    controller: designation,
                    maxLength: 100,
                    validator: (value) {
                      if (desc == "") {
                        return 'Please enter Designation';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      desc = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(vertical: 40),
                        counterStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        fillColor: Colors.white,
                        filled: true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // dob height weight
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                            child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now());
                            setState(() {
                              DOB = "${picked!.day}/${picked!.month}/${picked!.year}";
                              DateOfBirth = "${picked.year}-${picked.month}-${picked.day}";
                              print("DOB US ${DOB} DateOfBirth ${DateOfBirth}");
                            });
                            // DOB=value;
                          },
                          child: IgnorePointer(
                            child: InputTextFormField(
                              validateData: (value) {
                                if (DOB == "") {
                                  return 'Enter DOB';
                                }
                                return null;
                              },
                              hintText: "Select date of birth",
                              label: "${DOB == "" ? "DD/MM/YYYY" : DOB} ",
                              valueChange: (value) {},
                            ),
                          ),
                        )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          // height: 40,
                          child: InputTextFormField(
                            keyboardType: TextInputType.number, // widthSie: size.width * 1,
                            // hintText: "${Height == "" ? "In Cm" : Height}",
                            label: " ${Height == "" ? "In cm" : Height} ",
                            valueChange: (value) {
                              Height = value;
                            },
                            validateData: (value) {
                              if (Height == "") {
                                return 'Enter Height';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          // height: 40,
                          child: InputTextFormField(
                            keyboardType: TextInputType.number,
                            // widthSie: size.width * 1,
                            label: "${weight == "" ? "In Kg" : weight}",
                            hintText: "In Kg",
                            validateData: (value) {
                              if (weight == "") {
                                return 'Enter Weight';
                              }
                              return null;
                            },
                            valueChange: (value) {
                              weight = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //gender section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              maleCheck = true;
                              femaleCheck = false;
                              otherCheck = false;
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/Male.png",
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Male",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              Visibility(
                                  visible: maleCheck,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            maleCheck = false;
                            femaleCheck = true;
                            otherCheck = false;
                          });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/Female.png",
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Female",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Visibility(
                                visible: femaleCheck,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            maleCheck = false;
                            femaleCheck = false;
                            otherCheck = true;
                          });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/Mix.png",
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Other",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Visibility(
                                visible: otherCheck,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Country State City
                  Text(
                    "Select Country First",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,
                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,
                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.ENABLE,
                      currentCountry: "${countryValue}",
                      currentCity: "${cityValue}",
                      currentState: "${stateValue}",
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.black, border: Border.all(color: Colors.white)),
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.black, border: Border.all(color: Colors.white)),
                      selectedItemStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      // dropdownHeadingStyle: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 17,
                      //     fontWeight: FontWeight.bold),
                      onCountryChanged: (value) {
                        setState(() {
                          print("COUNTRY is ${value}");
                          countryValue = value.split(" ")[4];
                          print("Country is ${countryValue}");
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value.toString();
                        });
                        print("Value os state change is ${value}");
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value.toString();
                        });
                        print("Value os city change is ${value}");
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //phone
                  InputTextFormField(
                    keyboardType: TextInputType.number,
                    fontsize: 12,
                    widthSie: size.width * 1,
                    hintText: "Phone",
                    label: "${mobileNo == "" ? "Phone" : mobileNo}",
                    validateData: (value) {
                      if (mobileNo == "") {
                        return 'Enter Phone Number';
                      }
                      return null;
                    },
                    valueChange: (value) {
                      mobileNo = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Measurement
                  Text(
                    "Select Unit of Measurement",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    alignedDropdown: true,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButton(
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          print("${value}");
                          setState(() {
                            measurementSelect = value!;
                          });
                        },
                        alignment: Alignment.center,
                        // menuMaxHeight: 100,
                        isExpanded: true,
                        underline: SizedBox(),
                        iconEnabledColor: Colors.white,
                        hint: Text(
                          "${measurementSelect == "" ? "Select Unit Of Measurment" : measurementSelect}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        items: measurements
                            .map((e) => DropdownMenuItem(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                                    // Divider(color: Colors.grey.shade400, thickness: 0.5,)
                                  ],
                                ),
                                value: e))
                            .toList(),
                        // onChanged: (value) {  },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Have you run before?",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //yes or no button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: runBefore == "Yes" ? CustomColor.orangeColor : CustomColor.grey_color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              runBefore = "Yes";
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        width: 70,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: runBefore == "No" ? CustomColor.orangeColor : CustomColor.grey_color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              runBefore = "No";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //what is you current
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "What is your current fastest 5km time?",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      JustTheTooltip(
                        controller: tooltipController,
                        isModal: true,
                        triggerMode: TooltipTriggerMode.tap,
                        onShow: () {
                          print('onShow');
                        },
                        onDismiss: () {
                          print('onDismiss');
                        },
                        content: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "5KM Running Algorithm\n\nOver 25 mins is beginner\n\n20-25mins is intermediate\n\n20 mins and less is advanced",
                                style: TextStyle(color: CustomColor.black),
                              )
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.info,
                          size: 24,
                          color: CustomColor.white,
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  runBefore == "Yes"
                      ? InkWell(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    insetPadding: EdgeInsets.all(18.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    content: Container(
                                        width: size.width * 1,
                                        child: Form(
                                            key: _formkeyAlert,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(children: [
                                                  //hours
                                                  Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          onChanged: (value) {
                                                            print("Value isfacfh ${value}");
                                                            hrsController.text = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter Hours';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: InputDecoration(
                                                            errorStyle: TextStyle(fontSize: 12),
                                                            labelStyle: TextStyle(fontSize: 12),
                                                            contentPadding: EdgeInsets.only(left: 5),
                                                            suffixIcon: Icon(Icons.access_time_sharp),
                                                            label: Text(
                                                              "Minutes",
                                                            ),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      )), //minutes
                                                  Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                        child: TextFormField(
                                                          onChanged: (value) {
                                                            minController.text = value;
                                                          },
                                                          keyboardType: TextInputType.number,
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please enter Minutes';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: InputDecoration(
                                                            errorStyle: TextStyle(fontSize: 12),
                                                            labelStyle: TextStyle(fontSize: 12),
                                                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                                                            suffixIcon: Icon(Icons.access_time_sharp),
                                                            label: Text(
                                                              "Seconds",
                                                            ),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      )),
                                                ]),
                                              ],
                                            ))),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: CustomColor.grey_color,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: Colors.transparent),
                                                      borderRadius: BorderRadius.circular(5.0))),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(color: Colors.black),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: Colors.transparent),
                                                      borderRadius: BorderRadius.circular(5.0))),
                                              onPressed: () {
                                                if (_formkeyAlert.currentState!.validate()) {
                                                  setState(() {
                                                    FastestTime = hrsController.text + ":" + minController.text;
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("Ok")),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: IgnorePointer(
                            child: Text(
                              "${FastestTime}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox(),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    "When do you prefer to run?",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                "Time",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ), //AM
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.all(18.0),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          content: Container(
                                              width: size.width * 1,
                                              child: Form(
                                                  key: _formkeyAlert,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            "Start Time",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                      Row(children: [
                                                        //hours
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  print("from value is ${value}");
                                                                  setState(() {
                                                                    AMfromHrs = value;
                                                                  });
                                                                },
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty || value.length < 0) {
                                                                    return 'Please enter Hours';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Hours",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )), //minutes
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    AMfromMin = value;
                                                                  });
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Minutes';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Minutes",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )),
                                                      ]),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            "End Time",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                      Row(children: [
                                                        //hours
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    AMtoHrs = value;
                                                                  });
                                                                },
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Hours';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Hours",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )), //minutes
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    AMtoMin = value;
                                                                  });
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Minutes';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Minutes",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )),
                                                      ]),
                                                    ],
                                                  ))),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: CustomColor.grey_color,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Colors.transparent),
                                                            borderRadius: BorderRadius.circular(5.0))),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(color: Colors.black),
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Colors.transparent),
                                                            borderRadius: BorderRadius.circular(5.0))),
                                                    onPressed: () {
                                                      if (_formkeyAlert.currentState!.validate()) {
                                                        setState(() {
                                                          AMtimeText = "${AMfromHrs}:${AMfromMin}-${AMtoHrs}:${AMtoMin}";
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Ok")),
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "AM",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "${AMtimeText}",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ), //PM
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.all(18.0),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          content: Container(
                                              width: size.width * 1,
                                              child: Form(
                                                  key: _formkeyAlert,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            "Start Time",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                      Row(children: [
                                                        //hours
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  print("from value is ${value}");
                                                                  setState(() {
                                                                    PMfromHrs = value;
                                                                  });
                                                                },
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty || value.length < 0) {
                                                                    return 'Please enter Hours';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Hours",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )), //minutes
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    PMfromMin = value;
                                                                  });
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Minutes';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Minutes",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )),
                                                      ]),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          alignment: Alignment.topLeft,
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            "End Time",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                      Row(children: [
                                                        //hours
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    PMtoHrs = value;
                                                                  });
                                                                },
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Hours';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Hours",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )), //minutes
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: TextFormField(
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    PMtoMin = value;
                                                                  });
                                                                },
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please enter Minutes';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration: InputDecoration(
                                                                  errorStyle: TextStyle(fontSize: 12),
                                                                  labelStyle: TextStyle(fontSize: 12),
                                                                  contentPadding: EdgeInsets.only(left: 5, right: 5),
                                                                  suffixIcon: Icon(Icons.access_time_sharp),
                                                                  label: Text(
                                                                    "Minutes",
                                                                  ),
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                            )),
                                                      ]),
                                                    ],
                                                  ))),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: CustomColor.grey_color,
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Colors.transparent),
                                                            borderRadius: BorderRadius.circular(5.0))),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(color: Colors.black),
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Colors.transparent),
                                                            borderRadius: BorderRadius.circular(5.0))),
                                                    onPressed: () {
                                                      if (_formkeyAlert.currentState!.validate()) {
                                                        setState(() {
                                                          PMtimeText = "${PMfromHrs}:${PMfromMin}-${PMtoHrs}:${PMtoMin}";
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Ok")),
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "PM",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "${PMtimeText}",
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: monBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                      onPrimary: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        monBtn = !monBtn;
                                        if (monBtn == true) {
                                          PreferredDays.add("Monday");
                                        }
                                        if (monBtn == false) {
                                          PreferredDays.remove("Monday");
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Mon",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: tuesBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      print("TUESDAY");
                                      setState(() {
                                        tuesBtn = !tuesBtn;
                                      });

                                      if (tuesBtn == true) {
                                        PreferredDays.add("Tuesday");
                                      }
                                      if (tuesBtn == false) {
                                        PreferredDays.remove("Tuesday");
                                      }
                                    },
                                    child: Text(
                                      "Tues",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: wedBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        wedBtn = !wedBtn;
                                      });
                                      if (wedBtn == true) {
                                        PreferredDays.add("Wednesday");
                                      }
                                      if (wedBtn == false) {
                                        PreferredDays.remove("Wednesday");
                                      }
                                    },
                                    child: Text(
                                      "Wed",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: thursBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        thursBtn = !thursBtn;
                                      });
                                      if (thursBtn == true) {
                                        PreferredDays.add("Thursday");
                                      }
                                      if (thursBtn == false) {
                                        PreferredDays.remove("Thursday");
                                      }
                                    },
                                    child: Text(
                                      "Thur",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: friBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        friBtn = !friBtn;
                                      });

                                      if (friBtn == true) {
                                        PreferredDays.add("Friday");
                                      }
                                      if (friBtn == false) {
                                        PreferredDays.remove("Friday");
                                      }
                                    },
                                    child: Text(
                                      "Fri",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: satBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        satBtn = !satBtn;
                                      });
                                      if (satBtn == true) {
                                        PreferredDays.add("Saturday");
                                      }
                                      if (satBtn == false) {
                                        PreferredDays.remove("Saturday");
                                      }
                                    },
                                    child: Text(
                                      "Sat",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: sunBtn == false ? CustomColor.grey_color : Colors.orangeAccent,
                                        onPrimary: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        sunBtn = !sunBtn;
                                      });
                                      if (sunBtn == true) {
                                        PreferredDays.add("Sunday");
                                      }
                                      if (sunBtn == false) {
                                        PreferredDays.add("Sunday");
                                      }
                                    },
                                    child: Text(
                                      "Sun",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Program Level:",
                        style: TextStyle(color: CustomColor.white),
                      ),
                      Container(
                        width: 130,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(border: Border.all(color: CustomColor.white)),
                        child: Text(
                          "${UserPreferences.get_Profiledata()['MembershipLevel']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: CustomColor.white),
                        ),
                      )
                    ],
                  ),
                  //Time AM PM

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select Running Programs",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Runing
                  ButtonTheme(
                    alignedDropdown: true,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButton(
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          print("${value}");
                          setState(() {
                            runingProgramSelect = value!;
                          });
                        },
                        alignment: Alignment.center,
                        // menuMaxHeight:100,
                        isExpanded: true,
                        underline: SizedBox(),
                        iconEnabledColor: Colors.white,
                        hint: Text(
                          "${runingProgramSelect == "" ? "Select Running Program" : runingProgramSelect}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        items: runingProgram.map((e) => DropdownMenuItem(
                            alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                                    // Divider(color: Colors.grey.shade400, thickness: 0.5,)
                                  ],
                                ),
                                value: e))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "What Is Your Goal?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: size.width * 0.12,
                          width: size.width * 0.5,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: goal_motivated == false ? CustomColor.grey_color : Colors.orangeAccent,
                                  //backgroundColor: CustomColor.grey_color,
                                  onPrimary: Colors.redAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              onPressed: () {
                                if (goal_motivated == true) {
                                  setState(() {
                                    goal_motivated = false;
                                    GoalsDetails.remove("Get Motivated");
                                  });
                                } else {
                                  setState(() {
                                    goal_motivated = true;
                                    GoalsDetails.add("Get Motivated");
                                  });
                                }
                                print("GoalsDetails getmotivated ${GoalsDetails}");
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Get motivated",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                        flex: 4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: size.width * 0.5,
                          height: size.width * 0.12,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: goal_personal == false ? CustomColor.grey_color : Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              onPressed: () {
                                if (goal_personal == true) {
                                  setState(() {
                                    goal_personal = false;
                                    GoalsDetails.remove("To run a personal");
                                  });
                                } else {
                                  setState(() {
                                    goal_personal = true;
                                    GoalsDetails.add("To run a personal");
                                  });
                                }
                                print("GoalsDetails getmotivated ${GoalsDetails}");
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "To run a personal best",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                        flex: 4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: size.width * 0.12,
                          width: size.width * 0.5,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: goal_meet == false ? CustomColor.grey_color : Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              onPressed: () {
                                if (goal_meet == true) {
                                  setState(() {
                                    goal_meet = false;
                                    GoalsDetails.remove("Meet people");
                                  });
                                } else {
                                  setState(() {
                                    goal_meet = true;
                                    GoalsDetails.add("Meet people");
                                  });
                                }
                                print("GoalsDetails getmotivated ${GoalsDetails}");
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Meet people",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                        flex: 4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    btnWidth: size.width * 1,
                    fontSize: 14,
                    fontweight: FontWeight.w700,
                    onPressed: () async {
                      EasyLoading.show(status: 'Updating...');
                      if (network_image == true && _image == null) {
                        // Pick Network Profile Pic And Send Again
                        _image = File((await getFileFromNetworkImage(
                                "${AppUrl.mediaUrl}${UserPreferences.get_Profiledata()['ProfilePhoto']}"))
                            .path);
                        await new Future.delayed(const Duration(seconds: 2));
                        setState(() {});
                      } else if (network_image == true && _image != null) {
                        _image = _image;
                      } else if (network_image == false && _image == null) {
                        // Pick Default Profile Pic If Not Available
                        _image = File((await getImageFileFromAssets("raw_profile_pic.png")).path);
                        await new Future.delayed(const Duration(seconds: 2));
                        setState(() {});
                      } else if (network_image == false && _image != null) {
                        _image = _image;
                      } else {
                        _image = _image;
                      }

                      if (maleCheck == false && femaleCheck == false && otherCheck == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Gender')),
                        );
                      }
                      if (countryValue == "Select Country" || stateValue == "Select State" || cityValue == "Select City") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Country , State , City')),
                        );
                      }
                      if (PreferredDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Prefered Days')),
                        );
                      }
                      if (measurementSelect == "Measurement") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Measurement')),
                        );
                      }
                      if (runingProgramSelect == "Select Running Program") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Running Program')),
                        );
                      }
                      if (GoalsDetails.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select Goal')),
                        );
                      }
                      // if (goal_motivated == true) {
                      //   setState(() {
                      //     Goal = "Get Motivated";
                      //   });
                      // }
                      // if (goal_personal == true) {
                      //   setState(() {
                      //     Goal = "To run a personal";
                      //   });
                      // }
                      // if (goal_meet == true) {
                      //   setState(() {
                      //     Goal = "Meet people";
                      //   });
                      // }
                      if (_formkey.currentState!.validate()) {
                        if (maleCheck) {
                          gender = "Male";
                        }
                        if (femaleCheck) {
                          gender = "Female";
                        }
                        if (otherCheck) {
                          gender = "Other";
                        }
                        try {
                          GeneralResponse response = await AppUrl.apiService.updateProfile(
                            _image!,
                            FullName,
                            desc,
                            mobileNo,
                            DateOfBirth,
                            Height.toString(),
                            weight.toString(),
                            gender,
                            cityValue.toString(),
                            stateValue,
                            countryValue,
                            "Not Available",
                            measurementSelect.toString(),
                            runBefore,
                            FastestTime.toString(),
                            "${AMfromHrs}:${AMfromMin}",
                            "${AMtoHrs}:${AMtoMin}",
                            "${PMfromHrs}:${PMfromMin}",
                            "${PMtoHrs}:${PMtoMin}",
                            jsonEncode(PreferredDays),
                            runingProgramSelect,
                            jsonEncode(GoalsDetails),
                            MembershipLevel,
                          );
                          EasyLoading.dismiss();
                          if (response.status == 1) {
                            UserPreferences.set_Profiledata(response.data);
                            Navigator.pushReplacementNamed(context, '/Home');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.message),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.message),
                            ));
                          }
                        } catch (e) {
                          EasyLoading.dismiss();
                          print("EXCEPTION IS ${e}");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      } else {
                        EasyLoading.dismiss();
                      }
                    },
                    color: CustomColor.grey_color,
                    textcolor: Colors.black,
                    text: "Update",
                  )
                ],
              ),
            ),
          )),
    );
  }
}
