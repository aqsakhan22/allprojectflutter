import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:number_to_words/number_to_words.dart';

import '../utility/shared_preference.dart';

class AudioQueues{

  static playAudiosDistanceCues() async{
    switch(UserPreferences.distanceCueKMMarker)
    {
      case 1:
        playAudio('assets/audios/distanceCues/oneK.MP3');
        break;
      case 2:
        playAudio('assets/audios/distanceCues/twoK.MP3');
        break;
      case 3:
        playAudio('assets/audios/distanceCues/threeK.MP3');
        break;
      case 4:
        playAudio('assets/audios/distanceCues/fourK.MP3');
        break;
      case 5:
        playAudio('assets/audios/distanceCues/fiveK.MP3');
        break;
      case 6:
        playAudio('assets/audios/distanceCues/sixK.MP3');
        break;
      case 7:
        playAudio('assets/audios/distanceCues/sevenK.MP3');
        break;
      case 8:
        playAudio('assets/audios/distanceCues/eightK.MP3');
        break;
      case 9:
        playAudio('assets/audios/distanceCues/nineK.MP3');
        break;
      case 10:
        playAudio('assets/audios/distanceCues/tenK.MP3');
        break;
      case 11:
        playAudio('assets/audios/distanceCues/elevenK.MP3');
        break;
      case 12:
        playAudio('assets/audios/distanceCues/twelveK.MP3');
        break;
      case 13:
        playAudio('assets/audios/distanceCues/thirteenK.MP3');
        break;
      case 14:
        playAudio('assets/audios/distanceCues/fourteenK.MP3');
        break;
      case 15:
        playAudio('assets/audios/distanceCues/fifteenK.MP3');
        break;
      case 16:
        playAudio('assets/audios/distanceCues/sixteenK.MP3');
        break;
      case 17:
        playAudio('assets/audios/distanceCues/seventeenK.MP3');
        break;
      case 18:
        playAudio('assets/audios/distanceCues/eighteenK.MP3');
        break;
      case 19:
        playAudio('assets/audios/distanceCues/nineteenK.MP3');
        break;
      case 20:
        playAudio('assets/audios/distanceCues/twentyK.MP3');
        break;
      case 21:
        playAudio('assets/audios/distanceCues/twentyOneK.MP3');
        break;
      case 22:
        playAudio('assets/audios/distanceCues/twentyTwoK.MP3');
        break;
      case 23:
        playAudio('assets/audios/distanceCues/twentyThreeK.MP3');
        break;
      case 24:
        playAudio('assets/audios/distanceCues/twentyFourK.MP3');
        break;
      case 25:
        playAudio('assets/audios/distanceCues/twentyFiveK.MP3');
        break;
      case 26:
        playAudio('assets/audios/distanceCues/twentySixK.MP3');
        break;
      case 27:
        playAudio('assets/audios/distanceCues/twentySeven.MP3');
        break;
      case 28:
        playAudio('assets/audios/distanceCues/twentyEightK.MP3');
        break;
      case 29:
        playAudio('assets/audios/distanceCues/twentyNineK.MP3');
        break;
      case 30:
        playAudio('assets/audios/distanceCues/thirtyK.MP3');
        break;
      case 31:
        playAudio('assets/audios/distanceCues/thirtyOneK.MP3');
        break;
      case 32:
        playAudio('assets/audios/distanceCues/thirtyTwoK.MP3');
        break;
      case 33:
        playAudio('assets/audios/distanceCues/thirtyThreeK.MP3');
        break;
      case 34:
        playAudio('assets/audios/distanceCues/thirtyFourK.MP3');
        break;
      case 35:
        playAudio('assets/audios/distanceCues/thirtyFiveK.MP3');
        break;
      case 36:
        playAudio('assets/audios/distanceCues/thirtySixK.MP3');
        break;
      case 37:
        playAudio('assets/audios/distanceCues/thirtySevenK.MP3');
        break;
      case 38:
        playAudio('assets/audios/distanceCues/thirtyEightK.MP3');
        break;
      case 39:
        playAudio('assets/audios/distanceCues/thirtyNineK.MP3');
        break;
      case 40:
        playAudio('assets/audios/distanceCues/fourtyK.MP3');
        break;
      case 41:
        playAudio('assets/audios/distanceCues/fourtyOneK.MP3');
        break;
      case 42:
        playAudio('assets/audios/distanceCues/fourtyTwoK.MP3');
        break;
    }
    UserPreferences.distanceCueKMMarker = UserPreferences.distanceCueKMMarker + 1;
  }

  static playAudiosMotivational() async{
    String fileName = (NumberToWord().convert('en-in',Random().nextInt(20)));
    fileName = fileName.substring(0, fileName.length-1);
    print('audio file to play:$fileName.MP3');
    playAudio('assets/audios/motivational/$fileName.MP3');
  }

  static playAudiosIntro() async{
    String fileName = (NumberToWord().convert('en-in',Random().nextInt(17)));
    fileName = fileName.substring(0, fileName.length-1);
    print('audio file to play:$fileName.MP3');
    playAudio('assets/audios/intros/$fileName.MP3');
  }

  static playAudio(String path) async {
    print("Background Audio Queues Playing => $path");
    await AudioPlayer.clearAssetCache();
    AudioPlayer player = AudioPlayer();
    await player.setAsset(path);
    await player.play();
    await player.setVolume(1);
    await player.dispose();
  }

}