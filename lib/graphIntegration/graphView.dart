

import 'package:firebaseflutterproject/graphIntegration/Graph.dart';
import 'package:firebaseflutterproject/graphIntegration/graphProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class GraphView extends StatefulWidget {
  const GraphView({Key? key}) : super(key: key);
  @override
  State<GraphView> createState() => _GraphViewState();
}
class _GraphViewState extends State<GraphView> {
  var _tooltipBehavior = TooltipBehavior();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final graphProvider = Provider.of<GraphProvider>(context, listen: false);
      graphProvider.callApi();
    });
    _tooltipBehavior = graphToolTip();
  }
  TooltipBehavior graphToolTip() {
    return
      TooltipBehavior(
      enable: true,
      color: Colors.white,
      duration: 6000,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        GraphData graphData = data;
        final dateTime =
        DateFormat('MMMM dd, yyyy hh:mm a').format(graphData.datetime!);
        final style = TextStyle(color: Colors.red);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Icon(Icons.circle,color: Colors.blue,),
              Text(
                ' $dateTime \n Price: ${graphData.price}\n Volume: ${graphData.qty}',
                style: style,
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Graph Integation"),
      ),
      body: Consumer<GraphProvider>(
        builder: (context,data,child){
          return SizedBox(
           child: FutureBuilder(
             future: data.getAsyncGraph,
             builder: (BuildContext context, AsyncSnapshot<Graph> snapshot) {
           if(snapshot.hasData){
             return const Column(
               children: [
                 SizedBox(height: 10.0,),
                  GraphCategories(),
             SizedBox(height: 10.0,),
             Expanded(flex: 4, child:  GraphExample())
                 // CartesianGraph(
                 //   graph: snapshot.data,
                 //   period: data.getPeriod,
                 //   tooltipBehavior: _tooltipBehavior,
                 // ),
               ],
             );
           }
           else if (snapshot.hasError) {
             return Text('${snapshot.error}');
           }
           else {
             return const Center(
               child: CircularProgressIndicator(color:Colors.red),
             );
           }


             },
           ),
          );

        },

      ),
    );
  }
}

class GraphCategories extends StatelessWidget {
  const GraphCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:
          (BuildContext context, GraphProvider graphProvider, Widget? widget) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            height: 3.h,
            child: ListView.builder(
              itemCount: graphProvider.getTitles.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: (index == graphProvider.getTitles.length - 1)
                          ? 0.0
                          : 15.0),
                  child: GestureDetector(
                    onTap: () {
                      graphProvider.setCurrentIndex(index);
                      graphProvider.setPeriod(
                          (index == 0 || index == 2) ? 'daily' : 'historical');
                      graphProvider.callApi();
                    },
                    child: Container(
                      height: 3.h,
                      width: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: (index == graphProvider.getCurrentIndex)
                            ? Colors.transparent
                            : Colors.white,
                        border: Border.all(
                          color: (index == graphProvider.getCurrentIndex)
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          graphProvider.getTitles[index],
                          style: TextStyle(  color: (index == graphProvider.getCurrentIndex)
                              ? Colors.white
                              : Colors.red,)

                          ,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
class CartesianGraph extends StatelessWidget {
  const CartesianGraph(
      {Key? key, this.graph, this.period, this.tooltipBehavior})
      : super(key: key);

  final Graph? graph;
  final String? period;
  final TooltipBehavior? tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    // dateTime format is 2023-03-13 14:54:53.000
print("period is  ${period}");
    return
      SfCartesianChart(
        tooltipBehavior: tooltipBehavior,
        // for zooming purpose and scrollable
        zoomPanBehavior: ZoomPanBehavior(
           enablePanning: true,
          enablePinching: true,
           enableDoubleTapZooming: true,
          // enableMouseWheelZooming: true
        ),
        primaryXAxis: DateTimeAxis(
            // dateFormat:
            // (period == 'daily') ?
            //
            // DateFormat('hh aa')
            //     :
            // DateFormat('yyyy'),
            // intervalType: (period == 'daily')
            //   ? DateTimeIntervalType.hours
            //   : DateTimeIntervalType.years,
            labelStyle: TextStyle(color: Colors.white)),
        primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelStyle: TextStyle(color: Colors.white)
        ),
        //  tooltipBehavior: tooltipBehavior,
        series: [
          LineSeries<GraphData, DateTime>( // (X , Y) (GraphData,DateTime)
            color: Colors.white, // graph color
            dataSource: graph!.graphData!,
            xValueMapper: (GraphData data, _) => data.datetime,
            yValueMapper: (GraphData data, _) => double.parse(data.price!.toStringAsFixed(2).toString()),
            enableTooltip: true,
          ),
        ],

        // primaryXAxis: DateTimeAxis(
        //   // intervalType: (period == 'daily')
        //   //     ? DateTimeIntervalType.hours
        //   //     : DateTimeIntervalType.years,
        //
        //     labelStyle: TextStyle(
        //         color: Colors.white
        //     )
        // ),
        // primaryYAxis: NumericAxis(
        //   //isVisible: false,
        //   edgeLabelPlacement: EdgeLabelPlacement.shift,
        //   labelStyle: TextStyle(
        //       color: Colors.white
        //   ),
        // ),
      );
  }
}
class GraphExample extends StatelessWidget {
  const GraphExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(1, 24),
      ChartData(2, 20),
      ChartData(3, 35),
      ChartData(4, 27),
      ChartData(5, 30),
      ChartData(6, 50),
      ChartData(7, 26)
    ];
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCartesianChart(
              enableAxisAnimation: true,
              primaryXAxis:CategoryAxis(
                // borderWidth: 1.0,
                // borderColor: Colors.red,

                title: AxisTitle(
                  text: "X AXIS",
                ),
                  // axisLine: AxisLine(
                  //     color: Colors.deepOrange,
                  //     width: 2,
                  //     dashArray: <double>[5,5]
                  // )
              ),
             primaryYAxis:NumericAxis(
               // '°C' will be append to all the labels in Y axis
                 labelFormat: '{value}°C',
               plotBands: <PlotBand>[

               ],
               //  labelPosition: ChartDataLabelPosition.inside,
               //  tickPosition: TickPosition.inside,
                // edgeLabelPlacement: EdgeLabelPlacement.shift,
               // borderWidth: 1.0,
               //   majorGridLines: MajorGridLines(
               //       width: 1,
               //       color: Colors.red,
               //       dashArray: <double>[5,5]
               //   ),

               //   minorGridLines: MinorGridLines(
               //       width: 1,
               //       color: Colors.green,
               //       dashArray: <double>[5,5]
               //   ),
               //   minorTicksPerInterval:2,
               //
               // borderColor: Colors.blue,
               // maximumLabels: 3,


                title: AxisTitle(
                  text: "Y AXIS",
                )
              ),
              series: <CartesianSeries<ChartData, int>>[
                LineSeries<ChartData, int>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
                LineSeries<ChartData, int>(
                    dataSource: [
                      ChartData(1, 15, ),
                      ChartData(2, 11, ),
                      ChartData(3, 14, ),
                      ChartData(5, 12, ),
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    xAxisName: 'xAxis',
                    yAxisName: 'yAxis'
                )
              ]

              
          ),
        ),
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}
