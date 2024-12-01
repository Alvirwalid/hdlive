import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartWidget({Key? key}) : super(key: key);

  @override
  ChartWidgetState createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
  List<_ChartData>? data;
  TooltipBehavior? _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('1-21', 12),
      _ChartData('2-21', 15),
      _ChartData('3-21', 30),
      _ChartData('4-21', 6.4),
      _ChartData('5-21', 14),
      _ChartData('6-21', 14),
      _ChartData('7-21', 14),
      _ChartData('8-21', 14),
      _ChartData('9-21', 14),
      _ChartData('10-21', 14),
      _ChartData('11-21', 14),
      _ChartData('12-21', 14),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              axisLabelFormatter: (val) {
                return ChartAxisLabel('${val.text}', TextStyle(fontSize: 8));
              },
            ),
            primaryYAxis: NumericAxis(
                associatedAxisName: 'lacs',
                axisLabelFormatter: (val) {
                  return ChartAxisLabel(
                      '${val.text} M', TextStyle(fontSize: 8));
                },
                minimum: 0,
                maximum: 100,
                interval: 5),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: data!,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: 'Gold',
              width: 0.4,
              color: Colors.red.shade900)
        ]));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
