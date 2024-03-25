import 'dart:async';

import 'package:firebaseflutterproject/graphIntegration/graphProvider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// https://help.syncfusion.com/flutter/cartesian-charts/series-customization

class ChartData {
  ChartData(
      this.month,
      this.firstSale,
      this.secondSale,
      this.thirdSale
      );

  final String month;
  final double firstSale;
  final double secondSale;
  final double thirdSale;
}

class GraphTrackBaller extends StatefulWidget {
  const GraphTrackBaller({Key? key}) : super(key: key);

  @override
  State<GraphTrackBaller> createState() => _GraphTrackBallerState();
}

class _GraphTrackBallerState extends State<GraphTrackBaller> {
  late TrackballBehavior _trackballBehavior;
  final List<ChartData> data = <ChartData>[
    ChartData('1', 15, 39, 60),
    ChartData('2', 20, 30, 55),
    ChartData('3', 25, 28, 48),
    ChartData('4', 21, 35, 57),
    ChartData('5', 13, 39, 62),
    ChartData('6', 18, 41, 64),
    ChartData('7', 24, 45, 57),
    ChartData('8', 23, 48, 53),
    ChartData('9', 19, 54, 63),
    ChartData('10', 31, 55, 50),
    ChartData('11', 39, 57, 66),
    ChartData('12', 50, 60, 65),
    ChartData('13', 50, 60, 65),
    ChartData('14', 50, 65, 65),
    ChartData('15', 50, 40, 65),
    ChartData('16', 50, 60, 65),
    ChartData('17', 50, 40, 65),
    ChartData('18', 50, 50, 65),
    ChartData('19', 50, 80, 65),
    ChartData('20', 50, 70, 65),
    ChartData('21', 50, 60, 65),
    ChartData('22', 50, 90, 65),
    ChartData('19', 50, 100, 65),
    ChartData('23', 50, 60, 65),
    ChartData('24', 50, 60, 65),
    ChartData('25', 50, 80, 65),
    ChartData('25', 20, 20, 25),
  ];
  // late Timer timer;
  int dataValue=30;

  //  with image
  // @override
  // void initState() {
  //   _trackballBehavior = TrackballBehavior(
  //     lineColor:  Colors.green,
  //           lineWidth: 5.0,
  //           enable: true,
  //           markerSettings: TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible),
  //     builder: (BuildContext context, TrackballDetails trackballDetails) {
  //       return Container(
  //         height: 50,
  //         width: 150,
  //         decoration: BoxDecoration(
  //           color: Color.fromRGBO(0, 8, 22, 0.75),
  //           borderRadius: BorderRadius.all(Radius.circular(6.0)),
  //         ),
  //         child: Row(
  //           children: [
  //             Padding(
  //                 padding: EdgeInsets.only(left: 5),
  //                 child: SizedBox(
  //                   child: Image.asset('assets/bma_logo.jpg'),
  //                   height: 30,
  //                   width: 30,
  //                 )
  //             ),
  //             Center(
  //                 child: Container(
  //                     padding: EdgeInsets.only(top: 11, left: 7),
  //                     height: 40,
  //                     width: 100,
  //                     child: Text(
  //                         '${trackballDetails.point!.x.toString()} : \$${trackballDetails.point!.y.toString()}',
  //                         style: TextStyle(
  //                             fontSize: 13,
  //                             color: Color.fromRGBO(255, 255, 255, 1)
  //                         )
  //                     )
  //                 )
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   super.initState();
  // }


  @override
  void initState(){
    _trackballBehavior = TrackballBehavior(
         shouldAlwaysShow: true ,
      activationMode: ActivationMode.longPress, // you can shift to long press
      lineColor:  Colors.green,
        lineWidth: 3.0,
        enable: true,
        markerSettings: TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible),
         //tooltipDisplayMode: TrackballDisplayMode.nearestPoint
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

    // timer=Timer.periodic(Duration(seconds: 3), (timer) {
    //   dataValue++;
    //   data.add( ChartData(dataValue.toString(), 15 + 1, 95 + 1, 60 + 1),);
    //   if(mounted){
    //     setState(() {
    //     });
    //   }
    // }
    // );
    return
    Scaffold(
      appBar: AppBar(title: Text("graph"),),
      body:
  SafeArea(
    child:    Center(
      child: Container(
        // width: double.infinity,
        height: 300,
        child: SfCartesianChart(
            enableMultiSelection:true,
            enableAxisAnimation: true,
            enableSideBySideSeriesPlacement: true,
            // plotAreaBackgroundColor:Colors.orange,
            onCrosshairPositionChanging: (onCrossValue){
              // print("onCrossValue ${onCrossValue}");
            },
            onTrackballPositionChanging: (TrackballArgs args) {
              // print("args is  X ${args.chartPointInfo.markerXPos}  ");
              // print("screen width ios ${MediaQuery.of(context).size.width}");

              // xPos = args.chartPointInfo.markerXPos;
              // yPos = args.chartPointInfo.markerYPos;
              // customTrackballRepaintNotifier.value++;
            },
            zoomPanBehavior: ZoomPanBehavior(

                zoomMode: ZoomMode.x,
                enablePanning: true,
                enableDoubleTapZooming: true,
                enablePinching: true,
                // Enables the selection zooming
                enableSelectionZooming: false,

              // enableSelectionZooming: true,
              // By specifying enableSelectionZooming property to true, you can long press and drag to select a range on the chart to be zoomed in.
              // selectionRectBorderColor: Colors.red,
              // selectionRectBorderWidth: 1,
              // selectionRectColor: Colors.grey,
              // maximumZoomLevel: 0.02,
              // zoomMode: ZoomMode.x,
              // enablePinching: true,

              // Pinching can be performed by moving two fingers over the chart.
              // enablePanning: true,
              // enablePinching: true, // zoom in zoom out

              // enableDoubleTapZooming: true, // double tapping  zoom in
              // Double tap zooming can be enabled using enableDoubleTapZooming
              enableMouseWheelZooming: true
              // can be performed by rolling the mouse wheel up or down. The place where the cursor is hovering gets zoomed in or out according to the mouse wheel rolling up or down.
            ),
            onZooming: (zoomValue){

            },

            primaryXAxis: CategoryAxis(
              // autoScrollingDelta: 2 ,
              autoScrollingMode: AutoScrollingMode.start,


      interactiveTooltip: InteractiveTooltip(
      // Displays the x-axis tooltip
      enable: true,
      borderColor: Colors.red,
      borderWidth: 2
              // zoomFactor: 50.0,
              // zoomPosition: 1
            ),),
            // primaryXAxis: DateTimeAxis(),
            trackballBehavior: _trackballBehavior,
            series: <LineSeries<ChartData, String>>[
              // LineSeries<ChartData, String>(
              //   dataSource: data,
              //   markerSettings: MarkerSettings(isVisible: true),
              //   name: 'United States of America',
              //   xValueMapper: (ChartData sales, _) => sales.month,
              //
              //   yValueMapper: (ChartData sales, _) => sales.firstSale,
              // ),

              // LineSeries<ChartData, String>(
              //   dataSource: data,
              //   markerSettings: MarkerSettings(isVisible: true),
              //   name: 'Germany',
              //   xValueMapper: (ChartData sales, _) => sales.month,
              //   yValueMapper: (ChartData sales, _) => sales.secondSale,
              // ),
              LineSeries<ChartData, String>(
                color: Colors.purple,
                dataSource: data,
                markerSettings: MarkerSettings(isVisible: true),
                name: 'United Kingdom',
                // month
                xValueMapper: (ChartData sales, _) => sales.firstSale.toString(),
                yValueMapper: (ChartData sales, _) => sales.thirdSale,

              ),

            ]
        ),
      ),
    ),
  ),
    );
  }
}
