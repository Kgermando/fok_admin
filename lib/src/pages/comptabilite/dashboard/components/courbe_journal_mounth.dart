// import 'package:flutter/material.dart';
// import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
// import 'package:fokad_admin/src/constants/responsive.dart';
// import 'package:fokad_admin/src/models/comptabilites/courbe_journal_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CourbeJournalMounth extends StatefulWidget {
//   const CourbeJournalMounth({Key? key}) : super(key: key);

//   @override
//   State<CourbeJournalMounth> createState() => _CourbeJournalMounthState();
// }

// class _CourbeJournalMounthState extends State<CourbeJournalMounth> {
//   List<CourbeJournalModel> journalsList = [];

//   TooltipBehavior? _tooltipBehavior;

//   bool? isCardView;

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);

//     loadVente();
//     super.initState();
//   }

//   void loadVente() async {
//     List<CourbeJournalModel>? journals =
//         await JournalApi().getAllDataJournalMouth();
//     if (mounted) {
//       setState(() {
//         journalsList = journals.toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       child: SfCartesianChart(
//           primaryXAxis: CategoryAxis(),
//           // Chart title
//           title: ChartTitle(text: 'Courbe de journals par mois'),
//           // Enable legend
//           legend: Legend(
//               position: Responsive.isDesktop(context)
//                   ? LegendPosition.right
//                   : LegendPosition.bottom,
//               isVisible: true),
//           // Enable tooltip
//           palette: [Colors.blue.shade700, Colors.pink.shade700],
//           tooltipBehavior: _tooltipBehavior,
//           series: <LineSeries>[
//             LineSeries<CourbeJournalModel, String>(
//               name: 'Débit',
//               dataSource: journalsList,
//               sortingOrder: SortingOrder.ascending,
//               markerSettings: const MarkerSettings(isVisible: true),
//               xValueMapper: (CourbeJournalModel data, _) =>
//                   '${data.created} Mois',
//               yValueMapper: (CourbeJournalModel data, _) =>
//                   double.parse(data.sumDebit.toStringAsFixed(2)),
//               // Enable data label
//               dataLabelSettings: const DataLabelSettings(isVisible: true),
//             ),
//             LineSeries<CourbeJournalModel, String>(
//               name: 'Crédit',
//               dataSource: journalsList,
//               sortingOrder: SortingOrder.ascending,
//               markerSettings: const MarkerSettings(isVisible: true),
//               xValueMapper: (CourbeJournalModel data, _) =>
//                   '${data.created} Mois',
//               yValueMapper: (CourbeJournalModel ventes, _) =>
//                   double.parse(ventes.sumCredit.toStringAsFixed(2)),
//               // Enable data label
//               dataLabelSettings: const DataLabelSettings(isVisible: true),
//             ),
//           ]),
//     );
//   }
// }
