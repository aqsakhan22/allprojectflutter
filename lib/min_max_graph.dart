import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
class minmaxgraph extends StatefulWidget {
  const minmaxgraph({Key? key}) : super(key: key);

  @override
  State<minmaxgraph> createState() => _minmaxgraphState();
}

class _minmaxgraphState extends State<minmaxgraph> {
  final double _min = 2.0;
  final double _max = 19.0;
  SfRangeValues _values = SfRangeValues(8.0, 16.0);
  late RangeController _rangeController;
  late SfCartesianChart _chart;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rangeController = RangeController(start: _values.start, end: _values.end);
  }
  @override
  Widget build(BuildContext context) {
    final List<Data> chartData = <Data>[
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
            dataSource: chartData,
            animationDuration: 0,
            xValueMapper: (Data sales, _) => sales.x,
            yValueMapper: (Data sales, _) => sales.y)
      ],
    );

    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 80),
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
          ),
        ));
  }
}

class Data {
  Data(this.x, this.y,);
  final double x;
  final double y;

}
