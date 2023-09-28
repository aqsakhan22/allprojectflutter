import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
//https://www.atatus.com/blog/design-stunning-charts-with-fl-charts-in-flutter/
class GraphTesting extends StatefulWidget {
  const GraphTesting({Key? key}) : super(key: key);

  @override
  State<GraphTesting> createState() => _GraphTestingState();
}

class _GraphTestingState extends State<GraphTesting> {
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the blue line
  final List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph tesing"),
      ),
       body:    Column(
         children: [
           // Expanded(child: Container(
           //   padding: const EdgeInsets.all(20),
           //   width: double.infinity,
           //   child: LineChart(
           //     LineChartData(
           //
           //       lineBarsData: [
           //         // The red line
           //         LineChartBarData(
           //           spots: dummyData1,
           //           isCurved: true,
           //           barWidth: 3,
           //           color: Colors.indigo,
           //         ),
           //         // The orange line
           //         LineChartBarData(
           //           spots: dummyData2,
           //           isCurved: true,
           //           barWidth: 3,
           //           color: Colors.red,
           //         ),
           //         // The blue line
           //         LineChartBarData(
           //           spots: dummyData3,
           //           isCurved: false,
           //           barWidth: 3,
           //           color: Colors.blue,
           //         )
           //       ],
           //       // control how the chart looks
           //
           //     ),
           //     swapAnimationDuration: Duration(milliseconds: 150), // Optional
           //     swapAnimationCurve: Curves.linear, // Optional
           //   ),
           // )),
           // Expanded(child: Container(
           //   padding: const EdgeInsets.all(20),
           //   width: double.infinity,
           //   child: BarChart(
           //
           //     BarChartData(
           //       borderData: FlBorderData(
           //           border: const Border(
           //             top: BorderSide.none,
           //             right: BorderSide.none,
           //             left: BorderSide(width: 1),
           //             bottom: BorderSide(width: 1),
           //           )),
           //       groupsSpace: 10,
           //       barGroups: [
           //         BarChartGroupData(x: 1, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 2, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 3, barRods: [
           //           BarChartRodData(fromY: 0, toY: 15, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 4, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 5, barRods: [
           //           BarChartRodData(fromY: 0, toY: 11, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 6, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 7, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //         BarChartGroupData(x: 8, barRods: [
           //           BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
           //         ]),
           //       ]
           //       // look into the source code given below
           //     ),
           //     swapAnimationDuration: Duration(milliseconds: 150), // Optional
           //     swapAnimationCurve: Curves.linear, // Optional
           //   ),
           // )),
           
           
           Expanded(child: PieChart(PieChartData(
               centerSpaceRadius: 5,
               borderData: FlBorderData(show: false),
               sectionsSpace: 2,
               sections: [
                 PieChartSectionData(value: 35, color: Colors.purple, radius: 100),
                 PieChartSectionData(value: 40, color: Colors.amber, radius: 100),
                 PieChartSectionData(value: 55, color: Colors.green, radius: 100),
                 PieChartSectionData(value: 70, color: Colors.orange, radius: 100),
               ])
           ))
         ],
       )
    );
  }
}
