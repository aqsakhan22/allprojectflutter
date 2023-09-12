import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// class  Video_player_Ex extends StatefulWidget {
//   Video_player_Ex({super.key});
//
//   @override
//   _Video_player_ExState createState() => _Video_player_ExState();
// }
//
// class _Video_player_ExState extends State<Video_player_Ex> {
//   late VlcPlayerController _videoPlayerController=VlcPlayerController.network(
//   'https://media.w3.org/2010/05/sintel/trailer.mp4',
//   hwAcc: HwAcc.full,
//   autoPlay: true,
//   options: VlcPlayerOptions(
//   ),
//
//   );
//
//   Future<void> initializePlayer() async {}
//
//   @override
//   void initState() {
//     super.initState();
//
//
//     // _videoPlayerController = VlcPlayerController.network(
//     //   'https://media.w3.org/2010/05/sintel/trailer.mp4',
//     //   hwAcc: HwAcc.full,
//     //   autoPlay: true,
//     //   options: VlcPlayerOptions(),
//     // );
//
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     await _videoPlayerController.stopRendererScanning();
//     // await _videoViewController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: VlcPlayer(
//             controller: _videoPlayerController,
//             aspectRatio: 16 / 9,
//             placeholder: Center(child: CircularProgressIndicator()),
//           ),
//         )
//     );
//
//   }
// }
//

//example2
// class  Video_player_Ex extends StatefulWidget {
//   Video_player_Ex({super.key});
//
//   @override
//   _Video_player_ExState createState() => _Video_player_ExState();
// }
//
// class _Video_player_ExState extends State<Video_player_Ex> {
//   late bool _isplaying = true;
//   final VlcPlayerController controller = VlcPlayerController.network(
//     "https://media.w3.org/2010/05/sintel/trailer.mp4",
//     hwAcc: HwAcc.full,
//     autoPlay: false,
//     options: VlcPlayerOptions(),
//   );
//
//
//
//   Future<void> initializePlayer() async {}
//
//   @override
//   void initState() {
//     super.initState();
//
//
//
//
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: Column(
//             children: [
//               Text("video"),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: 225,
//                 child: VlcPlayer(
//                   aspectRatio: 16 / 9,
//                   controller: controller,
//                   placeholder: const Center(child: CircularProgressIndicator()),
//                 ),
//               ),
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (_isplaying)
//                       TextButton(
//                         onPressed: () {
//                           controller.pause();
//                           setState(() {
//                             _isplaying = false;
//                           });
//                         },
//                         child: const Icon(
//                           Icons.play_arrow,
//                           size: 50,
//
//                         ),
//                       )
//
//                     else
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             _isplaying = true;
//                             controller.play();
//                           });
//                         },
//                         child: Icon(
//                           Icons.pause,
//                           size: 50,
//
//                         ),
//                       ),
//
//
//                   ],
//                 ),
//               )
//             ],
//           )
//         )
//     );
//
//   }
// }
//
// example3
class  Video_player_Ex extends StatefulWidget {
  Video_player_Ex({super.key});

  @override
  _Video_player_ExState createState() => _Video_player_ExState();
}

class _Video_player_ExState extends State<Video_player_Ex> {

   String urlToStreamVideo="https://media.w3.org/2010/05/sintel/trailer.mp4";
   VlcPlayerController controller=VlcPlayerController.network(
     autoPlay:false,
     hwAcc:HwAcc.full,
     "https://media.w3.org/2010/05/sintel/trailer.mp4",
       options:VlcPlayerOptions(
         advanced: VlcAdvancedOptions([
           VlcAdvancedOptions.networkCaching(2000),
         ]),
         subtitle: VlcSubtitleOptions([
           VlcSubtitleOptions.boldStyle(true),
           VlcSubtitleOptions.fontSize(30),
           VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
           VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
           // works only on externally added subtitles
           VlcSubtitleOptions.color(VlcSubtitleColor.navy),
         ]),
         http: VlcHttpOptions([
           VlcHttpOptions.httpReconnect(true),
         ]),
         rtp: VlcRtpOptions([
           VlcRtpOptions.rtpOverRtsp(true),
         ]),
       )

   );


 videoInitialize() {


   print("conteoller initialze ${controller.dataSource} ${controller.hasListeners}");

 }

  //  final VlcPlayerController controller1 = VlcPlayerController.network(
  //   "https://media.w3.org/2010/05/sintel/trailer.mp4",
  //   hwAcc: HwAcc.full,
  //   autoPlay: false,
  //   options: VlcPlayerOptions(),
  // );

   int playerWidth = 640;
   int playerHeight = 360;



  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    videoInitialize();

  });
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child:
          controller.dataSource.isNotEmpty ?
          Column(
            children: [
              Text("video"),


              SizedBox(
                  height: 640,
                  width: 390,
                  child:  VlcPlayer(
                    aspectRatio: 16 / 9,
                    controller: controller,
                    placeholder: Center(child: CircularProgressIndicator()),

                  )
              ),

              IconButton(onPressed: (){
                print("contoller status ${controller.isPlaying()}");
                controller.play();
              }, icon: Icon(Icons.play_arrow,size: 32,)
              )
            ],
          )
              :
          Center(child: CircularProgressIndicator()),
        )
    );

  }
}









