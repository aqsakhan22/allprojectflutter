import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:firebaseflutterproject/streamexample/streamInit.dart';
import 'package:firebaseflutterproject/streamexample/streamNotes.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
class StreamExample extends StatefulWidget {
  const StreamExample({Key? key}) : super(key: key);
  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  final streamInit = StreamInitilaization();
  final Streamnotes = StreamNotes();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Stream Example"),),
      body: StreamBuilder<String>(

        stream: Streamnotes.streamData,
        builder: (context,snapshot) {
          print("stream data is ${snapshot.data}");
        if(snapshot.hasData){
return Text("${snapshot.data}");

        }
        else{
          return Text("No Data"
              "");

        }
},
// other arguments
      ),
    );
  }
}

