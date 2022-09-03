import 'dart:async';

import 'package:fokad_admin/src/api/administration/actionnaire_cotisation_api.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/finances/banque_api.dart';
import 'package:fokad_admin/src/api/finances/caisse_api.dart';
import 'package:fokad_admin/src/api/finances/creance_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/banque_model.dart';
import 'package:fokad_admin/src/models/finances/caisse_model.dart';
import 'package:fokad_admin/src/models/finances/creances_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/banque/courbe_banque_mounth.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/banque/courbe_banque_year.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/caisse/courbe_caisse_mounth.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/components/caisse/courbe_caisse_year.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/widgets/dashboard_card_widget.dart';

class DashboardFinance extends StatefulWidget {
  const DashboardFinance({Key? key}) : super(key: key);

  @override
  State<DashboardFinance> createState() => _DashboardFinanceState();
}

class _DashboardFinanceState extends State<DashboardFinance> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final scrollController = ScrollController();

  // Banque
  double recetteBanque = 0.0;
  double depensesBanque = 0.0;
  double soldeBanque = 0.0;

  // Caisse
  double recetteCaisse = 0.0;
  double depensesCaisse = 0.0;
  double soldeCaisse = 0.0;

  // Creance
  double nonPayesCreance = 0.0;
  double creancePaiement = 0.0;
  double soldeCreance = 0.0;

  // Dette
  double nonPayesDette = 0.0;
  double detteRemboursement = 0.0;
  double soldeDette = 0.0;

  // FinanceExterieur
  double cumulFinanceExterieur = 0.0;
  double actionnaire = 0.0;
  double recetteFinanceExterieur = 0.0;
  double depenseFinanceExterieur = 0.0;
  double soldeFinExterieur = 0.0;

  // Depenses
  double depenses = 0.0;

  // Disponible
  double disponible = 0.0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    List<BanqueModel?> dataBanqueList = await BanqueApi().getAllData();
    List<CaisseModel?> dataCaisseList = await CaisseApi().getAllData();
    List<CreanceModel?> dataCreanceList = await CreanceApi().getAllData();
    List<DetteModel?> dataDetteList = await DetteApi().getAllData();
    var creanceDettes = await CreanceDetteApi().getAllData();
    var dataFinanceExterieurList = await FinExterieurApi().getAllData();
    var actionnaireCotisationList =
        await ActionnaireCotisationApi().getAllData();

    if (mounted) {
      setState(() {
        // Banque
        List<BanqueModel?> recetteBanqueList = dataBanqueList
            .where((element) => element!.typeOperation == "Depot")
            .toList();
        List<BanqueModel?> depensesBanqueList = dataBanqueList
            .where((element) => element!.typeOperation == "Retrait")
            .toList();
        for (var item in recetteBanqueList) {
          recetteBanque += double.parse(item!.montant);
        }
        for (var item in depensesBanqueList) {
          depensesBanque += double.parse(item!.montant);
        }
        // Caisse
        List<CaisseModel?> recetteCaisseList = dataCaisseList
            .where((element) => element!.typeOperation == "Encaissement")
            .toList();
        List<CaisseModel?> depensesCaisseList = dataCaisseList
            .where((element) => element!.typeOperation == "Decaissement")
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

        List<CreanceModel?> nonPayeCreanceList = dataCreanceList
            .where((element) =>
                element!.statutPaie == 'false' &&
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .toList();

        for (var item in nonPayeCreanceList) {
          nonPayesCreance += double.parse(item!.montant);
        }
        for (var item in creancePaiementList) {
          creancePaiement += double.parse(item.montant);
        }

        // Dette remboursement
        var detteRemboursementList =
            creanceDettes.where((element) => element.creanceDette == 'dettes');
        List<DetteModel?> nonPayeDetteList = dataDetteList
            .where((element) =>
                element!.statutPaie == 'false' &&
                element.approbationDG == 'Approved' &&
                element.approbationDD == 'Approved')
            .toList();
        for (var item in nonPayeDetteList) {
          nonPayesDette += double.parse(item!.montant);
        }
        for (var item in detteRemboursementList) {
          detteRemboursement += double.parse(item.montant);
        }

        // Fin interne
        for (var item in actionnaireCotisationList) {
          actionnaire += double.parse(item.montant);
        }

        // FinanceExterieur
        List<FinanceExterieurModel?> recetteFinExtList =
            dataFinanceExterieurList
                .where((element) => element.typeOperation == "Depot")
                .toList();

        for (var item in recetteFinExtList) {
          recetteFinanceExterieur += double.parse(item!.montant);
        }
        List<FinanceExterieurModel?> depenseFinExtList =
            dataFinanceExterieurList
                .where((element) => element.typeOperation == "Depot")
                .toList();
        for (var item in depenseFinExtList) {
          depenseFinanceExterieur += double.parse(item!.montant);
        }

        soldeCreance = nonPayesCreance - creancePaiement;
        soldeDette = nonPayesDette - detteRemboursement;

        soldeBanque = recetteBanque - depensesBanque;
        soldeCaisse = recetteCaisse - depensesCaisse;
        soldeFinExterieur = recetteFinanceExterieur - depenseFinanceExterieur;

        cumulFinanceExterieur = actionnaire + soldeFinExterieur;  
        depenses = depensesBanque + depensesCaisse + depenseFinanceExterieur;
        disponible = soldeBanque + soldeCaisse + cumulFinanceExterieur; // Montant disponible
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
                          title: (Responsive.isDesktop(context))
                              ? 'Dashboard Finance'
                              : 'Dashboard',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: ListView(
                        controller: scrollController,
                        children: [
                          const SizedBox(height: p10),
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: 12.0,
                            runSpacing: 12.0,
                            direction: Axis.horizontal,
                            children: [
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(context,
                                      FinanceRoutes.transactionsCaisse);
                                },
                                title: 'CAISSE',
                                icon: Icons.view_stream_outlined,
                                montant: '$soldeCaisse',
                                color: Colors.yellow.shade700,
                                colorText: Colors.black,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(context,
                                      FinanceRoutes.transactionsBanque);
                                },
                                title: 'BANQUE',
                                icon: Icons.business,
                                montant: '$soldeBanque',
                                color: Colors.green.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(context,
                                      FinanceRoutes.transactionsDettes);
                                },
                                title: 'DETTES',
                                icon: Icons.money_off,
                                montant: '$soldeDette',
                                color: Colors.red.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(context,
                                      FinanceRoutes.transactionsCreances);
                                },
                                title: 'CREANCES',
                                icon: Icons.money_off_csred,
                                montant: '$soldeCreance',
                                color: Colors.purple.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(
                                      context,
                                      FinanceRoutes
                                          .transactionsFinancementExterne);
                                },
                                title: 'ACTIONNAIRE',
                                icon: Icons.money_outlined,
                                montant: '$actionnaire',
                                color: Colors.teal.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {
                                  Navigator.pushNamed(
                                      context,
                                      FinanceRoutes
                                          .transactionsFinancementExterne);
                                },
                                title: 'FIN. EXTERNE',
                                icon: Icons.money_outlined,
                                montant: '$cumulFinanceExterieur',
                                color: Colors.grey.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {},
                                title: 'DEPENSES',
                                icon: Icons.monetization_on,
                                montant: '$depenses',
                                color: Colors.orange.shade700,
                                colorText: Colors.white,
                              ),
                              DashboardCardWidget(
                                gestureTapCallback: () {},
                                title: 'DIPONIBLES',
                                icon: Icons.attach_money,
                                montant: '$disponible',
                                color: Colors.blue.shade700,
                                colorText: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(child: CourbeCaisseMounth()),
                                    Expanded(child: CourbeCaisseYear()),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    CourbeCaisseMounth(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    CourbeCaisseYear(),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Responsive.isDesktop(context)
                              ? Row(
                                  children: const [
                                    Expanded(child: CourbeBanqueMounth()),
                                    Expanded(child: CourbeBanqueYear()),
                                  ],
                                )
                              : Column(
                                  children: const [
                                    CourbeBanqueMounth(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    CourbeBanqueYear(),
                                  ],
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          // Responsive.isDesktop(context)
                          //     ? Row(
                          //         children: const [
                          //           Expanded(child: DeviePieDepMounth()),
                          //           Expanded(child: DeviePieDepYear()),
                          //         ],
                          //       )
                          //     : Column(
                          //         children: const [
                          //           DeviePieDepMounth(),
                          //           SizedBox(
                          //             height: 20.0,
                          //           ),
                          //           DeviePieDepYear(),
                          //         ],
                          //       ),
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
