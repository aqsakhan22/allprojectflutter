// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:logger/logger.dart';
// import 'package:runwith/screens/SpotifyExample/Debugging.dart';
// import 'package:spotify_sdk/models/connection_status.dart';
// import 'package:spotify_sdk/models/crossfade_state.dart';
// import 'package:spotify_sdk/models/image_uri.dart';
// import 'package:spotify_sdk/models/player_context.dart';
// import 'package:spotify_sdk/models/player_state.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';
//
// import 'widgets/sized_icon_button.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:runwith/providers/all_programs_provider.dart';
// import 'package:runwith/providers/audioqueues_provider.dart';
// import 'package:runwith/providers/auth_provider.dart';
// import 'package:runwith/providers/chat_provider.dart';
// import 'package:runwith/providers/clubs_provider.dart';
// import 'package:runwith/providers/notification_provider.dart';
// import 'package:runwith/providers/quotes_provider.dart';
// import 'package:runwith/providers/run_provider.dart';
// import 'package:runwith/providers/running_buddies.dart';
// import 'package:runwith/providers/running_program_provider.dart';
// import 'package:runwith/providers/socila_feeds_provider.dart';
// import 'package:runwith/screens/Clubs/all_clubs.dart';
// import 'package:runwith/screens/events.dart';
// import 'package:runwith/screens/RunningBuddies/running_buddies.dart';
// import 'package:runwith/screens/add_gear.dart';
// import 'package:runwith/screens/chats/chats.dart';
// import 'package:runwith/screens/chats/personal_chats.dart';
// import 'package:runwith/screens/edit_gear.dart';
// import 'package:runwith/screens/feedback.dart';
// import 'package:runwith/screens/forum/community.dart';
// import 'package:runwith/screens/gear_list.dart';
// import 'package:runwith/screens/home.dart';
// import 'package:runwith/screens/my_profile.dart';
// import 'package:runwith/screens/notifications.dart';
// import 'package:runwith/screens/privacy_policy.dart';
// import 'package:runwith/screens/run_history.dart';
// import 'package:runwith/screens/runing_gear.dart';
// import 'package:runwith/screens/running_program.dart';
// import 'package:runwith/screens/search.dart';
// import 'package:runwith/screens/search_all.dart';
// import 'package:runwith/screens/signin.dart';
// import 'package:runwith/screens/signup.dart';
// import 'package:runwith/screens/socialfeed/social_feeds.dart';
// import 'package:runwith/screens/start_run.dart';
// import 'package:runwith/screens/thankyou.dart';
// import 'package:runwith/screens/welcome.dart';
// import 'package:runwith/services/background.dart';
// import 'package:runwith/utility/shared_preference.dart';
// import 'package:runwith/utility/top_level_variables.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// import 'screens/RunningBuddies/find_running_buddies.dart';
//
//
//
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await askPermission();
//   await initializePreferences();
//   // await initializeService();
//   await dotenv.load(fileName: '.env');
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.custom
//     ..maskType = EasyLoadingMaskType.custom
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.white
//     ..backgroundColor = Colors.black
//     ..indicatorColor = Colors.white
//     ..textColor = Colors.white
//     ..maskColor = Colors.white.withOpacity(0.5)
//     ..userInteractions = true
//     ..dismissOnTap = false;
//   runApp(const Home());
// }
// askPermission() async{
//   print("Ask permission");
//
//
//   Permission.location.status.isDenied.then((value) async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.notification,
//       Permission.location,
//       Permission.contacts,
//       Permission.sms,
//       Permission.phone,
//       Permission.microphone,
//       Permission.camera,
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.mediaLibrary,
//       Permission.audio ,
//       Permission.locationAlways
//
//     ].request();
//     print(statuses[Permission.notification]);
//     print(statuses[Permission.location]);
//     print(statuses[Permission.camera]);
//     print(statuses[Permission.bluetooth]);
//     print(statuses[Permission.audio]);
//     //Navigator.pop(context);
//   });
//   // if (await Permission.camera.isPermanentlyDenied || await Permission.camera.isDenied ) {
//   //
//   //   print("Denied settings");
//   //
//   //   // The user opted to never again see the permission request dialog for this
//   //   // app. The only way to change the permission's status now is to let the
//   //   // user manually enable it in the system settings.
//   //   AppSettings.openAppSettings();
//   // }
// }
//
// /// A [StatefulWidget] which uses:
// /// * [spotify_sdk](https://pub.dev/packages/spotify_sdk)
// /// to connect to Spotify and use controls.
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   bool _loading = false;
//   bool _connected = false;
//   final Logger _logger = Logger(
//     //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
//     printer: PrettyPrinter(
//       methodCount: 2, // number of method calls to be displayed
//       errorMethodCount: 8, // number of method calls if stacktrace is provided
//       lineLength: 120, // width of the output
//       colors: true, // Colorful log messages
//       printEmojis: true, // Print an emoji for each log message
//       printTime: true,
//     ),
//   );
//
//   CrossfadeState? crossfadeState;
//   late ImageUri? currentTrackImageUri;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home:
//       StreamBuilder<ConnectionStatus>(
//         stream: SpotifySdk.subscribeConnectionStatus(),
//         builder: (context, snapshot) {
//           _connected = false;
//           var data = snapshot.data;
//           if (data != null) {
//             _connected = data.connected;
//           }
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('SpotifySdk Example'),
//               actions: [
//                 _connected
//                     ? IconButton(
//                   onPressed: disconnect,
//                   icon: const Icon(Icons.exit_to_app),
//                 )
//                     : Container()
//               ],
//             ),
//             body: _sampleFlowWidget(context),
//             bottomNavigationBar: _connected ? _buildBottomBar(context) : null,
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBottomBar(BuildContext context) {
//     return BottomAppBar(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               SizedIconButton(
//                 width: 50,
//                 icon: Icons.queue_music,
//                 onPressed: queue,
//               ),
//               SizedIconButton(
//                 width: 50,
//                 icon: Icons.playlist_play,
//                 onPressed: play,
//               ),
//               SizedIconButton(
//                 width: 50,
//                 icon: Icons.repeat,
//                 onPressed: toggleRepeat,
//               ),
//               SizedIconButton(
//                 width: 50,
//                 icon: Icons.shuffle,
//                 onPressed: toggleShuffle,
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               SizedIconButton(
//                 width: 50,
//                 onPressed: addToLibrary,
//                 icon: Icons.favorite,
//               ),
//               SizedIconButton(
//                 width: 50,
//                 onPressed: () => checkIfAppIsActive(context),
//                 icon: Icons.info,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _sampleFlowWidget(BuildContext context2) {
//     return Stack(
//       children: [
//
//
//         ListView(
//           padding: const EdgeInsets.all(8),
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 TextButton(
//                   onPressed: connectToSpotifyRemote,
//                   child: const Icon(Icons.settings_remote),
//                 ),
//                 TextButton(
//                   onPressed: getAccessToken,
//                   child: const Text('get auth token '),
//                 ),
//               ],
//             ),
//             const Divider(),
//             const Text(
//               'Player State',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             _connected
//                 ? _buildPlayerStateWidget()
//                 : const Center(
//               child: Text('Not connected'),
//             ),
//             const Divider(),
//             const Text(
//               'Player Context',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             _connected
//                 ? _buildPlayerContextWidget()
//                 : const Center(
//               child: Text('Not connected'),
//             ),
//             const Divider(),
//             const Text(
//               'Player Api',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 TextButton(
//                   onPressed: seekTo,
//                   child: const Text('seek to 20000ms'),
//                 ),
//                 TextButton(
//                   onPressed: seekToRelative,
//                   child: const Text('seek to relative 20000ms'),
//                 ),
//               ],
//             ),
//             const Divider(),
//             const Text(
//               'Crossfade State',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: getCrossfadeState,
//               child: const Text(
//                 'get crossfade state',
//               ),
//             ),
//             // ignore: prefer_single_quotes
//             Text("Is enabled: ${crossfadeState?.isEnabled}"),
//             // ignore: prefer_single_quotes
//             Text("Duration: ${crossfadeState?.duration}"),
//           ],
//         ),
//         Container(
//           margin: EdgeInsets.all(100),
//           height:200,
//           color:Colors.red,
//           child: ElevatedButton(onPressed: (){
//             Navigator.push(context2, MaterialPageRoute(builder: (context) => SpotifyExample()));
//           }, child: Text("debugging")),
//         ),
//         _loading
//             ? Container(
//             color: Colors.black12,
//             child: const Center(child: CircularProgressIndicator()))
//             : const SizedBox(),
//       ],
//     );
//   }
//
//   Widget _buildPlayerStateWidget() {
//     return StreamBuilder<PlayerState>(
//       stream: SpotifySdk.subscribePlayerState(),
//       builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
//         var track = snapshot.data?.track;
//         currentTrackImageUri = track?.imageUri;
//         var playerState = snapshot.data;
//
//         if (playerState == null || track == null) {
//           return Center(
//             child: Container(),
//           );
//         }
//
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 SizedIconButton(
//                   width: 50,
//                   icon: Icons.skip_previous,
//                   onPressed: skipPrevious,
//                 ),
//                 playerState.isPaused
//                     ? SizedIconButton(
//                   width: 50,
//                   icon: Icons.play_arrow,
//                   onPressed: resume,
//                 )
//                     : SizedIconButton(
//                   width: 50,
//                   icon: Icons.pause,
//                   onPressed: pause,
//                 ),
//                 SizedIconButton(
//                   width: 50,
//                   icon: Icons.skip_next,
//                   onPressed: skipNext,
//                 ),
//               ],
//             ),
//             Text(
//                 '${track.name} by ${track.artist.name} from the album ${track.album.name}'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Playback speed: ${playerState.playbackSpeed}'),
//                 Text(
//                     'Progress: ${playerState.playbackPosition}ms/${track.duration}ms'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Paused: ${playerState.isPaused}'),
//                 Text('Shuffling: ${playerState.playbackOptions.isShuffling}'),
//               ],
//             ),
//             Text('RepeatMode: ${playerState.playbackOptions.repeatMode}'),
//             Text('Image URI: ${track.imageUri.raw}'),
//             Text('Is episode? ${track.isEpisode}'),
//             Text('Is podcast? ${track.isPodcast}'),
//             _connected
//                 ? spotifyImageWidget(track.imageUri)
//                 : const Text('Connect to see an image...'),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(),
//                 const Text(
//                   'Set Shuffle and Repeat',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Row(
//                   children: [
//                     const Text(
//                       'Repeat Mode:',
//                     ),
//                     DropdownButton<RepeatMode>(
//                       value: RepeatMode
//                           .values[playerState.playbackOptions.repeatMode.index],
//                       items: const [
//                         DropdownMenuItem(
//                           value: RepeatMode.off,
//                           child: Text('off'),
//                         ),
//                         DropdownMenuItem(
//                           value: RepeatMode.track,
//                           child: Text('track'),
//                         ),
//                         DropdownMenuItem(
//                           value: RepeatMode.context,
//                           child: Text('context'),
//                         ),
//                       ],
//                       onChanged: (repeatMode) => setRepeatMode(repeatMode!),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Text('Set shuffle: '),
//                     Switch.adaptive(
//                       value: playerState.playbackOptions.isShuffling,
//                       onChanged: (bool shuffle) => setShuffle(
//                         shuffle,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildPlayerContextWidget() {
//     return StreamBuilder<PlayerContext>(
//       stream: SpotifySdk.subscribePlayerContext(),
//       initialData: PlayerContext('', '', '', ''),
//       builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
//         var playerContext = snapshot.data;
//         if (playerContext == null) {
//           return const Center(
//             child: Text('Not connected'),
//           );
//         }
//
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Title: ${playerContext.title}'),
//             Text('Subtitle: ${playerContext.subtitle}'),
//             Text('Type: ${playerContext.type}'),
//             Text('Uri: ${playerContext.uri}'),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget spotifyImageWidget(ImageUri image) {
//     return FutureBuilder(
//         future: SpotifySdk.getImage(
//           imageUri: image,
//           dimension: ImageDimension.large,
//         ),
//         builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
//           if (snapshot.hasData) {
//             return Image.memory(snapshot.data!);
//           } else if (snapshot.hasError) {
//             setStatus(snapshot.error.toString());
//             return SizedBox(
//               width: ImageDimension.large.value.toDouble(),
//               height: ImageDimension.large.value.toDouble(),
//               child: const Center(child: Text('Error getting image')),
//             );
//           } else {
//             return SizedBox(
//               width: ImageDimension.large.value.toDouble(),
//               height: ImageDimension.large.value.toDouble(),
//               child: const Center(child: Text('Getting image...')),
//             );
//           }
//         });
//   }
//
//   Future<void> disconnect() async {
//     try {
//       setState(() {
//         _loading = true;
//       });
//       var result = await SpotifySdk.disconnect();
//       setStatus(result ? 'disconnect successful' : 'disconnect failed');
//       setState(() {
//         _loading = false;
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         _loading = false;
//       });
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setState(() {
//         _loading = false;
//       });
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> connectToSpotifyRemote() async {
//     try {
//       setState(() {
//         _loading = true;
//       });
//       var result = await SpotifySdk.connectToSpotifyRemote(
//           clientId: dotenv.env['CLIENT_ID'].toString(),
//           redirectUrl: dotenv.env['REDIRECT_URL'].toString());
//       setStatus(result
//           ? 'connect to spotify successful'
//           : 'connect to spotify failed');
//       setState(() {
//         _loading = false;
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         _loading = false;
//       });
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setState(() {
//         _loading = false;
//       });
//       setStatus('not implemented');
//     }
//   }
//
//   Future<String> getAccessToken() async {
//     try {
//       var authenticationToken = await SpotifySdk.getAccessToken(
//           clientId: dotenv.env['CLIENT_ID'].toString(),
//           redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
//           scope: 'app-remote-control, '
//               'user-modify-playback-state, '
//               'playlist-read-private, '
//               'playlist-modify-public,user-read-currently-playing');
//       setStatus('Got a token: $authenticationToken');
//       return authenticationToken;
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//       return Future.error('$e.code: $e.message');
//     } on MissingPluginException {
//       setStatus('not implemented');
//       return Future.error('not implemented');
//     }
//   }
//
//   Future getPlayerState() async {
//     try {
//       return await SpotifySdk.getPlayerState();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future getCrossfadeState() async {
//     try {
//       var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
//       setState(() {
//         crossfadeState = crossfadeStateValue;
//       });
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> queue() async {
//     try {
//       await SpotifySdk.queue(
//           spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> toggleRepeat() async {
//     try {
//       await SpotifySdk.toggleRepeat();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> setRepeatMode(RepeatMode repeatMode) async {
//     try {
//       await SpotifySdk.setRepeatMode(
//         repeatMode: repeatMode,
//       );
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> setShuffle(bool shuffle) async {
//     try {
//       await SpotifySdk.setShuffle(
//         shuffle: shuffle,
//       );
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> toggleShuffle() async {
//     try {
//       await SpotifySdk.toggleShuffle();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> play() async {
//     try {
//       await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> pause() async {
//     try {
//       await SpotifySdk.pause();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> resume() async {
//     try {
//       await SpotifySdk.resume();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> skipNext() async {
//     try {
//       await SpotifySdk.skipNext();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> skipPrevious() async {
//     try {
//       await SpotifySdk.skipPrevious();
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> seekTo() async {
//     try {
//       await SpotifySdk.seekTo(positionedMilliseconds: 20000);
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> seekToRelative() async {
//     try {
//       await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> addToLibrary() async {
//     try {
//       await SpotifySdk.addToLibrary(
//           spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   Future<void> checkIfAppIsActive(BuildContext context) async {
//     try {
//       var isActive = await SpotifySdk.isSpotifyAppActive;
//       final snackBar = SnackBar(
//           content: Text(isActive
//               ? 'Spotify app connection is active (currently playing)'
//               : 'Spotify app connection is not active (currently not playing)'));
//
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     } on PlatformException catch (e) {
//       setStatus(e.code, message: e.message);
//     } on MissingPluginException {
//       setStatus('not implemented');
//     }
//   }
//
//   void setStatus(String code, {String? message}) {
//     var text = message ?? '';
//     _logger.i('$code$text');
//   }
// }
