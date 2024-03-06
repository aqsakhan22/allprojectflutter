import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:untitled/min_max_graph.dart';



// https://www.syncfusion.com/forums/179576/smooth-scrolling-in-sfcartesianchart
// https://github.com/aqsakhan22/allprojectflutter
// https://help.syncfusion.com/flutter/cartesian-charts/trackball-crosshair#trackball-marker-settings

class SyncScroll extends StatefulWidget {
  @override
  State<SyncScroll> createState() => _SyncScrollState();
}

class _SyncScrollState extends State<SyncScroll> {
  ChartSeriesController? _chartSeriesController1;
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;
  late SelectionBehavior _selectionBehavior;
  // late ScrollController _scrollController;
  final List<ChartData> chartData = [
    ChartData(2010, 10, Colors.red),
    ChartData(2011, 15,Colors.orange),
    ChartData(2012, 20,Colors.green),
    ChartData(2013, 34,Colors.grey),
    ChartData(2014, 44,Colors.pink),
    ChartData(2015, 54,Colors.yellow),
    ChartData(2016, 34,Colors.amber),
    ChartData(2017, 24,Colors.black),
    ChartData(2018, 14,Colors.blue),
    ChartData(2019, 34,Colors.orange),
    ChartData(2020, 34,Colors.redAccent),
    ChartData(2021, 14,Colors.redAccent),
    ChartData(2022, 4,Colors.orange),
  ];
  final double _min = 2.0;
  final double _max = 19.0;
  SfRangeValues _values = SfRangeValues(8.0, 16.0);
  late RangeController _rangeController;
  late SfCartesianChart _chart;

  // trackballBehavior: TrackballBehavior(enable: true,
  // tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
  // activationMode: ActivationMode.singleTap,
  // markerSettings: TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible),
  // tooltipSettings: InteractiveTooltip(
  // enable: true,
  // color: Colors.red,
  // format: 'point.y%',
  //
  // //fluttergraph
  // ),
  // builder: (BuildContext context, TrackballDetails trackballDetails) {
  // return Container(
  // height: 50,
  // width: 150,
  // decoration: BoxDecoration(
  // color: Color.fromRGBO(0, 8, 22, 0.75),
  // borderRadius: BorderRadius.all(Radius.circular(6.0)),
  // ),
  // child: Row(
  // children: [
  // // Padding(
  // //     padding: EdgeInsets.only(left: 5),
  // //     child: SizedBox(
  // //       child: Image.asset('images/People_Circle16.png'),
  // //       height: 30,
  // //       width: 30,
  // //     )
  // // ),
  // Center(
  // child: Container(
  // padding: EdgeInsets.only(top: 11, left: 7),
  // height: 40,
  // width: 100,
  // child: Text(
  // '${trackballDetails.point!.x.toString()} : \$${trackballDetails.point!.y.toString()}',
  // style: TextStyle(
  // fontSize: 13,
  // color: Color.fromRGBO(255, 255, 255, 1)
  // )
  // )
  // )
  // )
  // ],
  // ),
  // );
  // },
  //
  // ),

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectionBehavior = SelectionBehavior(
      // Enables the selection
        enable: true, selectedColor: Colors.red,
        unselectedColor: Colors.grey);
    _rangeController = RangeController(start: _values.start, end: _values.end);

    // SchedulerBinding.instance.addPostFrameCallback((_) =>
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }
  @override
  Widget build(BuildContext context) {
    final List<Data> chartData1 = <Data>[
      Data(2.0,  2.2),
      Data(3.0, 3.4),
      Data(4.0, 2.8),
      Data(5.0,  1.6),
      Data(6.0,  2.3),
      Data(7.0,  2.5),
      Data(8.0,  2.9),
      Data(9.0,  3.8),
      Data(10.0,  3.7),Data(11.0,  4.7),Data(12.0,  5.7),Data(13.0,  7.7),Data(13.0,  10),Data(14.0,  15),
    ];
    _chart = SfCartesianChart(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      primaryXAxis: NumericAxis(
        // Setting minimum and maximum values for the chart axis.
          minimum: _min,
          maximum: _max,
          isVisible: true,
          rangeController: _rangeController // Setting range controller for the chart axis
      ),
      primaryYAxis: NumericAxis(isVisible: true),
      plotAreaBorderWidth: 0,
      series: <SplineSeries<Data, double>>[
        SplineSeries<Data, double>(
            color: Color.fromARGB(255, 126, 184, 253),
            dataSource: chartData1,
            animationDuration: 0,
            xValueMapper: (Data sales, _) => sales.x,
            yValueMapper: (Data sales, _) => sales.y)
      ],
    );
    return Scaffold(
        appBar: AppBar(title: Text("Graphs",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue
          ,),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
          child: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            // reverse: true,
            // controller: _scrollController,
            // scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Text("Scrollable Graph"),
                Container(
                    width:600,

                    child: SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                            enable: true,
                            borderColor: Colors.red,
                            borderWidth: 5,
                            color: Colors.lightBlue,
                            format: 'point.y%',
                            tooltipPosition: TooltipPosition.pointer,
                            builder: (dynamic data, dynamic point, dynamic series,
                                int pointIndex, int seriesIndex) {
                              return Container(
                                  color: Colors.blue,
                                  child: Text(
                                    '${chartData[pointIndex].y}',
                                    style: TextStyle(color: Colors.white),
                                  )
                              );
                            }
                        ),
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                        // enableAxisAnimation: true,
                        //  primaryXAxis: CategoryAxis(),
                        primaryXAxis: CategoryAxis(

                          // title: AxisTitle(text: 'Primary X Axis'),
                          title: AxisTitle(
                              text: "Years"
                          ),
                          autoScrollingDelta: 10,
                          autoScrollingMode: AutoScrollingMode.start,

                        ),
                        primaryYAxis: CategoryAxis(
                          title: AxisTitle( text: "Numbers",


                            // text: 'Primary Y Axis',
                          ),
                          opposedPosition: true,
                        ),
                        series: <CartesianSeries>[
                          // Renders line chart
                          LineSeries<ChartData, int>(
                              name: 'Weekly expenses',
                              markerSettings: MarkerSettings(isVisible: true),
                              onRendererCreated: (ChartSeriesController controller) {
                                _chartSeriesController1 = controller;
                              },
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              // pointColorMapper:(ChartData data, _) => data.color,
                              animationDuration: 2000,
                              selectionBehavior: _selectionBehavior

                          )
                        ]
                    )
                ),
                Text("Range Graph"),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: _chart,
                      ),
                      SfRangeSelector(
                        // Setting minimum and maximum values for the SfRangeSelector
                        min: _min,
                        max: _max,
                        interval: 2,
                        showTicks: true,
                        showLabels: true,
                        controller: _rangeController, // setting range controller for the SfRangeSelector
                        child: Container(
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                )


                // ElevatedButton(onPressed: (){
                //   _chartSeriesController1?.animate();
                //   chartData.add(ChartData(2025, 75, Colors.red),);
                //
                //   setState(() {
                //
                //   });
                // }, child: Text("Check"))
              ],
            ),


          ),
        )
    );
  }




}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final int x;
  final double y;
  final Color color;
}
class ChartData1 {
  ChartData1(this.x, this.y,);
  final String x;
  final double y;

}