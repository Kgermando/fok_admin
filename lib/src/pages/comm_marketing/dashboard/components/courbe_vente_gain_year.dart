import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/vente_gain_api.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/courbe_vente_gain_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CourbeVenteGainYear extends StatefulWidget {
  const CourbeVenteGainYear({Key? key}) : super(key: key);

  @override
  State<CourbeVenteGainYear> createState() => _CourbeVenteGainYearState();
}

class _CourbeVenteGainYearState extends State<CourbeVenteGainYear> {
  List<CourbeVenteModel> venteList = [];
  List<CourbeGainModel> gainList = [];

  TooltipBehavior? _tooltipBehavior;

  bool? isCardView;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);

    Timer.periodic(const Duration(milliseconds: 500), (t) {
      setState(() {
        loadVente();
        loadGain();
      });
      t.cancel();
    });
    super.initState();
  }

  Future<void> loadGain() async {
    List<CourbeGainModel>? data = await VenteGainApi().getAllDataGainYear();
    if (mounted) {
      setState(() {
        gainList = data;
      });
    }
  }

  void loadVente() async {
    List<CourbeVenteModel>? ventes = await VenteGainApi().getAllDataVenteYear();
    if (mounted) {
      setState(() {
        venteList = ventes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [Icon(Icons.menu)],
        ),
        SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(
                text: 'Courbe de Ventes par an',
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
            // Enable legend
            legend: Legend(
                position: Responsive.isDesktop(context)
                    ? LegendPosition.right
                    : LegendPosition.bottom,
                isVisible: true),
            // Enable tooltip
            palette: const [
              Color.fromRGBO(73, 76, 162, 1),
              Color.fromRGBO(51, 173, 127, 1),
              Color.fromRGBO(244, 67, 54, 1)
            ],
            tooltipBehavior: _tooltipBehavior,
            series: <LineSeries>[
              LineSeries<CourbeVenteModel, String>(
                name: 'Ventes',
                dataSource: venteList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeVenteModel ventes, _) => ventes.created,
                yValueMapper: (CourbeVenteModel ventes, _) =>
                    double.parse(ventes.sum.toStringAsFixed(2)),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
              LineSeries<CourbeGainModel, String>(
                name: 'Gains',
                dataSource: gainList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeGainModel ventes, _) => ventes.created,
                yValueMapper: (CourbeGainModel ventes, _) =>
                    double.parse(ventes.sum.toStringAsFixed(2)),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ]),
      ],
    );
  }
}
