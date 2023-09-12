import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/screens/webView.dart';

class SponsersLogo extends StatefulWidget {
  const SponsersLogo({Key? key}) : super(key: key);

  @override
  State<SponsersLogo> createState() => _SponsersLogoState();
}

class _SponsersLogoState extends State<SponsersLogo> {
  List sponsorImg = [];

  Future<void> sponsorsApi() async {
    try {
      final Map<String, dynamic> reqData = {};
      GeneralResponse response = await AppUrl.apiService.sponsors(reqData);
      if (response.status == 1) {
        print("Data Received Successfully from sponsorsApi(): ${(response.data)}");
        setState(() {
          sponsorImg = response.data as List;
          print("Updated Sponsor Images Are: ${sponsorImg}");
        });
      } else {
        print("Data Received Didn't Successfully from sponsorsApi(): ${response.toString()}");
      }
    } catch (e) {
      print("Exception Occurs on sponsorsApi(): ${e.toString()}");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sponsorsApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: AlignmentDirectional.bottomCenter,
        child: CarouselSlider.builder(
            options: CarouselOptions(
              viewportFraction: 0.2,
              height: 100.0,
              autoPlay: true,
            ),
            itemCount: sponsorImg.length,
            itemBuilder: (context, itemIndex, realIndex) {
              // print("Total Sponsors ${sponsorImg.length}");
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 50,
                    child: sponsorImg.length > 0
                        ? InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => AllWebview(title: "${sponsorImg[itemIndex]['Title']}" ,link: "${sponsorImg[itemIndex]['URL'] ?? 'https://runwith.io'}",)));
                      },
                      child: Image.network("${AppUrl.mediaUrl}${sponsorImg[itemIndex]['BannerImage']}"),
                    )
                        : Image.asset("assets/RunWith_Icon.png"),
                  ));
            }));
  }
}
