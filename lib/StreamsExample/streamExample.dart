import 'dart:async';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:flutter/material.dart';

///https://medium.com/flutter-community/flutter-stream-basics-for-beginners-eda23e44e32f
/////https://www.kodeco.com/books/flutter-apprentice/v1.0.ea3/chapters/15-streams

enum Event { increment, decrement }

class CounterController {
  int counter = 0;
  // this will handle the change the change in value of counter
  final StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get counterSink => _counterController.sink;
  Stream<int> get counterStream => _counterController.stream;

  // we can directly use the counter sink from widget itself but to reduce the logic
  // from the UI files we are making use of one more controller that will listen to
  // button click events by user.

  final StreamController<Event> _eventController = StreamController<Event>();
  StreamSink<Event> get eventSink => _eventController.sink;
  Stream<Event> get eventStream => _eventController.stream;

  // NOTE: here we will use listener to listen the _eventController
  StreamSubscription? listener;
  CounterController() {
    listener = eventStream.listen((Event event) {
      switch (event) {
        case Event.increment:
          counter += 1;

          break;
        case Event.decrement:
          counter -= 1;
          break;
        default:
      }
      counterSink.add(counter);
    });
  }
  // dispose the listner to eliminate memory leak
  dispose() {
    listener?.cancel();
    _counterController.close();
    _eventController.close();
  }
}
class StreamExample extends StatefulWidget {
  const StreamExample({Key? key}) : super(key: key);

  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  //stream that allows multiple subscriptions.
  late CounterController _counterController;
  final bool _running = true;

  int _counter = 0;
  late StreamController<int> _events;
  @override
  void initState() {
    _counterController = CounterController();
    super.initState();
    _events = new StreamController<int>();
    _events.add(0);
  }

  void _incrementCounter() {
    _counter++;
    _events.add(_counter);

  }
  // Stream<String> _clock() async* {
  //   print("clock");
  //   // This loop will run forever because _running is always true
  //   while (_running) {
  //     await Future<void>.delayed(const Duration(seconds: 1));
  //     DateTime now = DateTime.now();
  //     // This will be displayed on the screen as current time
  //     yield "${now.hour} : ${now.minute} : ${now.second}";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Example"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              // stream: EasyGeofencing.getGeofenceStream(),
              // stream: _counterController.counterStream,
              stream: _events.stream,
              initialData: 0,
              builder: (context, AsyncSnapshot<int> snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return const CircularProgressIndicator();
                 }
                 return Text("${snapshot.data.toString()}",textAlign: TextAlign.center,
                   style: const TextStyle(fontSize: 50, color: Colors.blue),
                 );
              },
            ),
       ElevatedButton(onPressed: (){
         _incrementCounter();
       }, child: Text("increment"))

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     FloatingActionButton(
            //       onPressed: () =>
            //           _counterController.eventSink.add(Event.decrement),
            //       tooltip: 'Decrement',
            //       child: const Icon(Icons.remove),
            //     ),
            //     FloatingActionButton(
            //       onPressed: () =>
            //           _counterController.eventSink.add(Event.increment),
            //       tooltip: 'Increment',
            //       child: const Icon(Icons.add),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
