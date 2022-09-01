import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class AgentsRh extends StatefulWidget {
  const AgentsRh({Key? key}) : super(key: key);

  @override
  State<AgentsRh> createState() => _AgentsRhState();
}

class _AgentsRhState extends State<AgentsRh> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Nouveau profil",
          onPressed: () {
            Navigator.pushNamed(context, RhRoutes.rhAgentAdd);
          },
          child: const Icon(Icons.person_add),
        ),
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
                      const Expanded(child: TableAgents())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
