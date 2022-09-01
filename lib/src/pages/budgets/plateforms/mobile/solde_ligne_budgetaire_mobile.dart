import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SoldeLignBudgetaireMobile extends StatelessWidget {
  const SoldeLignBudgetaireMobile(
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Column(
      children: [
        Row(children: [
          Expanded(
              child: Column(
            children: [
              const Text("Solde Caisse",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(
                  "${NumberFormat.decimalPattern('fr').format(caisseSolde)} \$",
                  textAlign: TextAlign.center,
                  style: bodyLarge),
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
                    style: bodyLarge),
              ],
            ),
          )),
        ]),
        Row(children: [
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
                    style: bodyLarge!.copyWith(color: Colors.orange.shade700)),
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
                    style: bodyLarge.copyWith(
                        color: (touxExecutions >= 50)
                            ? Colors.green.shade700
                            : Colors.red.shade700)),
              ],
            ),
          )),
        ]),
      ],
    );
  }
}
