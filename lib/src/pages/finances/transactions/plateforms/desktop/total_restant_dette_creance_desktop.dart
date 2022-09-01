import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalRestantDetteCreanceDesktop extends StatelessWidget {
  const TotalRestantDetteCreanceDesktop({Key? key, required this.total})
      : super(key: key);
  final double total;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text("TOTAL RESTANT :",
                    textAlign: TextAlign.start,
                    style: headline6!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: mainColor,
                      width: 2,
                    ),
                  )),
                  child: SelectableText(
                      "${NumberFormat.decimalPattern('fr').format(total)} \$",
                      textAlign: TextAlign.center,
                      style: headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
// NumberFormat.decimalPattern('fr')
