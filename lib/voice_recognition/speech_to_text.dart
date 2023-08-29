import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as sst;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
class SpeechToText extends StatefulWidget {
  const SpeechToText({Key? key}) : super(key: key);

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
 late sst.SpeechToText _speech;
 bool _isListening = false;
 String _text ='Press the button and start speaking'  ;
 double _confidence=1.0;
final Map<String,HighlightedWord>  _highlights={
  'flutter':HighlightedWord(
    onTap: (){
      print("flutter");
    }
    ,
    textStyle: TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold
    )

  )

};

void _listen() async{
  print("");
  //false
  if(!_isListening) {
    print("Listening");
    bool available = await  _speech.initialize(
      onStatus: (val) {
        if(val == "done"){
          print("stop the recording");
          setState(() {
            _isListening=false;
          });
          _speech.stop();
         


        }
      },
        onError: (val) => print("onError: $val")
    );

    if(available){
      setState(() {
        _isListening =true;
      });
      _speech.listen(
        onResult: (val) => setState(() {
          print("speech ois ${val.recognizedWords} ${val.alternates}");
          _text=val.recognizedWords;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("sos contains or not ${_text.toLowerCase().toString().contains("sos")} ");
            if(_text.toLowerCase().toString().contains("sos")){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return const AlertDialog(
                      title:  Text("hello worl"),
                    );
                  }
              );
            }
          });
          if(val.hasConfidenceRating && val.confidence > 0){
             _confidence=val.confidence;
          }
        })
      );

    }


  }
  else{
    print("Stop speach");
    setState(() {
      _isListening=false;
    });
    _speech.stop();
  }
}
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech=sst.SpeechToText();
  }
 @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        child: FloatingActionButton(
          onPressed: _listen ,
          child:  Icon(_isListening ? Icons.mic  :  Icons.mic_none),
        ),
      ),
      appBar: AppBar(
      title:const Text(
        "Speech to text"
      ) ,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Text("_isListening ${_isListening} "),
            Container(
              child: TextHighlight(
                text: _text, words: _highlights,
                textStyle: TextStyle(
                  fontSize: 32.0,
                  color: Colors.red,
                  fontWeight: FontWeight.w400
                ),

              ),
            ),
          ],
        )
      ),
    );
  }
}
