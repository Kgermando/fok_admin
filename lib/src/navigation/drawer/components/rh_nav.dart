import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/departements/rh_departement.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class RhNav extends StatefulWidget {
  const RhNav({Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  State<RhNav> createState() => _RhNavState();
}

class _RhNavState extends State<RhNav> {
  bool isOpenRh = false;
  int itemCount = 0;

  int salairesCount = 0;
  int transRestCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    var notify = await RhDepartementNotifyApi().getCountRh();

    if (mounted) {
      setState(() {
        itemCount = int.parse(notify.sum);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    int userRole = int.parse(widget.user.role);
    return ExpansionTile(
      leading: const Icon(Icons.group, size: 30.0),
      title: AutoSizeText('RH', maxLines: 1, style: bodyLarge),
      initiallyExpanded:
          (widget.user.departement == 'Ressources Humaines') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenRh = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhDashboard,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhDashboard);
                // Navigator.of(context).pop();
              }),
        // if (userRole <= 2)
        //   DrawerWidget(
        //       selected: widget.pageCurrente == RhRoutes.rhDD,
        //       icon: Icons.manage_accounts,
        //       sizeIcon: 20.0,
        //       title: 'Directeur de département',
        //       style: bodyText1!,
        //       badge: Badge(
        //         showBadge: (itemCount >= 1) ? true : false,
        //         badgeColor: Colors.teal,
        //         badgeContent: Text('$itemCount',
        //             style:
        //                 const TextStyle(fontSize: 10.0, color: Colors.white)),
        //         child: const Icon(Icons.notifications),
        //       ),
        //       onTap: () {
        //         Navigator.pushNamed(context, RhRoutes.rhDD);
        //         // Navigator.of(context).pop();
        //       }),
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhAgent,
              icon: Icons.group,
              sizeIcon: 20.0,
              title: 'Personnels',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhAgent);
                // Navigator.of(context).pop();
              }),
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhPaiement,
              icon: Icons.real_estate_agent_sharp,
              sizeIcon: 20.0,
              title: 'Paiements',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhPaiement);
                // Navigator.of(context).pop();
              }),
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhTransportRest,
              icon: Icons.restaurant,
              sizeIcon: 20.0,
              title: 'Transport & restauration | Autres frais',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhTransportRest);
                // Navigator.of(context).pop();
              }),
        DrawerWidget(
            selected: widget.pageCurrente == RhRoutes.rhPresence,
            icon: Icons.checklist_outlined,
            sizeIcon: 20.0,
            title: 'Présences',
            style: bodyText1!,
            onTap: () {
              Navigator.pushNamed(context, RhRoutes.rhPresence);
              // Navigator.of(context).pop();
            }),
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhPerformence,
              icon: Icons.multiline_chart_sharp,
              sizeIcon: 20.0,
              title: 'Performences',
              style: bodyText1,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhPerformence);
                // Navigator.of(context).pop();
              }),
        DrawerWidget(
            selected: widget.pageCurrente == ArchiveRoutes.archives,
            icon: Icons.archive,
            sizeIcon: 20.0,
            title: 'Archives',
            style: bodyLarge!,
            onTap: () {
              Navigator.pushNamed(context, ArchiveRoutes.archives);
              // Navigator.of(context).pop();
            }),
      ],
    );
  }
}
