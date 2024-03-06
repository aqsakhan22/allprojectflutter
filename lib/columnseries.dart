import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';




class SyncScroll extends StatefulWidget {
  @override
  State<SyncScroll> createState() => _SyncScrollState();
}

class _SyncScrollState extends State<SyncScroll> {
  ChartSeriesController? _chartSeriesController1;
  // late ScrollController _scrollController;
  final List<ChartData> chartData = [
    // ChartData(2010, 10, Colors.red),
    // ChartData(2011, 15,Colors.orange),
    // ChartData(2012, 20,Colors.green),
    // ChartData(2013, 34,Colors.grey),
    // ChartData(2014, 44,Colors.pink),
    // ChartData(2015, 54,Colors.yellow),
    // ChartData(2016, 34,Colors.amber),
    // ChartData(2017, 24,Colors.black),
    // ChartData(2018, 14,Colors.blue),
    // ChartData(2019, 34,Colors.orange),
    // ChartData(2020, 34,Colors.redAccent),
    // ChartData(2021, 14,Colors.redAccent),
    // ChartData(2022, 4,Colors.orange),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) =>
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Graphs"),),
  //       body: Container(
  //         margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
  //         child: SingleChildScrollView(
  //           reverse: true,
  //           // controller: _scrollController,
  //           scrollDirection: Axis.horizontal,
  //             child: Column(
  //               children: [
  //                 Container(
  //                   width:500,
  //                     height: 400,
  //                     child: SfCartesianChart(
  //                        // enableAxisAnimation: true,
  //                       //  primaryXAxis: CategoryAxis(),
  //                         primaryXAxis: CategoryAxis(
  //                             title: AxisTitle(text: 'Primary X Axis'),
  //                         ),
  //                         primaryYAxis: CategoryAxis(
  //                             title: AxisTitle(
  //                                 text: 'Primary Y Axis',
  //
  //                             ),
  //                           opposedPosition: true,
  //                         ),
  //                         series: <CartesianSeries>[
  //                           // Renders line chart
  //                           LineSeries<ChartData, int>(
  //                               markerSettings: MarkerSettings(isVisible: true),
  //                               onRendererCreated: (ChartSeriesController controller) {
  //                                 _chartSeriesController1 = controller;
  //                               },
  //                               dataSource: chartData,
  //                               xValueMapper: (ChartData data, _) => data.x,
  //                               yValueMapper: (ChartData data, _) => data.y,
  //                             // pointColorMapper:(ChartData data, _) => data.color,
  //                               animationDuration: 2000,
  //
  //                           )
  //                         ]
  //                     )
  //                 ),
  //                 // ElevatedButton(onPressed: (){
  //                 //   _chartSeriesController1?.animate();
  //                 //   chartData.add(ChartData(2025, 75, Colors.red),);
  //                 //
  //                 //   setState(() {
  //                 //
  //                 //   });
  //                 // }, child: Text("Check"))
  //               ],
  //             ),
  //
  //
  //         ),
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Germany', 118, Colors.teal),
      ChartData('Russia', 123, Colors.orange),
      ChartData('Norway', 107, Colors.brown),
      ChartData('USA', 87, Colors.deepOrange)
    ];
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(

                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          // Map color for each data points from the data source
                          pointColorMapper: (ChartData data, _) => data.color
                      )
                    ]
                )
            )
        )
    );
  }


}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
// https://help.syncfusion.com/flutter/cartesian-charts/series-customization#animation