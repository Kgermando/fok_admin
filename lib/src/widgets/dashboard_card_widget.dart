import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:intl/intl.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.montant,
      required this.color,
      required this.colorText,
      required this.gestureTapCallback})
      : super(key: key);
  final String title;
  final IconData icon;
  final String montant;
  final Color color;
  final Color colorText;
  final GestureTapCallback gestureTapCallback;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = 250;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = 300;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = double.infinity;
    }
    return InkWell(
      onTap: gestureTapCallback,
      child: Material(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: color,
        child: Container(
          width: width,
          height: 100,
          color: color,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 20.0, color: colorText),
                  AutoSizeText(
                    title,
                    style: Responsive.isDesktop(context)
                        ? TextStyle(fontSize: 20, color: colorText)
                        : TextStyle(fontSize: 18, color: colorText),
                    maxLines: 1,
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert_outlined, color: colorText),
                      onPressed: () {})
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    NumberFormat.decimalPattern('fr')
                        .format(double.parse(montant)),
                    style: Responsive.isDesktop(context)
                        ? TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorText)
                        : TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorText),
                    maxLines: 1,
                  ),
                  const SizedBox(width: 10.0),
                  AutoSizeText(
                    '\$',
                    style: Responsive.isDesktop(context)
                        ? TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorText)
                        : TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorText),
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
