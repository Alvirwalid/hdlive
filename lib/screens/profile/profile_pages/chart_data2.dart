import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget2 extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartWidget2({Key? key}) : super(key: key);

  @override
  ChartWidget2State createState() => ChartWidget2State();
}

class ChartWidget2State extends State<ChartWidget2> {
  List<_ChartData2>? data2;
  TooltipBehavior? _tooltip;

  @override
  void initState() {
    data2 = [
      _ChartData2('1', 12),
      _ChartData2('2', 15),
      _ChartData2('3', 30),
      _ChartData2('4', 6.4),
      _ChartData2('5', 14),
      _ChartData2('6', 14),
      _ChartData2('7', 14),
      _ChartData2('8', 14),
      _ChartData2('9', 14),
      _ChartData2('10', 14),
      _ChartData2('11', 14),
      _ChartData2('12', 14),
      _ChartData2('13', 14),
      _ChartData2('14', 14),
      _ChartData2('15', 14),
      _ChartData2('16', 14),
      _ChartData2('17', 14),
      _ChartData2('18', 14),
      _ChartData2('19', 14),
      _ChartData2('20', 14),
      _ChartData2('21', 14),
      _ChartData2('22', 14),
      _ChartData2('23', 14),
      _ChartData2('24', 14),
      _ChartData2('25', 14),
      _ChartData2('26', 14),
      _ChartData2('27', 14),
      _ChartData2('28', 14),
      _ChartData2('29', 14),
      _ChartData2('30', 14),
      _ChartData2('31', 14),
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
                      '${val.text}h ', TextStyle(fontSize: 8));
                },
                minimum: 0,
                maximum: 10,
                interval: 1),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<_ChartData2, String>>[
          ColumnSeries<_ChartData2, String>(
              dataSource: data2!,
              xValueMapper: (_ChartData2 data2, _) => data2.x,
              yValueMapper: (_ChartData2 data2, _) => data2.y,
              width: 0.2,
              color: Colors.red.shade900)
        ]));
  }
}

class _ChartData2 {
  _ChartData2(this.x, this.y);

  final String x;
  final double y;
}
