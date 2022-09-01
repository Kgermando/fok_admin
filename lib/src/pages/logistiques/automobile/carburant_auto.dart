import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_carburant.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class CarburantAuto extends StatefulWidget {
  const CarburantAuto({Key? key}) : super(key: key);

  @override
  State<CarburantAuto> createState() => _CarburantAutoState();
}

class _CarburantAutoState extends State<CarburantAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: "Ajout carburant",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                  context, LogistiqueRoutes.logAddCarburantAuto);
            }),
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
                      const Expanded(child: TableCarburant())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
