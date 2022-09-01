import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_gain_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/vente_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ArticlePlusVendus extends StatefulWidget {
  const ArticlePlusVendus({Key? key}) : super(key: key);

  @override
  State<ArticlePlusVendus> createState() => _ArticlePlusVendusState();
}

class _ArticlePlusVendusState extends State<ArticlePlusVendus> {
  List<VenteChartModel> venteChartModel = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    loadVente();
    super.initState();
  }

  Future<void> loadVente() async {
    List<VenteChartModel>? data = await VenteGainApi().getVenteChart();
    if (mounted) {
      setState(() {
        venteChartModel = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Produits les plus vendus',
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        legend: Legend(
            position: Responsive.isDesktop(context)
                ? LegendPosition.right
                : LegendPosition.bottom,
            isVisible: true),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          BarSeries<VenteChartModel, String>(
              name: 'Produits',
              dataSource: venteChartModel,
              sortingOrder: SortingOrder.descending,
              xValueMapper: (VenteChartModel gdp, _) => gdp.idProductCart,
              yValueMapper: (VenteChartModel gdp, _) => gdp.count,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true)
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
        primaryYAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(text: '10 produits les plus vendus')),
      ),
    );
  }
}
