import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/charts/pie_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EtatMaterielPie extends StatefulWidget {
  const EtatMaterielPie({Key? key}) : super(key: key);

  @override
  State<EtatMaterielPie> createState() => _EtatMaterielPieState();
}

class _EtatMaterielPieState extends State<EtatMaterielPie> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<PieChartMaterielModel> dataList = [];
  Future<void> getData() async {
    var data = await EtatMaterielApi().getChartPieStatut();
    if (mounted) {
      setState(() {
        dataList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(p8),
      child: Material(
        elevation: 10.0,
        child: SfCircularChart(
            title: ChartTitle(
                text: 'Statut materiels',
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            legend: Legend(isVisible: true, isResponsive: true),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<PieChartMaterielModel, String>(
                  dataSource: dataList,
                  // pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (PieChartMaterielModel data, _) => data.statut,
                  yValueMapper: (PieChartMaterielModel data, _) => data.count)
            ]),
      ),
    );
  }
}
