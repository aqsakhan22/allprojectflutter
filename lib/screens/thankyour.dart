// import 'package:flutter/material.dart';
// import 'package:runwith/screens/home.dart';
// import 'package:runwith/utility/shared_preference.dart';
// import 'package:share_plus/share_plus.dart';
// class ThankYou extends StatefulWidget {
//   const ThankYou({Key? key}) : super(key: key);
//
//   @override
//   State<ThankYou> createState() => _ThankYouState();
// }
//
// class _ThankYouState extends State<ThankYou> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//          appBar: AppBar(
//            leading: InkWell(
//              child: Icon(Icons.arrow_back),
//              onTap: (){
//                Navigator.pop(context);
//                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
//              },
//            ),
//            actions: [
//              Container(
//              alignment: Alignment.bottomRight,
//              padding: EdgeInsets.only(bottom: 10,right: 10),
//              child:
//              UserPreferences.get_Profiledata()['ProfilePhoto'] == null ? Image.asset("assets/raw_profile_pic.png",height: 30,) :
//
//                   ClipOval(
//                     child: Material(
//                       child: Container(
//                         height: 35,
//                         width: 35,
//                         child:  Image.network(
//                             'https://ansariacademy.com/RunWith/${UserPreferences.get_Profiledata()['ProfilePhoto']}',fit: BoxFit.cover,
//                             width: 90,
//                             height: 90,
//                             loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   value: loadingProgress.expectedTotalBytes != null ?
//                                   loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                                       : null,
//                                 ),
//                               );
//                             }
//                         ),
//                       ),
//                     ),
//                   )
//
//
//            ),],
//          ),
//
//       body: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(horizontal: 20.0),
//         child:Column(
//
//
//           children: [
//             SizedBox(height: 40,),
//
//
//
//            Container(
//              height: MediaQuery.of(context).size.height * 0.5,
//
//              child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  Container(
//
//                      alignment: Alignment.center,
//                      // width: 180,
//                      child: Image.asset("assets/RunWith-WhiteLogo.png")),
//                  SizedBox(height: 20,),
//                  Container(
//
//                      width: 50,
//                      child: Image.asset("assets/thankyou.png")),
//
//                  SizedBox(height: 10,),
//
//                  Container(
//
//                      alignment: Alignment.center,
//
//                      child: Text("Thank you!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 30),)),
//
//                  SizedBox(height: 20,),
//
//                  Text("Share this app with your buddy",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 14),)
//               ,
//               SizedBox(height: 50,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//
//                 children: [
//                    InkWell(
//                      onTap: (){
//                        Share.share("Share This RunWith App With Your Friends To Join Club");
//                      },
//                      child: Image.asset("assets/facebookbtn.png"),
//                    ),
//
//              SizedBox(width: 10,),
//                   InkWell(
//                     onTap: (){
//                       Share.share("Share This RunWith App With Your Friends To Join Club");
//                     },
//                     child: Image.asset("assets/instagrambtn.png"),
//                   ),
//                   SizedBox(width: 10,),
//                  InkWell(
//                    onTap: (){
//                      Share.share("Share This RunWith App With Your Friends To Join Club");
//
//                    },
//                    child:  Image.asset("assets/twitterbtn.png"),
//                  ),
//                   SizedBox(width: 10,),
//
//                   InkWell(
//                     onTap: (){
//                       Share.share("Share This RunWith App With Your Friends To Join Club");
//                     },
//                     child:  Image.asset("assets/linkedinbtn.png"),
//                   ),
//                   SizedBox(width: 10,),
//                   InkWell(
//                     onTap: (){
//                       Share.share("Share This RunWith App With Your Friends To Join Club");
//                     },
//                     child:  Image.asset("assets/messenger.png"),
//                   ),
//                   SizedBox(width: 10,),
//                  InkWell(
//                    onTap: (){
//                      Share.share("Share This RunWith App With Your Friends To Join Club");
//                    },
//                    child:  Image.asset("assets/Chat.png"),
//                  )
//                 ],
//               )
//                ],
//              ),
//            )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
