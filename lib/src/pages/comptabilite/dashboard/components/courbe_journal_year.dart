// import 'package:flutter/material.dart';
// import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
// import 'package:fokad_admin/src/constants/responsive.dart';
// import 'package:fokad_admin/src/models/comptabilites/courbe_journal_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CourbeJournalYear extends StatefulWidget {
//   const CourbeJournalYear({Key? key}) : super(key: key);

//   @override
//   State<CourbeJournalYear> createState() => _CourbeJournalYearState();
// }

// class _CourbeJournalYearState extends State<CourbeJournalYear> {
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
//         await JournalApi().getAllDataJournalYear();
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
//           title: ChartTitle(text: 'Courbe de journals par an'),
//           // Enable legend
//           legend: Legend(
//               position: Responsive.isDesktop(context)
//                   ? LegendPosition.right
//                   : LegendPosition.bottom,
//               isVisible: true),
//           // Enable tooltip
//           palette: [Colors.teal.shade700, Colors.pink.shade700],
//           tooltipBehavior: _tooltipBehavior,
//           series: <LineSeries>[
//             LineSeries<CourbeJournalModel, String>(
//               name: 'Débit',
//               dataSource: journalsList,
//               sortingOrder: SortingOrder.ascending,
//               markerSettings: const MarkerSettings(isVisible: true),
//               xValueMapper: (CourbeJournalModel ventes, _) =>
//                   '${ventes.created} AN',
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
//                   '${data.created} AN',
//               yValueMapper: (CourbeJournalModel data, _) =>
//                   double.parse(data.sumCredit.toStringAsFixed(2)),
//               // Enable data label
//               dataLabelSettings: const DataLabelSettings(isVisible: true),
//             ),
//           ]),
//     );
//   }
// }
