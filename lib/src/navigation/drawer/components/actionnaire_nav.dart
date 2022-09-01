import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class ActionnaireNav extends StatefulWidget {
  const ActionnaireNav(
      {Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  State<ActionnaireNav> createState() => _ActionnaireNavState();
}

class _ActionnaireNavState extends State<ActionnaireNav> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    int userRole = int.parse(widget.user.role);
    return ExpansionTile(
      leading: const Icon(Icons.group, size: 30.0),
      title: AutoSizeText('RH', maxLines: 1, style: bodyLarge),
      initiallyExpanded:
          (widget.user.departement == 'Actionnaire') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected:
                  widget.pageCurrente == ActionnaireRoute.actionnaireDashboard,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(
                    context, ActionnaireRoute.actionnaireDashboard);
                // Navigator.of(context).pop();
              }),
        DrawerWidget(
            selected: widget.pageCurrente == ActionnaireRoute.actionnairePage,
            icon: Icons.savings,
            sizeIcon: 20.0,
            title: 'Cotisations',
            style: bodyText1!,
            onTap: () {
              Navigator.pushNamed(context, ActionnaireRoute.actionnairePage);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
