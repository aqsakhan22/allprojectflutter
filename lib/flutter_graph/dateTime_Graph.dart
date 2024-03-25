import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class DateTimeGraph extends StatefulWidget {
  const DateTimeGraph({Key? key}) : super(key: key);

  @override
  State<DateTimeGraph> createState() => _DateTimeGraphState();
}

class _DateTimeGraphState extends State<DateTimeGraph> {

  List<ChartSampleData> chartData = <ChartSampleData>[
    // DateTime(int year,
    //     [int month = 1,
    //       int day = 1,
    //       int hour = 0,
    //       int minute = 0,
    //       int second = 0,
    //       int millisecond = 0,
    //       int microsecond = 0])
    ChartSampleData(DateTime(2015, 1, 1, 1),  1.13),
    ChartSampleData(DateTime(2016, 1, 2, 2),  1.12),
    ChartSampleData( DateTime(2017, 1, 3, 3),  1.08),
    ChartSampleData(DateTime(2018, 1, 4, 4),  1.12),
    ChartSampleData( DateTime(2019, 1, 5, 5),  1.1),
    ChartSampleData( DateTime(2020, 1, 6, 6),  1.12),
    ChartSampleData( DateTime(2021, 1, 7, 7),  1.1),
    ChartSampleData( DateTime(2022, 1, 8, 8),  1.12),
    ChartSampleData( DateTime(2023, 1, 9, 9),  1.16),
    ChartSampleData( DateTime(2024, 1, 10, 10),  1.1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Time Series Graph"),),
      body: SfCartesianChart(
       //plotAreaBackgroundColor: Colors.black12,
        //  plotAreaBorderColor: Colors.orange,
          // primaryXAxis: DateTimeAxis(),
          //primaryXAxis: DateTimeCategoryAxis(),

          primaryXAxis: DateTimeAxis(

//   dateFormat: DateFormat('MMM'),
            // dateFormat: DateFormat.yMd(),
            //Specified date time interval type in hours
               intervalType: DateTimeIntervalType.hours,
              // Interval type will be years
              // intervalType: DateTimeIntervalType.years,
              // interval: 2,

            minimum: DateTime(2015, 1),
            maximum: DateTime(2024, 1),
            // autoScrollingDeltaType: DateTimeIntervalType.auto,
            // autoScrollingDelta: 10,
            autoScrollingMode: AutoScrollingMode.start,
          ),

          series: <LineSeries<ChartSampleData, DateTime>>[
            LineSeries<ChartSampleData, DateTime>(
                dataSource: chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.x,
                yValueMapper: (ChartSampleData sales, _) => sales.yValue
            )
          ]
      ),
    );
  }
}

class ChartSampleData{
  ChartSampleData(this.x, this.yValue);
  final DateTime x;
  final double yValue;
}