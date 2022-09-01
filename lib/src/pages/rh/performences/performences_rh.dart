import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/performences/components/table_performence.dart';

class PerformenceRH extends StatefulWidget {
  const PerformenceRH({Key? key}) : super(key: key);

  @override
  State<PerformenceRH> createState() => _PerformenceRHState();
}

class _PerformenceRHState extends State<PerformenceRH> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                          title: (Responsive.isDesktop(context))
                              ? "Ressources Humaines"
                              : "RH",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TablePerformence())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
