import 'dart:async';

import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashRHPieWidget extends StatefulWidget {
  const DashRHPieWidget({Key? key}) : super(key: key);

  @override
  State<DashRHPieWidget> createState() => _DashRHPieWidgetState();
}

class _DashRHPieWidgetState extends State<DashRHPieWidget> {
  Timer? timer;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<AgentPieChartModel> dataList = [];
  Future<void> getData() async {
    var data = await AgentsApi().getChartPieSexe();
    if (mounted) {
      setState(() {
        dataList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isDesktop(context) ? 400 : double.infinity,
      // height: Responsive.isMobile(context) ? 200 : double.infinity,
      // height: 400,
      child: Card(
        elevation: 6,
        child: SfCircularChart(
            enableMultiSelection: true,
            title: ChartTitle(
                text: 'Sexe',
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            legend: Legend(isVisible: true, isResponsive: true),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<AgentPieChartModel, String>(
                  dataSource: dataList,
                  // pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (AgentPieChartModel data, _) => data.sexe,
                  yValueMapper: (AgentPieChartModel data, _) => data.count)
            ]),
      ),
    );
  }
}
