import 'package:fokad_admin/src/pages/actionnaires/components/table_actionnaire.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class ActionnairesPage extends StatefulWidget {
  const ActionnairesPage({Key? key}) : super(key: key);

  @override
  State<ActionnairesPage> createState() => _ActionnairesPageState();
}

class _ActionnairesPageState extends State<ActionnairesPage> {
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
                          title: Responsive.isMobile(context)
                              ? "Actionnaires"
                              : 'Actionnaires FOKAD',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableActionnaire())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
