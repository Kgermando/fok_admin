import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';

/// Package import

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

class AnimationLineChart extends StatefulWidget {
  const AnimationLineChart({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AnimationLineChart> createState() => _AnimationLineChartState();
}

class _AnimationLineChartState extends State<AnimationLineChart> {
  Timer? _timer;
  List<_ChartData>? _chartData;
  List<_ChartData>? _chartData2;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    _getChartData2();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
        _getChartData2();
      });
    });

    return Padding(
      padding: const EdgeInsets.all(p8),
      child: Material(elevation: 10.0, child: _buildAnimationLineChart()),
    );
  }

  ///Get the cartesian chart with line series
  SfCartesianChart _buildAnimationLineChart() {
    return SfCartesianChart(
        title: ChartTitle(
            text: widget.title,
            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        plotAreaBorderWidth: 0,
        legend: Legend(
            isVisible: true,
            isResponsive: true,
            position: Responsive.isDesktop(context)
                ? LegendPosition.right
                : LegendPosition.bottom),
        primaryXAxis:
            NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultLineSeries());
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          dataSource: _chartData!,
          name: 'Entrées',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, num>(
          dataSource: _chartData2!,
          name: 'Sorties',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _chartData!.clear();
  }

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i < 11; i++) {
      _chartData!.add(_ChartData(i, _getRandomInt(5, 95)));
    }
    _timer?.cancel();
  }

  void _getChartData2() {
    _chartData2 = <_ChartData>[];
    for (int i = 0; i < 11; i++) {
      _chartData2!.add(_ChartData(i, _getRandomInt(5, 95)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
