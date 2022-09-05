import 'dart:async';

import 'package:fokad_admin/src/api/administration/actionnaire_cotisation_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_livre_api.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/campaign_api.dart';
import 'package:fokad_admin/src/api/comptabilite/bilan_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/api/exploitations/projets_api.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
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
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_mounth.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/components/courbe_vente_gain_year.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/components/dash_pie_wdget.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/dash_number_widget.dart';
import 'package:intl/intl.dart';

class DashboardAdministration extends StatefulWidget {
  const DashboardAdministration({Key? key}) : super(key: key);

  @override
  State<DashboardAdministration> createState() =>
      _DashboardAdministrationState();
}

class _DashboardAdministrationState extends State<DashboardAdministration> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // RH
  int agentsCount = 0;
  int agentActifCount = 0;

  // Budgets
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

  // Comptabilite
  int bilanCount = 0;
  int journalCount = 0;

  // Finance
  double depenses = 0.0;
  double disponible = 0.0;
  double recetteBanque = 0.0;
  double depensesBanque = 0.0;
  double soldeBanque = 0.0;
  double recetteCaisse = 0.0;
  double depensesCaisse = 0.0;
  double soldeCaisse = 0.0;
  double nonPayesCreance = 0.0;
  double creancePaiement = 0.0;
  double soldeCreance = 0.0;
  double nonPayesDette = 0.0;
  double detteRemboursement = 0.0;
  double soldeDette = 0.0;
  double cumulFinanceExterieur = 0.0;
  double actionnaire = 0.0;
  double recetteFinanceExterieur = 0.0;
  double depenseFinanceExterieur = 0.0;
  double soldeFinExterieur = 0.0;

  // Exploitations
  int projetsApprouveCount = 0;

  // Campaigns
  int campaignCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  List<CampaignModel> dataCampaignList = [];
  List<DevisModel> dataDevisList = [];
  List<DevisListObjetsModel> devisListObjetsList = []; // avec montant
  List<ProjetModel> dataProjetList = [];
  List<PaiementSalaireModel> dataSalaireList = [];
  List<TransportRestaurationModel> dataTransRestList = [];
  List<TransRestAgentsModel> tansRestList = []; // avec montant
  List<DepartementBudgetModel> departementsList = [];

  Future<void> getData() async {
    // RH
    var agents = await AgentsApi().getAllData();

    // Budgets
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    var campaigns = await CampaignApi().getAllData();
    var devis = await DevisAPi().getAllData();
    var projets = await ProjetsApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    var transRests = await TransportRestaurationApi().getAllData();
    var devisListObjets = await DevisListObjetsApi().getAllData();
    var transRestAgents = await TransRestAgentsApi().getAllData();

    // Comptabilite
    var bilans = await BilanApi().getAllData();
    var journals = await JournalLivreApi().getAllData();

    // Finances
    var dataBanqueList = await BanqueApi().getAllData();
    var dataCaisseList = await CaisseApi().getAllData();
    var dataCreanceList = await CreanceApi().getAllData();
    var dataDetteList = await DetteApi().getAllData();
    var creanceDettes = await CreanceDetteApi().getAllData();
    var dataFinanceExterieurList = await FinExterieurApi().getAllData();
    var actionnaireCotisationList =
        await ActionnaireCotisationApi().getAllData();

    if (mounted) {
      setState(() {
        agentsCount = agents.length;
        agentActifCount =
            agents.where((element) => element.statutAgent == 'true').length;

        // Exploitations
        projetsApprouveCount = projets
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .length;

        // Comm & Marketing
        campaignCount = campaigns
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .length;

        // Budgets
        devisListObjetsList = devisListObjets;
        tansRestList = transRestAgents;
        departementsList = departements
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved' &&
                DateTime.now().isBefore(element.periodeFin))
            .toList();

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

        // Comptabilite
        bilanCount = bilans
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .length;
        journalCount = journals
            .where((element) =>
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .length;

        // FINANCE
        // Banque
        List<BanqueModel?> recetteBanqueList = dataBanqueList
            .where((element) => element.typeOperation == "Depot")
            .toList();
        List<BanqueModel?> depensesBanqueList = dataBanqueList
            .where((element) => element.typeOperation == "Retrait")
            .toList();
        for (var item in recetteBanqueList) {
          recetteBanque += double.parse(item!.montant);
        }
        for (var item in depensesBanqueList) {
          depensesBanque += double.parse(item!.montant);
        }
        // Caisse
        List<CaisseModel?> recetteCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Encaissement")
            .toList();
        List<CaisseModel?> depensesCaisseList = dataCaisseList
            .where((element) => element.typeOperation == "Decaissement")
            .toList();
        for (var item in recetteCaisseList) {
          recetteCaisse += double.parse(item!.montant);
        }
        for (var item in depensesCaisseList) {
          depensesCaisse += double.parse(item!.montant);
        }

        // Creance remboursement
        var creancePaiementList = creanceDettes
            .where((element) => element.creanceDette == 'creances');

        List<CreanceModel> nonPayeCreanceList = dataCreanceList
            .where((element) =>
                element.statutPaie == 'false' &&
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .toList();

        for (var item in nonPayeCreanceList) {
          nonPayesCreance += double.parse(item.montant);
        }
        for (var item in creancePaiementList) {
          creancePaiement += double.parse(item.montant);
        }

        // Dette paiement
        var detteRemboursementList =
            creanceDettes.where((element) => element.creanceDette == 'dettes');
        List<DetteModel?> nonPayeDetteList = dataDetteList
            .where((element) =>
                element.statutPaie == 'false' &&
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .toList();
        for (var item in nonPayeDetteList) {
          nonPayesDette += double.parse(item!.montant);
        }
        for (var item in detteRemboursementList) {
          detteRemboursement += double.parse(item.montant);
        }

        // Fin interne actionnaire
        for (var item in actionnaireCotisationList) {
          actionnaire += double.parse(item.montant);
        }

        // FinanceExterieur
        var recetteFinExtList = dataFinanceExterieurList
            .where((element) => element.typeOperation == "Depot")
            .toList();

        for (var item in recetteFinExtList) {
          recetteFinanceExterieur += double.parse(item.montant);
        }
        var depenseFinExtList = dataFinanceExterieurList
            .where((element) => element.typeOperation == "Retrait")
            .toList();
        for (var item in depenseFinExtList) {
          depenseFinanceExterieur += double.parse(item.montant);
        }

        soldeCreance = nonPayesCreance - creancePaiement;
        soldeDette = nonPayesDette - detteRemboursement;

        soldeBanque = recetteBanque - depensesBanque;
        soldeCaisse = recetteCaisse - depensesCaisse;
        soldeFinExterieur = recetteFinanceExterieur - depenseFinanceExterieur;

        cumulFinanceExterieur = actionnaire + soldeFinExterieur;
        depenses = depensesBanque + depensesCaisse + depenseFinanceExterieur;
        disponible = soldeBanque + soldeCaisse + cumulFinanceExterieur;

        // Budget
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
      });
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
                          title: 'Tableau de bord',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: ListView(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(
                                        context, RhRoutes.rhAgent);
                                  },
                                  number: '$agentsCount',
                                  title: 'Total agents',
                                  icon: Icons.group,
                                  color: Colors.blue.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(
                                        context, RhRoutes.rhTableAgentActifs);
                                  },
                                  number: '$agentActifCount',
                                  title: 'Agent Actifs',
                                  icon: Icons.person,
                                  color: Colors.green.shade700),
                              // DashNumberWidget(
                              //     gestureTapCallback: () {
                              //       Navigator.pushNamed(
                              //           context, BudgetRoutes.budgetDashboard);
                              //     },
                              //     number:
                              //         "${NumberFormat.decimalPattern('fr').format(double.parse(poursentExecution.toStringAsFixed(0)))} %",
                              //     title: "Budgets",
                              //     icon: Icons.monetization_on_outlined,
                              //     color: Colors.purple.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(context,
                                        FinanceRoutes.transactionsDettes);
                                  },
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(soldeDette)} \$",
                                  title: 'Dette',
                                  icon: Icons.blur_linear_rounded,
                                  color: Colors.red.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(context,
                                        FinanceRoutes.transactionsCreances);
                                  },
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(soldeCreance)} \$",
                                  title: 'Créance',
                                  icon: Icons.money_off_csred,
                                  color: Colors.deepOrange.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(context,
                                        FinanceRoutes.financeDashboard);
                                  },
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(depenses)} \$",
                                  title: 'Dépenses',
                                  icon: Icons.monetization_on,
                                  color: Colors.pink.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(context,
                                        FinanceRoutes.financeDashboard);
                                  },
                                  number:
                                      "${NumberFormat.decimalPattern('fr').format(disponible)} \$",
                                  title: 'Disponible',
                                  icon: Icons.attach_money,
                                  color: Colors.teal.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(
                                        context,
                                        ComptabiliteRoutes
                                            .comptabiliteBilan);
                                  },
                                  number: '$bilanCount',
                                  title: 'Bilans',
                                  icon: Icons.blur_linear_rounded,
                                  color: Colors.blueGrey.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(
                                        context,
                                        ComptabiliteRoutes
                                            .comptabiliteJournalLivre);
                                  },
                                  number: '$journalCount',
                                  title: 'Journals',
                                  icon: Icons.backup_table,
                                  color: Colors.blueAccent.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(context,
                                        ExploitationRoutes.expProjet);
                                  },
                                  number: '$projetsApprouveCount',
                                  title: 'Projets approvés',
                                  icon: Icons.work,
                                  color: Colors.grey.shade700),
                              DashNumberWidget(
                                  gestureTapCallback: () {
                                    Navigator.pushNamed(
                                        context,
                                        ComMarketingRoutes
                                            .comMarketingDashboard);
                                  },
                                  number: '$campaignCount',
                                  title: 'Campagnes',
                                  icon: Icons.campaign,
                                  color: Colors.orange.shade700),
                            ],
                          ),
                          const SizedBox(height: p20),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(
                                        flex: 3,
                                        child: FlashCard(
                                            height: 400,
                                            width: double.infinity,
                                            frontWidget: CourbeVenteGainYear(),
                                            backWidget:
                                                CourbeVenteGainMounth())),
                                    Expanded(flex: 1, child: DashRHPieWidget())
                                  ],
                                )
                              : Column(
                                  children: const [
                                    FlashCard(
                                        height: 400,
                                        width: double.infinity,
                                        frontWidget: CourbeVenteGainYear(),
                                        backWidget: CourbeVenteGainMounth()),
                                    SizedBox(height: p20),
                                    DashRHPieWidget()
                                  ],
                                )
                        ],
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
