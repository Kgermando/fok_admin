
import 'package:flutter/material.dart';

Color roleTheme(int role) {
  switch (role) {
    case 0:
      return Colors.red.shade700;
    case 1:
      return Colors.orange.shade700;
    case 2:
      return Colors.green.shade700;
    case 3:
      return Colors.teal.shade700;
    case 4:
      return Colors.deepPurple.shade700;
    case 5:
      return Colors.blueGrey.shade700;
    default:
      return Colors.blue.shade700;
  }
}

MaterialColor roleThemeSwatch(int role) {
  switch (role) {
    case 0:
      return Colors.red;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.green;
    case 3:
      return Colors.teal;
    case 4:
      return Colors.deepPurple;
    case 5:
      return Colors.blueGrey;
    default:
      return Colors.blue;
  }
}
