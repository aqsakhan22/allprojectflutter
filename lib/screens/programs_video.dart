import 'package:better_player/better_player.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:runwith/screens/videoplayer_VLC/video_data.dart';
import 'package:runwith/screens/videoplayer_VLC/vlc_player_with_controls.dart';

import '../widget/app_bar_widget.dart';

class ProgramVideos extends StatefulWidget {
  final String? name;
  final String? desc;
  final String mediaUrl;
  final String imgUrl;

  const ProgramVideos({Key? key, required this.name, required this.mediaUrl, required this.desc, required this.imgUrl})
      : super(key: key);

  @override
  State<ProgramVideos> createState() => _ProgramVideosState();
}

class _ProgramVideosState extends State<ProgramVideos> {
  late BetterPlayerController _betterplayercontroller;
  GlobalKey _betterplayerkey = GlobalKey();
  Future<List<CastDevice>>? _future;
  late VlcPlayerController _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  //
  late List<VideoData> listVideos;
  late int selectedVideoIndex;

  void fillVideos() {
    listVideos = <VideoData>[];
    //
    listVideos.add(VideoData(
      name: 'Network Video 1',
      path:
      '${widget.mediaUrl}',
      type: VideoType.network,
    ));

  }

  @override
  void dispose() async {
    super.dispose();
    await _controller.stopRecording();
    await _controller.stopRendererScanning();
    await _controller.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    BetterPlayerConfiguration betterplayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9, fit: BoxFit.contain,

    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.mediaUrl);
    _betterplayercontroller = BetterPlayerController(betterplayerConfiguration);
    _betterplayercontroller.setupDataSource(dataSource);
    _betterplayercontroller.setBetterPlayerGlobalKey(_betterplayerkey);
    _startSearch();
    //
    fillVideos();
    selectedVideoIndex = 0;
    //
    var initVideo = listVideos[selectedVideoIndex];
    print("initVideo.type ${initVideo.type}");
    switch (initVideo.type) {

      case VideoType.network:_controller = VlcPlayerController.network(
        initVideo.path,
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
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
        ),
      );
      break;
      case VideoType.recorded:
        break;
    }
    _controller.addOnInitListener(() async {
      await _controller.startRendererScanning();
    });
    _controller.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.textAppBar('WATCH'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          SizedBox(
            height: 8,
          ),
          Text(
            "${widget.name}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orangeAccent),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${widget.desc == "null" ? "" : widget.desc}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),

          ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 400,
                child: VlcPlayerWithControls(
                  key: _key,
                  controller: _controller,
                  onStopRecording: (recordPath) {
                    setState(() {

                    });


                  },
                ),
              ),

            ],
          ),


          // Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.0),
          //     child: ElevatedButton.icon(
          //         onPressed: () {
          //           showDialog(
          //               // useSafeArea:false,
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return AlertDialog(
          //                   contentPadding: EdgeInsets.zero,
          //                   content: CastDevices(),
          //                 );
          //               });
          //         },
          //         icon: Image.asset(
          //           "assets/Chromecast.png",
          //           height: 20,
          //         ),
          //         label: Text("Connect to ChromeCast"))),
          // BetterPlayer(
          //   key: _betterplayerkey,
          //   controller: _betterplayercontroller,
          // ),
        ],
      ),
    );
  }

  Widget CastDevices() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FutureBuilder<List<CastDevice>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString()}',
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'No Chromecast founded',
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: snapshot.data!.map((device) {
              return ListTile(
                leading: Icon(Icons.tv),
                title: Text(device.name),
                onTap: () {
                  // _connectToYourApp(context, device);
                  _connectAndPlayMedia(context, device).then((value) {
                    Navigator.pop(context);
                  });
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  Future<void> _connectAndPlayMedia(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);
    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        // Scaffold.of(context).showSnackBar(snackBar);
      }
    });
    bool runOneTime = true;
    session.messageStream.listen((message) {
      print('RunOneTime = $runOneTime');
      print('Status Receive  = $message');
      print('Session = $session');
      if (runOneTime == true) {
        runOneTime = false;
        // Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        // });
      }
    });
    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '788D98F9', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    print('_sendMessagePlayVideo ${widget.mediaUrl}');
    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': '${widget.mediaUrl}',
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED', // or LIVE
      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': "${widget.name}",
        'images': [
          {'url': '"${widget.imgUrl}'}
        ]
      }
    };
    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}
