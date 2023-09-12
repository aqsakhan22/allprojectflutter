import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:runwith/dialog/confirmation_dialogbox.dart';
import 'package:runwith/network/app_url.dart';
import 'package:runwith/network/response/general_response.dart';
import 'package:runwith/providers/run_provider.dart';
import 'package:runwith/screens/event_program_run.dart';
import 'package:runwith/screens/finish_run.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/utility/current_location.dart';
import 'package:runwith/utility/shared_preference.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../dialog/progress_dialog.dart';
import '../../services/background.dart';
import '../../theme/color.dart';
import '../../utility/top_level_variables.dart';

//https://developer.spotify.com/documentation/web-api/
//https://www.quora.com/unanswered/How-do-I-connect-a-Spotify-API-with-a-flutter-for-a-mobile-app

//Todo don't remove the better player code will be use in future if we needed
class OldDebugging extends StatefulWidget {
  const OldDebugging({Key? key}) : super(key: key);

  @override
  State<OldDebugging> createState() => _OldDebuggingState();
}

class _OldDebuggingState extends State<OldDebugging> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true,
    ),
  );
  String clientId = "dbca525ea5094035bfaffdf790104549";
  String RedirectUrl = "comspotifytestsdk://SpotifyAuthentication";
  String TrackId = "yaha track id use huig";
  late ImageUri? currentTrackImageUri;
  bool _connected = false;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: MyNavigationDrawer(),
        key: _key,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(TopVariables.appNavigationKey.currentContext!, '/Home');
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text('Your SpotifySdk Example'),
          actions: [
            _connected
                ? IconButton(
              onPressed: disconnect,
              icon: const Icon(Icons.exit_to_app),
            )
                : Container()
          ],
        ),
        body: StreamBuilder<ConnectionStatus>(
            stream: SpotifySdk.subscribeConnectionStatus(),
            builder: (context, snapshot) {
              _connected = false;
              var data = snapshot.data;
              if (data != null) {
                print("data value is ${data.connected}");
                _connected = data.connected;
              }
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //spotify button
                      Container(
                          height: 45,
                          child: _connected == false
                              ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColor.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                // connectToSpotifyRemote();
                                getAccessToken();
                              },
                              icon: Image.asset(
                                "assets/spotify.png",
                                height: 20,
                              ),
                              label: Text("Connect with Spotify"))
                              : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColor.subBtn,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                disconnect();
                              },
                              icon: Image.asset(
                                "assets/spotify.png",
                                height: 20,
                              ),
                              label: Text("Disconnect with spotify"))),
                      _connected ? _buildPlayerStateWidget() : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            }),
    );
  }

  Future<void> connectToSpotifyRemote() async {
    print("Connecting Remote");
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: RedirectUrl,
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public, '
            'user-read-currently-playing'
            'user-read-private'
            'user-read-email',
        //  accessToken: UserPreferences.spotifyToken,
      );
      print("Remote ${result}");
      setStatus(result ? 'connect to spotify successful' : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
      // if(UserPreferences.spotifyToken.isEmpty){
      //   print("access token is empty");
      //   var result = await SpotifySdk.connectToSpotifyRemote(
      //       clientId: '00062cf894414e29b5158c040fbc96b5',
      //       redirectUrl: 'https://ansariacademy.com/RunWith/spotify.php');
      //   print("Remote ${result}");
      //   setStatus(result
      //       ? 'connect to spotify successful'
      //       : 'connect to spotify failed');
      //   setState(() {
      //     _loading = false;
      //   });
      //
      // }
      // else{
      //   print("access token is not empty");
      //  var result = await SpotifySdk.connectToSpotifyRemote(
      //     clientId: clientId,
      //     accessToken: UserPreferences.spotifyToken,
      //     //  redirectUrl: 'https://ansariacademy.com/Run-With-KT/spotify.php'
      //     redirectUrl: "https://ansariacademy.com/RunWith/spotify.php",
      //   );
      //
      //   print("Init Spotify else ${result.toString()}");
      // }
    } on PlatformException catch (e) {
      print("Exception is message ${e.message} code ${e.code} stacktrace ${e.details}");
      if (e.code == "CouldNotFindSpotifyApp") {
        print("CouldNotFindSpotifyApp");
        Fluttertoast.showToast(msg: "${e.code}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
      if (e.code == "NotLoggedInException") {
        print("NotLoggedInException");
        Fluttertoast.showToast(msg: "The user must go to the Spotify and log-in", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      }
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAccessToken() async {
    print("get access token pressed");
    // try {
      var authenticationToken = "";
      if (UserPreferences.spotifyToken.isEmpty) {
        print("authenticationToken => $authenticationToken");
        authenticationToken = await SpotifySdk.getAccessToken(
            clientId: clientId,
            redirectUrl: RedirectUrl,
            scope: 'app-remote-control, '
                'user-modify-playback-state, '
                'playlist-read-private, '
                'playlist-modify-public, '
                'user-read-currently-playing'
            );
        setStatus('Got a token: $authenticationToken');
        UserPreferences.spotifyToken = authenticationToken.toString();
        connectToSpotifyRemote();
      } else {
        connectToSpotifyRemote();
      }
      return authenticationToken;
    // } on PlatformException catch (e) {
    //   setStatus(e.code, message: e.message);
    //   return Future.error('$e.code: $e.message');
    // } on MissingPluginException {
    //   setStatus('not implemented');
    //   return Future.error('not implemented');
    // }
  }

  Future<void> queue() async {
    print("pressed queue");
    try {
      await SpotifySdk.queue(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      print("exceptiuon is ${e}");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m').then((value) {
        print("play value is ${value}");
      });
    } on PlatformException catch (e) {
      print("exceptiuon is ${e}");
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    print("Set Status is ${message}");
    var text = message ?? '';
    _logger.i('$code$text');
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;

        currentTrackImageUri = track?.imageUri;
        // print("track is ${track!.uri}");
        var playerState = snapshot.data;
        // print("playerState is ${playerState!.track!.uri}");

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  //  width: 50,
                  icon: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                  onPressed: skipPrevious,
                ),
                playerState.isPaused
                    ? IconButton(
                        // width: 50,
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: resume,
                      )
                    : IconButton(
                        //  width: 50,
                        icon: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: pause,
                      ),
                IconButton(
                  //  width: 50,
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: skipNext,
                ),
              ],
            ),
            Text(
              "Title ${track.name}",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Singer Name ${track.artist.name}",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),

            // Text('${track.name} by ${track.artist.name} from the album ${track.album.name}',style: TextStyle(color: Colors.white),),

            _connected
                ? spotifyImageWidget(track.imageUri)
                : const Text(
                    'Connect to see an image...',
                    style: TextStyle(color: Colors.white),
                  ),
          ],
        );
      },
    );
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: Image.memory(
              snapshot.data!,
              width: 100,
            ));
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      pause();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
        _connected = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }
}
