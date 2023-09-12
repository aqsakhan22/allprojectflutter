
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';



class VideoPlaying extends StatefulWidget {

  final String mediaUrl;
  final double? size;

  const VideoPlaying({Key? key, required this.mediaUrl, this.size}) : super(key: key);

  @override
  State<VideoPlaying> createState() => _VideoPlayingState();
}

class _VideoPlayingState extends State<VideoPlaying> {
  late BetterPlayerController _betterplayercontroller;
  GlobalKey _betterplayerkey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    // BetterPlayerConfiguration betterplayerConfiguration = BetterPlayerConfiguration(
    //   aspectRatio:16/ 9,
    //     fit: BoxFit.contain,
    //
    //
    // );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.mediaUrl);
    // _betterplayercontroller = BetterPlayerController(BetterPlayerConfiguration(autoDetectFullscreenAspectRatio: true));
    _betterplayercontroller.setupDataSource(dataSource);
    _betterplayercontroller.setBetterPlayerGlobalKey(_betterplayerkey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // color: Colors.red,
      // height:300,

      child:
        BetterPlayer(

          key: _betterplayerkey,
          controller: _betterplayercontroller,
        ),

    );
  }
}
