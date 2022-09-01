import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ArrayDashboardWidget extends StatelessWidget {
  const ArrayDashboardWidget({Key? key, 
    required this.number, required this.title, required this.icon, 
    required this.background, required this.color}) : super(key: key);
  final String number;
  final String title;
  final IconData icon;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    // final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10.0,
            shadowColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: 300,
              height: 50,
              color: color,
              padding: const EdgeInsets.all(16.0 * 0.75),
              child: AutoSizeText(
                title,
                maxLines: 1,
                style: headline6!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }


    Widget textDecoration(String text) {
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 10,
          ),
        ),
        child: Text(text));
  }
}
