import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:runwith/utility/top_level_variables.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/sized_icon_button.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
class SpotifyIOS extends StatefulWidget {
  const SpotifyIOS({Key? key}) : super(key: key);

  @override
  State<SpotifyIOS> createState() => _SpotifyIOSState();
}

class _SpotifyIOSState extends State<SpotifyIOS> {
  bool _loading = false;
  bool _connected = false;
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true,
    ),
  );

  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBarWidget.textAppBar(
        "CASUAL RUN",
      ),
      body: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('SpotifySdk Example'),
              actions: [
                _connected
                    ? IconButton(
                  onPressed: disconnect,
                  icon: const Icon(Icons.exit_to_app,color: Colors.white,),
                )
                    : Container()
              ],
            ),
            body: _sampleFlowWidget(context),
            bottomNavigationBar: _connected ? _buildBottomBar(context) : null,
          );
        },
      ),

    );
  }
  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedIconButton(
                width: 50,
                icon: Icons.queue_music,
                onPressed: queue,
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.playlist_play,
                onPressed: play,
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.repeat,
                onPressed: toggleRepeat,
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.shuffle,
                onPressed: toggleShuffle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedIconButton(
                width: 50,
                onPressed: addToLibrary,
                icon: Icons.favorite,
              ),
              SizedIconButton(
                width: 50,
                onPressed: () => checkIfAppIsActive(context),
                icon: Icons.info,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: connectToSpotifyRemote,
                  child: const Icon(Icons.settings_remote),
                ),
                TextButton(
                  onPressed: getAccessToken,
                  child: const Text('get auth token '),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Player State',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            _connected
                ? _buildPlayerStateWidget()
                : const Center(
              child: Text('Not connected',style: TextStyle(  color: Colors.white),),
            ),
            const Divider(),
            const Text(
              'Player Context',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            _connected
                ? _buildPlayerContextWidget()
                : const Center(
              child: Text('Not connected',style: TextStyle(  color: Colors.white),),
            ),
            const Divider(),
            const Text(
              'Player Api',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: seekTo,
                  child: const Text('seek to 20000ms',style: TextStyle(  color: Colors.white),),
                ),
                TextButton(
                  onPressed: seekToRelative,
                  child: const Text('seek to relative 20000ms',style: TextStyle(  color: Colors.white),),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Crossfade State',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            ElevatedButton(
              onPressed: getCrossfadeState,
              child: const Text(
                'get crossfade state',
                style: TextStyle(  color: Colors.white),
              ),
            ),
            // ignore: prefer_single_quotes
            Text("Is enabled: ${crossfadeState?.isEnabled}",style: TextStyle(  color: Colors.white),),
            // ignore: prefer_single_quotes
            Text("Duration: ${crossfadeState?.duration}"),
          ],
        ),
        _loading
            ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
            : const SizedBox(),
      ],
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

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
                SizedIconButton(
                  width: 50,
                  icon: Icons.skip_previous,
                  onPressed: skipPrevious,
                ),
                playerState.isPaused
                    ? SizedIconButton(
                  width: 50,
                  icon: Icons.play_arrow,
                  onPressed: resume,
                )
                    : SizedIconButton(
                  width: 50,
                  icon: Icons.pause,
                  onPressed: pause,
                ),
                SizedIconButton(
                  width: 50,
                  icon: Icons.skip_next,
                  onPressed: skipNext,
                ),
              ],
            ),
            Text(
                '${track.name} by ${track.artist.name} from the album ${track.album.name}',style: TextStyle(  color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Playback speed: ${playerState.playbackSpeed}',style: TextStyle(  color: Colors.white),),
                Text(
                    'Progress: ${playerState.playbackPosition}ms/${track.duration}ms',style: TextStyle(  color: Colors.white),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paused: ${playerState.isPaused}',style: TextStyle(  color: Colors.white),),
                Text('Shuffling: ${playerState.playbackOptions.isShuffling}',style: TextStyle(  color: Colors.white),),
              ],
            ),
            Text('RepeatMode: ${playerState.playbackOptions.repeatMode}',style: TextStyle(  color: Colors.white),),
            Text('Image URI: ${track.imageUri.raw}',style: TextStyle(  color: Colors.white)),
            Text('Is episode? ${track.isEpisode}',style: TextStyle(  color: Colors.white)),
            Text('Is podcast? ${track.isPodcast}',style: TextStyle(  color: Colors.white)),
            _connected
                ? spotifyImageWidget(track.imageUri)
                : const Text('Connect to see an image...',style: TextStyle(  color: Colors.white)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text(
                  'Set Shuffle and Repeat',
                  style: TextStyle(fontSize: 16,color: Colors.white),

                ),
                Row(
                  children: [
                    const Text(
                      'Repeat Mode:',
                        style: TextStyle(  color: Colors.white)
                    ),
                    DropdownButton<RepeatMode>(
                      value: RepeatMode
                          .values[playerState.playbackOptions.repeatMode.index],
                      items: const [
                        DropdownMenuItem(
                          value: RepeatMode.off,
                          child: Text('off',style: TextStyle(  color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: RepeatMode.track,
                          child: Text('track',style: TextStyle(  color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: RepeatMode.context,
                          child: Text('context',style: TextStyle(  color: Colors.white)),
                        ),
                      ],
                      onChanged: (repeatMode) => setRepeatMode(repeatMode!),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Set shuffle: ',style: TextStyle(  color: Colors.white)),
                    Switch.adaptive(
                      value: playerState.playbackOptions.isShuffling,
                      onChanged: (bool shuffle) => setShuffle(
                        shuffle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        var playerContext = snapshot.data;
        if (playerContext == null) {
          return const Center(
            child: Text('Not connected',style: TextStyle(  color: Colors.white)),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${playerContext.title}',style: TextStyle(  color: Colors.white)),
            Text('Subtitle: ${playerContext.subtitle}',style: TextStyle(  color: Colors.white)),
            Text('Type: ${playerContext.type}',style: TextStyle(  color: Colors.white)),
            Text('Uri: ${playerContext.uri}',style: TextStyle(  color: Colors.white)),
          ],
        );
      },
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
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
              child: const Center(child: Text('Getting image...',style: TextStyle(  color: Colors.white))),
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
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
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

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: TopVariables.clientID,
          redirectUrl: TopVariables.RedirectURi
      );
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
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

  Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: TopVariables.clientID,
          redirectUrl: TopVariables.RedirectURi,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
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

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
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

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
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

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      var isActive = await SpotifySdk.isSpotifyAppActive;
      final snackBar = SnackBar(
          content: Text(isActive
              ? 'Spotify app connection is active (currently playing)'
              : 'Spotify app connection is not active (currently not playing)'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
