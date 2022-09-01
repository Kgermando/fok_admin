import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SoldeLignBudgetaireTablet extends StatelessWidget {
  const SoldeLignBudgetaireTablet(
      {Key? key,
      required this.caisseSolde,
      required this.banqueSolde,
      required this.finExterieurSolde,
      required this.touxExecutions})
      : super(key: key);
  final double caisseSolde;
  final double banqueSolde;
  final double finExterieurSolde;
  final double touxExecutions;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Row(children: [
      Expanded(
          child: Column(
        children: [
          const Text("Solde Caisse",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(
              "${NumberFormat.decimalPattern('fr').format(caisseSolde)} \$",
              textAlign: TextAlign.center,
              style: headline6),
        ],
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: mainColor,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Solde Banque",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(banqueSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6),
          ],
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: mainColor,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Solde Reste à trouver",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(finExterieurSolde)} \$",
                textAlign: TextAlign.center,
                style: headline6!.copyWith(color: Colors.orange.shade700)),
          ],
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: mainColor,
            width: 2,
          ),
        )),
        child: Column(
          children: [
            const Text("Taux d'executions",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
                "${NumberFormat.decimalPattern('fr').format(double.parse(touxExecutions.toStringAsFixed(0)))} %",
                textAlign: TextAlign.center,
                style: headline6.copyWith(
                    color: (touxExecutions >= 50)
                        ? Colors.green.shade700
                        : Colors.red.shade700)),
          ],
        ),
      )),
    ]);
  }
}
