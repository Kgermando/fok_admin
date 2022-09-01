import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/budgets/budget_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/campaign_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/devis/devis_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/exploitations/projet_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/rh/salaires_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/rh/trans_rest_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_campaign_buget.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_departement_budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_devis_budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_projet_budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_salaire_budget.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/components/table_transport_restaurant_budget.dart';

class BudgetDD extends StatefulWidget {
  const BudgetDD({Key? key}) : super(key: key);

  @override
  State<BudgetDD> createState() => _BudgetDDState();
}

class _BudgetDDState extends State<BudgetDD> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpen1 = false;
  bool isOpen2 = false;
  bool isOpen3 = false;
  bool isOpen4 = false;
  bool isOpen5 = false;
  bool isOpen6 = false;

  int salaireCount = 0;
  int transRestCount = 0;
  int campaignCount = 0;
  int devisCount = 0;
  int projetCount = 0;
  int budgetDepCount = 0;

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> getData() async {
    var salairesCountNotify = await SalaireNotifyApi().getCountBudget();
    var transRestsCountNotify = await TransRestNotifyApi().getCountBudget();
    var campaignsCountNotify = await CampaignNotifyApi().getCountBudget();
    var devisCountNotify = await DevisNotifyApi().getCountBudget();
    var projetsCountNotify = await ProjetNotifyApi().getCountBudget();
    var budgetCountNotify = await BudgetNotifyApi().getCountDD();

    setState(() {
      salaireCount = salairesCountNotify.count;
      transRestCount = transRestsCountNotify.count;
      campaignCount = campaignsCountNotify.count;
      devisCount = devisCountNotify.count;
      projetCount = projetsCountNotify.count;
      budgetDepCount = budgetCountNotify.count;
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
                          title: Responsive.isMobile(context)
                              ? 'Budget'
                              : 'Département de Budget',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
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
                                    "Vous avez $salaireCount dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen1 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableSalairesBudget()],
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
                                    "Vous $transRestCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen6 = !val;
                                  });
                                },
                                trailing: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                children: const [
                                  TableTansportRestaurantBudget()
                                ],
                              ),
                            ),
                            Card(
                              color: Colors.yellow.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Campaigns',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $campaignCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen2 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableCampaignBudget()],
                              ),
                            ),
                            Card(
                              color: Colors.grey.shade700,
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
                                    "Vous avez $devisCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen3 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableDevisBudgetDD()],
                              ),
                            ),
                            Card(
                              color: Colors.blue.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Projets',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $projetCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen4 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableProjeBudget()],
                              ),
                            ),
                            Card(
                              color: Colors.green.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier budgets',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $budgetDepCount dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpen5 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableDepartementBudgetDD()],
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
