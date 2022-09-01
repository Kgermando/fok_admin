import 'dart:async';

import 'package:fokad_admin/src/api/finances/depenses_api.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeviePieDepYear extends StatefulWidget {
  const DeviePieDepYear({Key? key}) : super(key: key);

  @override
  State<DeviePieDepYear> createState() => _DeviePieDepYearState();
}

class _DeviePieDepYearState extends State<DeviePieDepYear> {
  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), ((timer) {
      setState(() {
        getData();
      });
    }));
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  List<PieChartModel> dataList = [];
  Future<void> getData() async {
    var data = await DepensesAPi().getChartPieDepYear();
    setState(() {
      dataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(p8),
      child: Material(
        elevation: 10.0,
        child: SfCircularChart(
            title: ChartTitle(
                text: 'Dépenses annuelle par département',
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            legend: Legend(isVisible: true, isResponsive: true),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<PieChartModel, String>(
                  dataSource: dataList,
                  // pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (PieChartModel data, _) => data.departement,
                  yValueMapper: (PieChartModel data, _) => data.sum)
            ]),
      ),
    );
  }
}
