import 'dart:async';

import 'package:fokad_admin/src/api/notifications/devis/devis_notify_api.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_etat_besoin_departement.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/logistique/engin_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/immobilier_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_immobilier_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/logistiques/table_anguin_admin.dart';

class LogistiquesAdmin extends StatefulWidget {
  const LogistiquesAdmin({Key? key}) : super(key: key);

  @override
  State<LogistiquesAdmin> createState() => _LogistiquesAdminState();
}

class _LogistiquesAdminState extends State<LogistiquesAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenLog1 = false;
  bool isOpenLog2 = false;
  bool isOpenLog3 = false;

  int anguinsapprobationDD = 0;
  int immobiliersCount = 0;
  int devisCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var anguins = await EnginNotifyApi().getCountDG();
    var immobiliers = await ImmobilierNotifyApi().getCountDG();
    var devis = await DevisNotifyApi().getCountDG();
    setState(() {
      anguinsapprobationDD = anguins.count;
      immobiliersCount = immobiliers.count;
      devisCount = devis.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Logistique',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Engins',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $anguinsapprobationDD dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableAnguinDG()],
                              ),
                            ),
                            Card(
                              color: Colors.lime.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Immobiliers',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6.copyWith(
                                            color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $immobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableImmobilierDG()],
                              ),
                            ),
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier sur les états de besoin',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6.copyWith(
                                            color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $devisCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog3 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [
                                  TableEtatBesoinDepartement(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
