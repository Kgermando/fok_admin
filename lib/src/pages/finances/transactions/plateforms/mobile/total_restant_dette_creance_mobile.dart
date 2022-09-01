import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalRestantDetteCreanceMobile extends StatelessWidget {
  const TotalRestantDetteCreanceMobile({Key? key, required this.total})
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
                flex: 1,
                child: AutoSizeText("TOTAL :",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: headline6!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: AutoSizeText(
                    "${NumberFormat.decimalPattern('fr').format(total)} \$",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
