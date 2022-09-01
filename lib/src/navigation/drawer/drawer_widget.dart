import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget(
      {Key? key,
      required this.selected,
      this.selectedTileColor,
      required this.icon,
      required this.title,
      required this.onTap,
      required this.style,
      required this.sizeIcon,
      this.badge})
      : super(key: key);

  final bool selected;
  final Color? selectedTileColor;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final TextStyle style;
  final double sizeIcon;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    Color? colorCard;
    if (selected == true) {
      colorCard = themeColor;
    }
    Color? color;
    if (selected == true) {
      color = Colors.white;
    }
    return Card(
      color: colorCard,
      child: ListTile(
        dense: true,
        leading: Icon(icon,
            size: sizeIcon,
            // color: color,
            color: color),
        title: AutoSizeText(title,
            maxLines: 2, style: style.copyWith(color: color)),
        trailing: badge,
        onTap: onTap,
        style: ListTileStyle.drawer,
      ),
    );
  }
}
