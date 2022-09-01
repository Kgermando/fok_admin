import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/devis/devis_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/carburant_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/engin_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/entretien_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/etat_materiel_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/immobilier_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/mobilier_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/logistique/trajet_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_anguin_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_carburant_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_entretien_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_etat_besoin_log.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_etat_materiels_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_immobilier_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_mobilier_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/components/table_trajet_dd.dart';

class LogDD extends StatefulWidget {
  const LogDD({Key? key}) : super(key: key);

  @override
  State<LogDD> createState() => _LogDDState();
}

class _LogDDState extends State<LogDD> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpenLog1 = false;
  bool isOpenLog2 = false;
  bool isOpenLog3 = false;
  bool isOpenLog4 = false;
  bool isOpenLog5 = false;
  bool isOpenLog6 = false;
  bool isOpenLog7 = false;
  bool isOpenLog8 = false;

  int anguinsCount = 0;
  int carburantCount = 0;
  int trajetsCount = 0;
  int immobiliersCount = 0;
  int mobiliersCount = 0;
  int entretiensCount = 0;
  int etatmaterielsCount = 0;
  int etatBesoinCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var anguins = await EnginNotifyApi().getCountDD();
    var carburants = await CarburantNotifyApi().getCountDD();
    var trajets = await TrajetNotifyApi().getCountDD();
    var immobiliers = await ImmobilierNotifyApi().getCountDD();
    var mobiliers = await MobilierNotifyApi().getCountDD();
    var entretiens = await EntretienNotifyApi().getCountDD();
    var etatmateriels = await EtatMaterielNotifyApi().getCountDD();
    var devis = await DevisNotifyApi().getCountDD();

    setState(() {
      anguinsCount = anguins.count;
      carburantCount = carburants.count;
      trajetsCount = trajets.count;
      immobiliersCount = immobiliers.count;
      mobiliersCount = mobiliers.count;
      entretiensCount = entretiens.count;
      etatmaterielsCount = etatmateriels.count;
      etatBesoinCount = devis.count;
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
                          title: Responsive.isDesktop(context)
                              ? 'Département Logistique'
                              : 'Logistique',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier engins',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $anguinsCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableAnguinDD()],
                              ),
                            ),
                            Card(
                              color: Colors.orange.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Carburants',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $carburantCount dossiers necessitent votre approbation",
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
                                children: const [TableCarburantDD()],
                              ),
                            ),
                            Card(
                              color: Colors.teal.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Trajets',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $trajetsCount dossiers necessitent votre approbation",
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
                                children: const [TableTrajetDD()],
                              ),
                            ),
                            Card(
                              color: Colors.lime.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Immobiliers',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $immobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog4 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableImmobilierDD()],
                              ),
                            ),
                            Card(
                              color: Colors.blueGrey,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Mobiliers',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $mobiliersCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog5 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableMobilierDD()],
                              ),
                            ),
                            Card(
                              color: Colors.brown.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier maintenances',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $entretiensCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog6 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableEntretienDD()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Etat de materiels',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $etatmaterielsCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog7 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableEtatMaterielDD()],
                              ),
                            ),
                            Card(
                              color: Colors.purple.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Etat de besoins',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $etatBesoinCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenLog8 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableEtatBesoinDD()],
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
