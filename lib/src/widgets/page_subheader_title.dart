import 'package:flutter/material.dart';

class PageSubHeaderTitle extends StatelessWidget {
  const PageSubHeaderTitle({Key? key, 
    required this.icon, 
    required this.title, 
    required this.color}) : super(key: key);
    
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
          size: 15.0,
          color: color
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(title, style: TextStyle(color: color, fontSize: 20),),
      ],
    );
  }
}
