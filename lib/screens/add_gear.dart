import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/input_textform_fields.dart';

class AddGear extends StatefulWidget {
  const AddGear({Key? key}) : super(key: key);

  @override
  State<AddGear> createState() => _AddGearState();
}

class _AddGearState extends State<AddGear> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String RuningGearType = "Type of Running Gear";
  Uint8List? runtimeimage;
  File? image;
  ImagePicker imagePicker = ImagePicker();
  String brandModel = "";
  String YearMake = "";
  String YearPurchased = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyNavigationDrawer(),
      appBar: AppBarWidget.textAppBar("ADD RUNNING GEAR"),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonTheme(
                alignedDropdown: true,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
                  child: DropdownButton(
                    onChanged: (String? value) {
                      // This is called when the user selects an item.

                      print("${value}");
                      setState(() {
                        RuningGearType = value!;
                      });
                    },
                    alignment: Alignment.center,
                    // menuMaxHeight:100,
                    isExpanded: true,
                    underline: SizedBox(),

                    iconEnabledColor: Colors.white,
                    hint: Text(
                      "${RuningGearType}",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),

                    items: ['SHOES', 'SHIRTS', 'HYDRATION', 'SHORTS']
                        .map((e) => DropdownMenuItem(
                            child: Column(
                              children: [
                                Text(
                                  e,
                                  style: TextStyle(color: Colors.black, fontSize: 14),
                                ),
                              ],
                            ),
                            value: e))
                        .toList(),
                    // onChanged: (value) {  },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // InkWell(
              //   onTap: () async {
              //     XFile? pickedFile = await imagePicker.pickImage(
              //       source: ImageSource.gallery,
              //       imageQuality: 65,
              //     );
              //     setState(() {
              //       _image = File(pickedFile!.path);
              //
              //       runtimeimage = _image!.readAsBytesSync();
              //     });
              //   },
              //   child: CircleAvatar(
              //     backgroundColor: Colors.green,
              //     radius: 40,
              //     child:CircleAvatar(
              //       backgroundImage: _image == null ? AssetImage("assets/raw_profile_pic.png"):
              //
              //       ,//NetworkImage
              //       radius: 50,
              //     ),
              //
              //     //AssetImage("assets/homeBack2.png")
              //
              //   ),
              // ),

              //AssetImage("assets/raw_profile_pic.png")
              InkWell(
                  onTap: () async {
                    XFile? pickedFile = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 65,
                    );
                    setState(() {
                      print("before is ${image}");
                      image = File(pickedFile!.path);

                     // runtimeimage = _image!.readAsBytesSync();
                    });
                    print("after is ${image}");
                  },
                  child: Container(
                      width: size.width,
                      height: size.height * 0.2,
                      clipBehavior: Clip.hardEdge,
                      // width: 70,
                      // height: 70,
                      decoration: BoxDecoration(// shape: BoxShape.circle,
                          // color: Colors.grey[300],
                          ),
                      alignment: Alignment.center,
                      child: image == null
                          ? Image.asset('assets/galleryimage.jpg')
                          : Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ))

                  // ClipOval(
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: Container(
                  //         width: 90,
                  //         height: 90,
                  //         child: network_image == true ?  Image.network(
                  //             'https://ansariacademy.com/RunWith/${UserPreferences.get_Profiledata()['ProfilePhoto']}',fit: BoxFit.cover,
                  //             width: 90,
                  //             height: 90,
                  //             loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                  //               if (loadingProgress == null) return child;
                  //               return Center(
                  //                 child: CircularProgressIndicator(
                  //                   value: loadingProgress.expectedTotalBytes != null ?
                  //                   loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  //                       : null,
                  //                 ),
                  //               );
                  //             }
                  //         ) :   _image == null ? Image.asset("assets/raw_profile_pic.png") : Image.file(_image!,fit: BoxFit.cover,)
                  //
                  //
                  //     ),
                  //   ),
                  // ),

                  ),
              SizedBox(
                height: 10,
              ),
              InputTextFormField(
                keyboardType: TextInputType.text,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "Brand Model",
                validateData: (value) {
                  // if (mobileNo == "" ) {
                  //   return 'Enter Phone Number';
                  // }
                  // return null;
                },
                valueChange: (value) {
                  setState(() {
                    brandModel = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              InputTextFormField(
                keyboardType: TextInputType.text,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "Year Make",
                validateData: (value) {
                  // if (mobileNo == "" ) {
                  //   return 'Enter Phone Number';
                  // }
                  // return null;
                },
                valueChange: (value) {
                  setState(() {
                    YearMake = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              InputTextFormField(
                keyboardType: TextInputType.text,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "Year Purchased",
                validateData: (value) {
                  // if (mobileNo == "" ) {
                  //   return 'Enter Phone Number';
                  // }
                  // return null;
                },
                valueChange: (value) {
                  setState(() {
                    YearPurchased = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ButtonWidget(
                onPressed: () async {
                  EasyLoading.show(status: 'Saving...');
                  try {
                    final Map<String, dynamic> reqData = {
                      "Photo": image,
                      "Type": "${RuningGearType.toString()}",
                      "Brand": "${brandModel.toString()}",
                      "YearOfMake": "${YearMake.toString()}",
                      "YearOfPurchased": "${YearPurchased.toString()}"
                    };
                    print("reqBody is ${reqData}");
                    GeneralResponse response = await AppUrl.apiService.addrunninggear
                      (
                         image!,
                        RuningGearType.toString(),
                        brandModel.toString(),
                        YearMake.toString(),
                        YearPurchased.toString()
                    );
                    print("Receiving Data from Dashboard: ${response.toString()}");
                    EasyLoading.dismiss();
                    if (response.status == 1) {
                      TopFunctions.showScaffold("${response.message}");
                    } else {}
                  } catch (e) {
                    EasyLoading.dismiss();
                    print("EXCEPTIOM OF sponsor IS ${e}");
                  }
                },
                color: CustomColor.grey_color,
                textcolor: Colors.black,
                text: "Add Gear",
                fontSize: 14,
                fontweight: FontWeight.w600,
              )
            ],
          ),
        ),
      ),
    );
  }
}
