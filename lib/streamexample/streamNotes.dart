import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/api_services/api.dart';
import 'dart:async';

class StreamNotes {

  final _streamController = StreamController<String>();
  StreamSink<String> get _streamSink => _streamController.sink;
  // sink accepts both synchronous and asynchronous we can add data
  Stream<String> get streamData => _streamController.stream; //  get the stream data


  StreamNotes(){
    fetchNotes();
  }
  // List<Notes> notes=[];
  void fetchNotes() async {

    await ApiServices.fetchNotes("aqsakhan").then((value){


      print("Notes value is ${value}");
      value.forEach((element) {
        print("for each notes is ${element.title}");
        _streamSink.add(element!.title!);
      });

    });


    print("avaialble notes is ${_streamSink}");
  }
}