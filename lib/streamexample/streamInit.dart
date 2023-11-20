import 'dart:async';

class StreamInitilaization{
  final _streamController = StreamController<int>();
  StreamSink<int> get _streamSink => _streamController.sink;
  // sink accepts both synchronous and asynchronous we can add data
  Stream<int> get streamData => _streamController.stream; //  get the stream data

  StreamInitilaization() {
    addDatatoStream();
    print("Stream _streamSink ${_streamSink}");
    print("Stream streamData ${streamData}");

  }

  addDatatoStream(){
    _streamSink.add(0);// 0 means loading 1 means we get data and complete

  }

}