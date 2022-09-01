import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/table_anguin.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class AnguinAuto extends StatefulWidget {
  const AnguinAuto({Key? key}) : super(key: key);

  @override
  State<AnguinAuto> createState() => _AnguinAutoState();
}

class _AnguinAutoState extends State<AnguinAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: "Nouvel engin",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, LogistiqueRoutes.logAddAnguinAuto);
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
                      const Expanded(child: TableAnguin())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
