import 'package:flutter/material.dart';
import 'CounterController.dart';
//https://medium.com/@avnishnishad/flutter-understanding-the-stream-and-streambuilder-a2f8b69efa15
class CounterView extends StatefulWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late CounterController _counterController;

  @override
  void initState() {
    _counterController = CounterController();
    super.initState();
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter View"),
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              initialData: 0,
              stream: _counterController.counterStream,
              builder: (context,snapshot){

                if(snapshot.hasData){
                  return Text(
                    '${_counterController.counter}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }

                else{
                  return Text(
                    'Empty data',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }

              }),
          Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () =>
                    _counterController.eventSink.add(Event.decrement),
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () =>
                    _counterController.eventSink.add(Event.increment),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }
}
