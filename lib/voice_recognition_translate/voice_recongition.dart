import 'dart:convert';

import 'package:firebaseflutterproject/MVVM/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/services.dart';

class VoiceRecognition extends StatefulWidget {
  const VoiceRecognition({Key? key}) : super(key: key);

  @override
  State<VoiceRecognition> createState() => _VoiceRecognitionState();
}

class _VoiceRecognitionState extends State<VoiceRecognition> {
  String name="aqsa";
  _VoiceRecognitionState() {
    /// Init Alan Button with project key from Alan AI Studio
    AlanVoice.addButton("51ba2dbb4ed0c9ab13c9ef7b8e6e229f2e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT
    );
    /// Add button state handler
    AlanVoice.onButtonState.add((state) {
      debugPrint("got new button state ${state.name}");
    });

    /// Add command handler
    // AlanVoice.onCommand.add((command) {
    //   print("got new command ${command.toString()}");
    //   debugPrint("got new command ${command.toString()}");
    // });

    /// Add event handler
    AlanVoice.onEvent.add((event) {
      debugPrint("got new event ${event.data['text']}");


    });

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) {
      print("alan voice aonmand is ${command}");
      handleCommand(command.data);
    });


  }

  handleCommand(Map<String,dynamic> command) {
    print("command is $command");
  switch(command['command']){
    case "change the name":
      setState(() {
        name="hey I am aqsa";
      });
      break;
      case "forward":
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen() ));
      break;
    default:
      debugPrint("Unknoe command");
  }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(title: const Text("Voice Recognotion"),),
      body: Center(
        child: Text("Ny nam is $name"),
      ),

    );
  }
}
