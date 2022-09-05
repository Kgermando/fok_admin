import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart'; 
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/departements/admin_departement.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class AdministrationNav extends StatefulWidget {
  const AdministrationNav(
      {Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  State<AdministrationNav> createState() => _AdministrationNavState();
}

class _AdministrationNavState extends State<AdministrationNav> {
  bool isOpenAdmin = false;

  int budgetCount = 0;
  int financeCount = 0;
  int comptabiliteCount = 0;
  int rhCount = 0;
  int exploitationCount = 0;
  int commMarketingCount = 0;
  int logistiqueCount = 0;
  int etatBesoinCount = 0;

  Timer? timer;

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
    var notifyBudget = await AdminDepartementNotifyApi().getCountBudget();
    var notifyRH = await AdminDepartementNotifyApi().getCountRh();
    var notifyFin = await AdminDepartementNotifyApi().getCountFinance();
    var notifyComptabilite =
        await AdminDepartementNotifyApi().getCountComptabilite();
    var notifyExp = await AdminDepartementNotifyApi().getCountExploitation();
    var notifyComMarketing =
        await AdminDepartementNotifyApi().getCountComMarketing();
    var notifylog = await AdminDepartementNotifyApi().getCountLogistique();
    var notifyDevis = await AdminDepartementNotifyApi().getCountDevis();
    if (mounted) {
      setState(() {
        budgetCount = int.parse(notifyBudget.sum);
        comptabiliteCount = int.parse(notifyComptabilite.sum);
        commMarketingCount = int.parse(notifyComMarketing.sum);
        exploitationCount = int.parse(notifyExp.sum);
        logistiqueCount = int.parse(notifylog.sum);
        financeCount = int.parse(notifyFin.sum);
        rhCount = int.parse(notifyRH.sum);
        etatBesoinCount = int.parse(notifyDevis.sum);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return ExpansionTile(
      leading: const Icon(
        Icons.admin_panel_settings,
        size: 30.0,
      ),
      title: AutoSizeText('Administration', maxLines: 1, style: bodyLarge),
      initiallyExpanded:
          (widget.user.departement == 'Administration') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenAdmin = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        DrawerWidget(
            selected: widget.pageCurrente == AdminRoutes.adminDashboard,
            icon: Icons.dashboard,
            sizeIcon: 20.0,
            title: 'Dashboard',
            style: bodyText1!,
            onTap: () {
              Navigator.pushNamed(context, AdminRoutes.adminDashboard);
              // Navigator.of(context).pop();
            }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminBudget,
        //     icon: Icons.fact_check,
        //     sizeIcon: 20.0,
        //     title: 'Budgets',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (budgetCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$budgetCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminBudget);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminFinance,
        //     icon: Icons.account_balance,
        //     sizeIcon: 20.0,
        //     title: 'Finances',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (financeCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$financeCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminFinance);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminComptabilite,
        //     icon: Icons.table_view,
        //     sizeIcon: 20.0,
        //     title: 'Comptabilités',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (comptabiliteCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$comptabiliteCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminComptabilite);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminRH,
        //     icon: Icons.group,
        //     sizeIcon: 20.0,
        //     title: 'RH',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (rhCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$rhCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminRH);
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminExploitation,
        //     icon: Icons.work,
        //     sizeIcon: 20.0,
        //     title: 'Exploitations',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (exploitationCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$exploitationCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminExploitation);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminCommMarketing,
        //     icon: Icons.add_business,
        //     sizeIcon: 20.0,
        //     title: 'Comm. & Marketing',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (commMarketingCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$commMarketingCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminCommMarketing);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == AdminRoutes.adminLogistique,
        //     icon: Icons.home_work,
        //     sizeIcon: 20.0,
        //     title: 'Logistiques',
        //     style: bodyText1,
        //     badge: Badge(
        //       showBadge: (logistiqueCount >= 1) ? true : false,
        //       badgeColor: Colors.teal,
        //       badgeContent: Text('$logistiqueCount',
        //           style: const TextStyle(fontSize: 10.0, color: Colors.white)),
        //       child: const Icon(Icons.notifications),
        //     ),
        //     onTap: () {
        //       Navigator.pushNamed(context, AdminRoutes.adminLogistique);
        //       // Navigator.of(context).pop();
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == RhRoutes.rhPerformence,
        //     icon: Icons.multiline_chart_sharp,
        //     sizeIcon: 20.0,
        //     title: 'Performences',
        //     style: bodyText1,
        //     onTap: () {
        //       Navigator.pushNamed(context, RhRoutes.rhPerformence);
        //     }),
        // DrawerWidget(
        //     selected: widget.pageCurrente == ArchiveRoutes.archives,
        //     icon: Icons.archive,
        //     sizeIcon: 20.0,
        //     title: 'Archives',
        //     style: bodyLarge!,
        //     onTap: () {
        //       Navigator.pushNamed(context, ArchiveRoutes.archives);
        //       // Navigator.of(context).pop();
        //     }),
      ],
    );
  }
}
