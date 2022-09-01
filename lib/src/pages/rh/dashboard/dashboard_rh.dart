import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/calendar_widget.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_pie_wdget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/dash_number_rh_widget.dart';
import 'package:intl/intl.dart';

class DashboardRh extends StatefulWidget {
  const DashboardRh({Key? key}) : super(key: key);

  @override
  State<DashboardRh> createState() => _DashboardRhState();
}

class _DashboardRhState extends State<DashboardRh> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  int agentsCount = 0;
  int agentActifCount = 0;
  int agentInactifCount = 0;
  int agentFemmeCount = 0;
  int agentHommeCount = 0;
  int agentNonPaye = 0;

  double totalEnveloppeSalaire = 0.0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<PaiementSalaireModel> salaireList = [];
  Future<void> getData() async {
    var agents = await AgentsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    setState(() {
      agentsCount = agents.length;
      agentActifCount =
          agents.where((element) => element.statutAgent == 'true').length;
      agentInactifCount =
          agents.where((element) => element.statutAgent == 'false').length;
      agentFemmeCount =
          agents.where((element) => element.sexe == 'Femme').length;
      agentHommeCount =
          agents.where((element) => element.sexe == 'Homme').length;
      agentNonPaye = salaires
          .where((element) =>
              element.observation == 'false' &&
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year)
          .length;

      salaireList = salaires
          .where((element) =>
              element.createdAt.month == DateTime.now().month &&
              element.createdAt.year == DateTime.now().year &&
              element.approbationDD == "Approved" &&
              element.approbationBudget == "Approved" &&
              element.approbationFin == "Approved" &&
              element.observation == "true")
          .toList();

      for (var element in salaireList) {
        totalEnveloppeSalaire += double.parse(element.salaire);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isMonth = '';
    final month = DateTime.now().month;

    if (month == 1) {
      isMonth = 'Janvier';
    } else if (month == 2) {
      isMonth = 'Fevrier';
    } else if (month == 3) {
      isMonth = 'Mars';
    } else if (month == 4) {
      isMonth = 'Avril';
    } else if (month == 5) {
      isMonth = 'Mai';
    } else if (month == 6) {
      isMonth = 'Juin';
    } else if (month == 7) {
      isMonth = 'Juillet';
    } else if (month == 8) {
      isMonth = 'Août';
    } else if (month == 9) {
      isMonth = 'Septembre';
    } else if (month == 10) {
      isMonth = 'Octobre';
    } else if (month == 11) {
      isMonth = 'Novembre';
    } else if (month == 12) {
      isMonth = 'Décembre';
    }

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
                              ? "Dashboard RH"
                              : "Dashboard",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhAgent);
                                    },
                                    number: '$agentsCount',
                                    title: 'Total agents',
                                    icon: Icons.group,
                                    color: Colors.blue.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhAgent);
                                    },
                                    number: '$agentActifCount',
                                    title: 'Agents Actifs',
                                    icon: Icons.person,
                                    color: Colors.green.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhAgent);
                                    },
                                    number: '$agentInactifCount',
                                    title: 'Agents inactifs',
                                    icon: Icons.person_off,
                                    color: Colors.red.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhAgent);
                                    },
                                    number: '$agentFemmeCount',
                                    title: 'Femmes',
                                    icon: Icons.female,
                                    color: Colors.purple.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhAgent);
                                    },
                                    number: '$agentHommeCount',
                                    title: 'Hommes',
                                    icon: Icons.male,
                                    color: Colors.grey.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhPaiement);
                                    },
                                    number:
                                        "${NumberFormat.decimalPattern('fr').format(totalEnveloppeSalaire)} \$",
                                    title: 'Enveloppe salariale',
                                    icon: Icons.monetization_on,
                                    color: Colors.teal.shade700),
                                DashNumberRHWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(
                                          context, RhRoutes.rhPaiement);
                                    },
                                    number: '$agentNonPaye',
                                    title: 'Non payés $isMonth',
                                    icon: Icons.person_remove,
                                    color: Colors.pink.shade700),
                              ],
                            ),
                            const SizedBox(height: p20),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: const [
                                DashRHPieWidget(),
                                CalendarWidget()
                              ],
                            )
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
