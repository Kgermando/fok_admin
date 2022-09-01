import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PageHeaderTitle extends StatelessWidget {
  const PageHeaderTitle({Key? key, 
    required this.icon, 
    required this.title, required this.color}) : super(key: key);
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       Icon(icon, size: 20.0, color: color),
        const SizedBox(
          width: 10.0,
        ),
        AutoSizeText(
          title, 
          style: TextStyle(color: color),
          maxLines:  1,
        ),
      ],
    );
  }
}
