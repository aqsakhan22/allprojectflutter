import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/button_widget.dart';
import 'package:runwith/widget/input_textform_fields.dart';

import '../widget/bottom_bar_widget.dart';

class EditGear extends StatefulWidget {
  final String? Type;
  final String? Model;
  final String? YearMake;
  final String? Yearpurchased;
  final String? photo;
  final String? ID;
  final String? TotalRun;
  final String? Descriptioon;

  const EditGear(
      {Key? key, this.Type, this.Model, this.YearMake, this.Yearpurchased, this.photo, this.ID, this.TotalRun, this.Descriptioon})
      : super(key: key);

  @override
  State<EditGear> createState() => _EditGearState();
}

class _EditGearState extends State<EditGear> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String RuningGearType = "";
  bool network_image = false;
  Uint8List? runtimeimage;
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String brandModel = "";
  String YearMake = "";
  String YearPurchased = "";

  Future<File> getFileFromNetworkImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final tempPath = await getTemporaryDirectory();
    File file = File(path.join(tempPath.path, '$fileName.png'));
    file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      network_image = widget.photo == null ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBarWidget.textAppBar("EDIT RUNNING GEAR"),
      bottomNavigationBar: BottomNav(
        scaffoldKey: _key,
      ),
      body: SafeArea(
        child: Container(
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
                      "${widget.Type}",
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
              InkWell(
                  onTap: () async {
                    XFile? pickedFile = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 65,
                    );
                    setState(() {
                      _image = File(pickedFile!.path);
                      runtimeimage = _image!.readAsBytesSync();
                    });
                  },
                  child: Container(

                      // width: size.width * 1,
                      height: size.height * 0.2,
                      // clipBehavior: Clip.hardEdge,
                      // width: 70,
                      // height: 70,
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   color: Colors.grey[300],
                      // ),
                      alignment: Alignment.center,
                      child: _image == null
                          ? Image.network(
                              "${"${AppUrl.mediaUrl}${widget.photo}"}",
                              fit: BoxFit.cover,
                              width: size.width * 0.8,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                      //
                      // CircleAvatar(
                      //         backgroundColor: Colors.transparent,
                      //         backgroundImage: NetworkImage(
                      //             "${AppUrl.mediaUrl}${widget.photo}"),
                      //
                      //         //AssetImage("assets/homeBack2.png")
                      //       )

                      )),
              SizedBox(
                height: 10,
              ),
              InputTextFormField(
                keyboardType: TextInputType.number,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "${widget.Model}",
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
                keyboardType: TextInputType.number,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "${widget.YearMake}",
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
                keyboardType: TextInputType.number,
                fontsize: 12,
                widthSie: size.width * 1,
                hintText: "",
                label: "${widget.Yearpurchased}",
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
                  EasyLoading.show(status: 'Updating...');
                  try {
                    if (network_image == true && _image == null) {
                      // Pick Network Profile Pic And Send Again
                      _image = File((await getFileFromNetworkImage("${AppUrl.mediaUrl}${widget.photo}")).path);
                      await new Future.delayed(const Duration(seconds: 2));
                      setState(() {});
                    }
                    else if (network_image == true && _image != null) {
                      _image = _image;
                    }
                    else if (network_image == false && _image == null) {
                      // Pick Default Profile Pic If Not Available
                      _image = File((await getImageFileFromAssets("DefaultProfilePic.png")).path);
                      await new Future.delayed(const Duration(seconds: 2));
                      setState(() {});
                    }
                    else if (network_image == false && _image != null) {
                      _image = _image;
                    }
                    else {
                      _image = _image;
                    }
                    print("[REQUEST] (updaterunninggear)\n"
                        "${widget.ID}\n"
                        "${_image}\n"
                        "${RuningGearType.toString() == "" ? widget.Type : RuningGearType.toString()}\n"
                        "${(brandModel.toString() == "" ? widget.Model : brandModel.toString())}\n"
                        "${(YearMake.toString() == "" ? widget.YearMake : YearMake.toString())}\n"
                        "${(YearPurchased.toString() == "" ? widget.Yearpurchased : YearPurchased.toString())}\n"
                    );
                    GeneralResponse response = await AppUrl.apiService.updaterunninggear(
                        widget.ID.toString(),
                        _image!,
                        "${RuningGearType.toString() == "" ? widget.Type : RuningGearType.toString()}",
                        "${(brandModel.toString() == "" ? widget.Model : brandModel.toString())}",
                        "${(YearMake.toString() == "" ? widget.YearMake : YearMake.toString())}",
                        "${(YearPurchased.toString() == "" ? widget.Yearpurchased : YearPurchased.toString())}");
                    print("[RECEIVE] (updaterunninggear) ${response.toString()}");
                    EasyLoading.dismiss();
                    if (response.status == 1) {
                      TopFunctions.showScaffold("${response.message}");
                    } else {
                      TopFunctions.showScaffold("${response.message}");
                    }
                  } catch (e) {
                    EasyLoading.dismiss();
                    print("[EXCEPTION] (updaterunninggear) ${e}");
                    TopFunctions.showScaffold("${e.toString()}");
                  }
                },
                color: CustomColor.grey_color,
                textcolor: Colors.black,
                text: "Edit Gear",
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
