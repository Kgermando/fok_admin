import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/departements/comm_marketing_departement.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_widget.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class ComMarketing extends StatefulWidget {
  const ComMarketing({Key? key, required this.pageCurrente, required this.user})
      : super(key: key);
  final String pageCurrente;
  final UserModel user;

  @override
  State<ComMarketing> createState() => _ComMarketingState();
}

class _ComMarketingState extends State<ComMarketing> {
  bool isOpenComMarketing1 = false;
  bool isOpenComMarketing2 = false;

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
    var notify =
        await ComMarketingDepartementNotifyApi().getCountComMarketing();
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
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    int userRole = int.parse(widget.user.role);
    return ExpansionTile(
      leading: const Icon(Icons.store, size: 30.0),
      title: AutoSizeText('Comm. & Marketing', maxLines: 1, style: bodyLarge),
      initiallyExpanded:
          (widget.user.departement == 'Commercial et Marketing') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenComMarketing1 = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 2)
          DrawerWidget(
              selected: widget.pageCurrente ==
                  ComMarketingRoutes.comMarketingDashboard,
              icon: Icons.dashboard,
              sizeIcon: 20.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(
                    context, ComMarketingRoutes.comMarketingDashboard);
                // Navigator.of(context).pop();
              }),
        if (userRole <= 2)
          DrawerWidget(
              selected:
                  widget.pageCurrente == ComMarketingRoutes.comMarketingDD,
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
                Navigator.pushNamed(context, ComMarketingRoutes.comMarketingDD);
                // Navigator.of(context).pop();
              }),
        ExpansionTile(
          leading: const Icon(Icons.visibility, size: 20.0),
          title: Text('Marketing', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenComMarketing2 = !val;
            });
          },
          children: [
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingAnnuaire,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Annuaire',
                style: bodyText2!,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingAnnuaire);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingAgenda,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Agenda',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingAgenda);
                  // Navigator.of(context).pop();
                }),
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingCampaign,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Campagnes',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingCampaign);
                    // Navigator.of(context).pop();
                  }),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.store, size: 20.0),
          title: Text('Commercial', style: bodyText1),
          initiallyExpanded: false,
          onExpansionChanged: (val) {
            setState(() {
              isOpenComMarketing2 = !val;
            });
          },
          children: [
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingSuccursale,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Succursale',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingSuccursale);
                    // Navigator.of(context).pop();
                  }),
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingProduitModel,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Produit modèle',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingProduitModel);
                    // Navigator.of(context).pop();
                  }),
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingStockGlobal,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Stocks global',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingStockGlobal);
                    // Navigator.of(context).pop();
                  }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == ComMarketingRoutes.comMarketingAchat,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Achats',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingAchat);
                  // Navigator.of(context).pop();
                }),
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingBonLivraison,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Bon de livraison',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingBonLivraison);
                    // Navigator.of(context).pop();
                  }),
            if (userRole <= 3)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingRestitution,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Restitution du produit',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ComMarketingRoutes.comMarketingRestitution);
                    // Navigator.of(context).pop();
                  }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingFacture,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Factures',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingFacture);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected: widget.pageCurrente ==
                    ComMarketingRoutes.comMarketingCreance,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Factures créance',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingCreance);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == ComMarketingRoutes.comMarketingVente,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Ventes',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingVente);
                  // Navigator.of(context).pop();
                }),
            DrawerWidget(
                selected:
                    widget.pageCurrente == ComMarketingRoutes.comMarketingcart,
                icon: Icons.arrow_right,
                sizeIcon: 15.0,
                title: 'Panier',
                style: bodyText2,
                onTap: () {
                  Navigator.pushNamed(
                      context, ComMarketingRoutes.comMarketingcart);
                  // Navigator.of(context).pop();
                }),
            if (userRole <= 2)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingHistoryRavitaillement,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Historique de ravitaillement',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(context,
                        ComMarketingRoutes.comMarketingHistoryRavitaillement);
                    // Navigator.of(context).pop();
                  }),
            if (userRole <= 2)
              DrawerWidget(
                  selected: widget.pageCurrente ==
                      ComMarketingRoutes.comMarketingHistoryLivraison,
                  icon: Icons.arrow_right,
                  sizeIcon: 15.0,
                  title: 'Historique de livraison',
                  style: bodyText2,
                  onTap: () {
                    Navigator.pushNamed(context,
                        ComMarketingRoutes.comMarketingHistoryLivraison);
                    // Navigator.of(context).pop();
                  }),
          ],
        ),
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.pageCurrente == RhRoutes.rhPerformence,
              icon: Icons.multiline_chart_sharp,
              sizeIcon: 20.0,
              title: 'Performences',
              style: bodyText1!,
              onTap: () {
                Navigator.pushNamed(context, RhRoutes.rhPerformence);
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
