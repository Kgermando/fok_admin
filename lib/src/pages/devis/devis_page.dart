import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/devis/components/table_devis.dart';

class DevisPage extends StatefulWidget {
  const DevisPage({Key? key}) : super(key: key);

  @override
  State<DevisPage> createState() => _DevisPageState();
}

class _DevisPageState extends State<DevisPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Nouveau devis',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, DevisRoutes.devisAdd);
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
                      // const Expanded(child: TableDevis())
                      const Expanded(
                          child: TableDevis(departement: 'departement'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
