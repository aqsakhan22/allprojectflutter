import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
class TrackballMovde extends StatefulWidget {
  const TrackballMovde({Key? key}) : super(key: key);

  @override
  State<TrackballMovde> createState() => _TrackballMovdeState();
}

class _TrackballMovdeState extends State<TrackballMovde> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:        SfSparkLineChart(

        axisLineWidth: 0,
        trackball: SparkChartTrackball(

            backgroundColor: Colors.red.withOpacity(0.8),
            borderColor: Colors.red.withOpacity(0.8),
            borderWidth: 2,
            color: Colors.red,
            labelStyle: TextStyle(color: Colors.black),
            activationMode: SparkChartActivationMode.tap
        ),
        marker: SparkChartMarker(
            displayMode: SparkChartMarkerDisplayMode.all),
        data: <double>[
          5, 6, 5, 7, 4, 3, 9, 5, 6, 5, 7, 8, 4, 5, 3, 4, 11, 10, 2, 12, 4, 7, 6, 8
        ],
      ),
    )
        )
    );
  }
}
