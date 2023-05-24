import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
class BackgroundServiceScreen extends StatefulWidget {
  const BackgroundServiceScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundServiceScreen> createState() => _BackgroundServiceScreenState();
}

class _BackgroundServiceScreenState extends State<BackgroundServiceScreen> {
  String text= "start service";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Baclground service "),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
              FlutterBackgroundService().invoke('setAsForeground');
          }, child: Text("Foreground service")),
          ElevatedButton(onPressed: (){
            FlutterBackgroundService().invoke('setAsBackground');
          }, child: Text("Background service")),
          ElevatedButton(onPressed: (){
            FlutterBackgroundService().invoke('BGServices');
          }, child: Text("start BG")),
          ElevatedButton(onPressed: () async{
            final service=FlutterBackgroundService();
            bool isRunning=await service.isRunning();
           if(isRunning){
             service.invoke('stopService');
           }

           else{
             service.startService();

           }

           if(!isRunning){
            setState(() {
              text="Stop Service";
            });
           }
           else{
             setState(() {
               text="Start Service";
             });
           }


          }, child: Text("${text}")),

          StreamBuilder(
            stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot){
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                String? current_date = data["current_date"];
                return Text("${current_date}");

              }

          )

        ],
      ),
    );
  }
}
