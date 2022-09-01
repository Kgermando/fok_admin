import 'dart:async';

import 'package:fokad_admin/src/pages/rh/dd_rh/components/presences/table_presence_dd.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/rh/salaires_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/rh/trans_rest_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/salaires/table_salaires_dd.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/transport_restauration/table_transport_restaurant_dd.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/users/table_users.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class DepartementRH extends StatefulWidget {
  const DepartementRH({Key? key}) : super(key: key);

  @override
  State<DepartementRH> createState() => _DepartementRHState();
}

class _DepartementRHState extends State<DepartementRH> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isOpen1 = false;
  bool isOpen2 = false;
  bool isOpen3 = false;

  int salairesCount = 0;
  int transRestCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    // RH
    var salaires = await SalaireNotifyApi().getCountDD();
    var transRests = await TransRestNotifyApi().getCountDD();

    setState(() {
      salairesCount = salaires.count;
      transRestCount = transRests.count;
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
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.brown.shade700,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, RhRoutes.rhHistoriqueSalaire);
            },
            label: Row(
              children: const [
                Icon(Icons.history),
                SizedBox(width: p10),
                Text("Voir Historique"),
              ],
            )),
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
                          title: (Responsive.isDesktop(context))
                              ? "Ressources Humaines"
                              : "RH",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.red.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Salaires',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $salairesCount dossiers necessitant votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen1 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableSalairesDD()],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text(
                                    'Dossier Transports & Restaurations',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $transRestCount dossiers necessitant votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen2 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableTansportRestaurantDD()],
                              ),
                            ),
                            Card(
                              color: Colors.purple.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier presence',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen3 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TablePresenceDD()],
                              ),
                            ),
                            Card(
                              color: Colors.green.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier utilisateurs actifs',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen3 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [TableUsers()],
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
