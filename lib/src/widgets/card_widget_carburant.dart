import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/responsive.dart'; 
import 'package:intl/intl.dart';

class CardWidgetCarburant extends StatelessWidget {
  const CardWidgetCarburant(
      {Key? key,
      required this.title,
      required this.icon,
      required this.qty,
      required this.color,
      required this.colorText})
      : super(key: key);

  final String title;
  final IconData icon;
  final String qty;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    return Material(
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
                Expanded(
                  child: AutoSizeText(
                    title,
                    style: Responsive.isDesktop(context)
                        ? TextStyle(fontSize: 16, color: colorText)
                        : TextStyle(fontSize: 10, color: colorText),
                    maxLines: 3,
                  ),
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
                  '${NumberFormat.decimalPattern('fr').format(double.parse(qty))} L',
                  style: Responsive.isDesktop(context)
                      ? TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorText)
                      : TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorText),
                  maxLines: 1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
