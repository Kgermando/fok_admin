import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/dash_number_budget_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DashboardBudget extends StatefulWidget {
  const DashboardBudget({Key? key}) : super(key: key);

  @override
  State<DashboardBudget> createState() => _DashboardBudgetState();
}

class _DashboardBudgetState extends State<DashboardBudget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final ScrollController controllerTable = ScrollController();

  double coutTotal = 0.0;
  double sommeEnCours = 0.0; // cest la somme des 4 departements
  double sommeRestantes =
      0.0; // la somme restante apres la soustration entre coutTotal - sommeEnCours
  double poursentExecution = 0;

  // Total par departements
  double totalCampaign = 0.0;
  double totalProjet = 0.0;
  double totalSalaire = 0.0;
  double totalDevis = 0.0;
  double totalTransRest = 0.0;

  // Campaigns
  double caisseCampaign = 0.0;
  double banqueCampaign = 0.0;
  double finExterieurCampaign = 0.0;
  // Etat de besoins
  double caisseEtatBesion = 0.0;
  double banqueEtatBesion = 0.0;
  double finExterieurEtatBesion = 0.0;
  // Exploitations
  double caisseProjet = 0.0;
  double banqueProjet = 0.0;
  double finExterieurProjet = 0.0;
  // Salaires
  double caisseSalaire = 0.0;
  double banqueSalaire = 0.0;
  double finExterieurSalaire = 0.0;
  // Transports & Restaurations
  double caisseTransRest = 0.0;
  double banqueTransRest = 0.0;
  double finExterieurTransRest = 0.0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<DepartementBudgetModel> departementsList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<DevisListObjetsModel> devisListObjetsList = []; // avec montant
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<TransportRestaurationModel> dataTransRestList = [];
  List<TransRestAgentsModel> tansRestList = []; // avec montant

  Future<void> getData() async {
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var transRests = await TransportRestaurationApi().getAllData();
    var devisListObjets = await DevisListObjetsApi().getAllData();
    var transRestAgents = await TransRestAgentsApi().getAllData();

    if (!mounted) return;
    setState(() {
      departementsList = departements;
      devisListObjetsList = devisListObjets;
      tansRestList = transRestAgents;

      for (var i in departementsList) {
        ligneBudgetaireList = budgets
            .where((element) =>
                element.periodeBudgetDebut.microsecondsSinceEpoch ==
                    i.periodeDebut.microsecondsSinceEpoch &&
                DateTime.now().isBefore(element.periodeBudgetFin) &&
                i.approbationDG == "Approved" &&
                i.approbationDD == "Approved")
            .toList();
      }

      for (var item in ligneBudgetaireList) {
        dataCampaignList = campaigns
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == 'Approved' &&
                element.observation == 'true' &&
                element.created.isBefore(item.periodeBudgetFin))
            .toList();
        dataDevisList = devis
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == 'Approved' &&
                element.observation == 'true' &&
                element.created.isBefore(item.periodeBudgetFin))
            .toList();
        dataProjetList = projets
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == 'Approved' &&
                element.observation == 'true' &&
                element.created.isBefore(item.periodeBudgetFin))
            .toList();
        dataSalaireList = salaires
            .where((element) =>
                element.createdAt.month == DateTime.now().month &&
                element.createdAt.year == DateTime.now().year &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == 'Approved' &&
                element.observation == 'true' &&
                element.createdAt.isBefore(item.periodeBudgetFin))
            .toList();
        dataTransRestList = transRests
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                element.approbationBudget == 'Approved' &&
                element.observation == 'true' &&
                element.created.isBefore(item.periodeBudgetFin))
            .toList();
      }
    });

    for (var item in ligneBudgetaireList) {
      coutTotal += double.parse(item.coutTotal);
    }

    for (var item in dataCampaignList) {
      totalCampaign += double.parse(item.coutCampaign);
    }
    for (var item in dataDevisList) {
      var devisCaisseList = devisListObjetsList
          .where((element) =>
              element.referenceDate.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        totalDevis += double.parse(element.montantGlobal);
      }
    }
    for (var item in dataProjetList) {
      totalProjet += double.parse(item.coutProjet);
    }
    for (var item in dataSalaireList) {
      totalSalaire += double.parse(item.salaire);
    }
    for (var item in dataTransRestList) {
      var devisCaisseList = tansRestList
          .where((element) =>
              element.reference.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        totalTransRest += double.parse(element.montant);
      }
    }
    // Sommes budgets
    sommeEnCours = totalCampaign +
        totalDevis +
        totalProjet +
        totalSalaire +
        totalTransRest;
    sommeRestantes = coutTotal - sommeEnCours;
    poursentExecution = sommeRestantes * 100 / coutTotal;

    // Caisse
    for (var item in dataCampaignList
        .where((element) => element.ressource == "caisse")
        .toList()) {
      caisseCampaign += double.parse(item.coutCampaign);
    }
    for (var item in dataDevisList.where((e) => e.ressource == "caisse")) {
      var devisCaisseList = devisListObjetsList
          .where((element) =>
              element.referenceDate.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        caisseEtatBesion += double.parse(element.montantGlobal);
      }
    }
    for (var item in dataProjetList
        .where((element) => element.ressource == "caisse")
        .toList()) {
      caisseProjet += double.parse(item.coutProjet);
    }
    for (var item in dataSalaireList
        .where((element) => element.ressource == "caisse")
        .toList()) {
      caisseSalaire += double.parse(item.salaire);
    }
    for (var item in dataTransRestList.where((e) => e.ressource == "caisse")) {
      var devisCaisseList = tansRestList
          .where((element) =>
              element.reference.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        caisseTransRest += double.parse(element.montant);
      }
    }

    // Banque
    for (var item in dataCampaignList
        .where((element) => element.ressource == "banque")
        .toList()) {
      banqueCampaign += double.parse(item.coutCampaign);
    }
    for (var item in dataDevisList.where((e) => e.ressource == "banque")) {
      var devisCaisseList = devisListObjetsList
          .where((element) =>
              element.referenceDate.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        banqueEtatBesion += double.parse(element.montantGlobal);
      }
    }
    for (var item in dataProjetList
        .where((element) => element.ressource == "banque")
        .toList()) {
      banqueProjet += double.parse(item.coutProjet);
    }
    for (var item in dataSalaireList
        .where((element) => element.ressource == "banque")
        .toList()) {
      banqueSalaire += double.parse(item.salaire);
    }
    for (var item in dataTransRestList.where((e) => e.ressource == "banque")) {
      var devisCaisseList = tansRestList
          .where((element) =>
              element.reference.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        banqueTransRest += double.parse(element.montant);
      }
    }

    // Fin Exterieur
    for (var item in dataCampaignList
        .where((element) => element.ressource == "finExterieur")
        .toList()) {
      finExterieurCampaign += double.parse(item.coutCampaign);
    }
    for (var item
        in dataDevisList.where((e) => e.ressource == "finExterieur")) {
      var devisCaisseList = devisListObjetsList
          .where((element) =>
              element.referenceDate.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        finExterieurEtatBesion += double.parse(element.montantGlobal);
      }
    }
    for (var item in dataProjetList
        .where((element) => element.ressource == "finExterieur")
        .toList()) {
      finExterieurProjet += double.parse(item.coutProjet);
    }
    for (var item in dataSalaireList
        .where((element) => element.ressource == "finExterieur")
        .toList()) {
      finExterieurSalaire += double.parse(item.salaire);
    }
    for (var item
        in dataTransRestList.where((e) => e.ressource == "finExterieur")) {
      var devisCaisseList = tansRestList
          .where((element) =>
              element.reference.microsecondsSinceEpoch ==
              item.createdRef.microsecondsSinceEpoch)
          .toList();
      for (var element in devisCaisseList) {
        finExterieurTransRest += double.parse(element.montant);
      }
    }
  }

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
                          title: Responsive.isDesktop(context)
                              ? 'Dashboard Budgets'
                              : 'Dashboard',
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
                                DashNumberBudgetWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          BudgetRoutes.budgetBudgetPrevisionel);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(coutTotal)} \$',
                                    title: "Coût Total prévisionnel",
                                    icon: Icons.monetization_on,
                                    color: Colors.blue.shade700),
                                DashNumberBudgetWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          BudgetRoutes.budgetBudgetPrevisionel);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sommeEnCours)} \$',
                                    title: "Sommes en cours d'execution",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.pink.shade700),
                                DashNumberBudgetWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          BudgetRoutes.budgetBudgetPrevisionel);
                                    },
                                    number:
                                        '${NumberFormat.decimalPattern('fr').format(sommeRestantes)} \$',
                                    title: "Sommes restantes",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.red.shade700),
                                DashNumberBudgetWidget(
                                    gestureTapCallback: () {
                                      Navigator.pushNamed(context,
                                          BudgetRoutes.budgetBudgetPrevisionel);
                                    },
                                    number:
                                        "${NumberFormat.decimalPattern('fr').format(double.parse(poursentExecution.toStringAsFixed(0)))} %",
                                    title: "Taux d'executions",
                                    icon: Icons.monetization_on_outlined,
                                    color: Colors.green.shade700),
                              ],
                            ),
                            const SizedBox(height: p30),
                            const TitleWidget(title: "Tableau de dépenses"),
                            const SizedBox(height: p10),
                            if (!Responsive.isMobile(context))
                              Table(
                                children: <TableRow>[
                                  tableDepartement(),
                                  tableCellRHSalaire(),
                                  tableCellRHTransRest(),
                                  tableCellExploitation(),
                                  tableCellEtatBesoin(),
                                  tableCellMarketing()
                                ],
                              ),
                            if (Responsive.isMobile(context))
                              Scrollbar(
                                controller: controllerTable,
                                child: SingleChildScrollView(
                                  controller: controllerTable,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                2),
                                    child: Table(
                                      children: <TableRow>[
                                        tableDepartement(),
                                        tableCellRHSalaire(),
                                        tableCellRHTransRest(),
                                        tableCellExploitation(),
                                        tableCellEtatBesoin(),
                                        tableCellMarketing()
                                      ],
                                    ),
                                  ),
                                ),
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

  TableRow tableDepartement() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: mainColor,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "DEPENSES",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration: BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "Coût Total".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration: BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "Caisse".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration: BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "Banque".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration: BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "Reste à trouver".toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellRHSalaire() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.red.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Salaire",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.red.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalSalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.red.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseSalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.red.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueSalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.red.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurSalaire)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellRHTransRest() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.blue.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Transport & Restauration",
            maxLines: 3,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalTransRest)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseTransRest)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueTransRest)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurTransRest)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellExploitation() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.grey.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Exploitations",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurProjet)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellEtatBesoin() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.purple.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Etat de besoin",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalDevis)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseEtatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueEtatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.purple.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.purple.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurEtatBesion)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }

  TableRow tableCellMarketing() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return TableRow(children: [
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          color: Colors.orange.shade700,
          padding: const EdgeInsets.all(16.0 * 0.75),
          child: AutoSizeText(
            "Marketing",
            maxLines: 1,
            style: headline6!.copyWith(color: Colors.white),
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(totalCampaign)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(caisseCampaign)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(banqueCampaign)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
      Card(
        elevation: 10.0,
        shadowColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300,
          height: 50,
          padding: const EdgeInsets.all(16.0 * 0.75),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.orange.shade700)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(finExterieurCampaign)} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: headline6,
          ),
        ),
      ),
    ]);
  }
}
