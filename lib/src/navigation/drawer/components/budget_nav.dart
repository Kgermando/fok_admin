import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/departements/budget_departement.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class BudgetNav extends StatefulWidget {
  const BudgetNav({Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  State<BudgetNav> createState() => _BudgetNavState();
}

class _BudgetNavState extends State<BudgetNav> {
  bool isOpenBudget = false;

  int itemCount = 0;

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
    var notify = await BudgetDepartementNotifyApi().getCountBudget();
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
      leading: const Icon(Icons.fact_check, size: 30.0),
      title: AutoSizeText('Budgets', maxLines: 1, style: bodyLarge),
      initiallyExpanded: (widget.user.departement == 'Budgets') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenBudget = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente == BudgetRoutes.budgetDashboard,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, BudgetRoutes.budgetDashboard);
                // Navigator.of(context).pop();
              }),
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente == BudgetRoutes.budgetDD,
              icon: Icons.manage_accounts,
              sizeIcon: 20.0,
              title: 'Directeur de departement',
              style: bodyText1!,
              badge: Badge(
                showBadge: (itemCount >= 1) ? true : false,
                badgeColor: Colors.teal,
                badgeContent: Text('$itemCount',
                    style:
                        const TextStyle(fontSize: 10.0, color: Colors.white)),
                child: const Icon(Icons.notifications),
              ),
              onTap: () {
                Navigator.pushNamed(context, BudgetRoutes.budgetDD);
                // Navigator.of(context).pop();
              }),
        DrawerWidget(
            selected:
                widget.pageCurrente == BudgetRoutes.budgetBudgetPrevisionel,
            icon: Icons.wallet_giftcard,
            sizeIcon: 20.0,
            title: 'Budgets previsonels',
            style: bodyText1!,
            onTap: () {
              Navigator.pushNamed(
                  context, BudgetRoutes.budgetBudgetPrevisionel);
              // Navigator.of(context).pop();
            }),
        DrawerWidget(
            selected: widget.pageCurrente ==
                BudgetRoutes.historiqueBudgetBudgetPrevisionel,
            icon: Icons.history_sharp,
            sizeIcon: 20.0,
            title: 'Historique Budgetaires',
            style: bodyText1,
            onTap: () {
              Navigator.pushNamed(
                  context, BudgetRoutes.historiqueBudgetBudgetPrevisionel);
              // Navigator.of(context).pop();
            }),
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
