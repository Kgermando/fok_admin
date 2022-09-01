import 'dart:async';

import 'package:fokad_admin/src/pages/rh/paiements/plateforms/desktop/bulletin_salaire_desktop.dart';
import 'package:fokad_admin/src/pages/rh/paiements/plateforms/mobile/bulletin_salaire_mobile.dart';
import 'package:fokad_admin/src/pages/rh/paiements/plateforms/tablet/bulletin_salaire_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class PaiementBulletin extends StatefulWidget {
  const PaiementBulletin({Key? key}) : super(key: key);

  @override
  State<PaiementBulletin> createState() => _PaiementBulletinState();
}

class _PaiementBulletinState extends State<PaiementBulletin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<DepartementBudgetModel> departementsList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    if (!mounted) return;
    setState(() {
      user = userModel;
      departementsList = departements;
      ligneBudgetaireList = budgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      key: _key,
      drawer: const DrawerMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: DrawerMenu(),
            ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(p10),
              child: FutureBuilder<PaiementSalaireModel>(
                  future: PaiementSalaireApi().getOneData(id),
                  builder: (BuildContext context,
                      AsyncSnapshot<PaiementSalaireModel> snapshot) {
                    if (snapshot.hasData) {
                      PaiementSalaireModel? paiementSalaireModel =
                          snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (!Responsive.isMobile(context))
                                SizedBox(
                                  width: p20,
                                  child: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back)),
                                ),
                              const SizedBox(width: p10),
                              Expanded(
                                  child: CustomAppbar(
                                      title: (Responsive.isDesktop(context))
                                          ? "Ressources Humaines"
                                          : "RH",
                                      controllerMenu: () =>
                                          _key.currentState!.openDrawer())),
                            ],
                          ),
                          Expanded(child:
                              LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth >= 1100) {
                              return BulletinSalaireDesktop(
                                  departementsList: departementsList,
                                  ligneBudgetaireList: ligneBudgetaireList,
                                  user: user,
                                  paiementSalaireModel: paiementSalaireModel!);
                            } else if (constraints.maxWidth < 1100 &&
                                constraints.maxWidth >= 650) {
                              return BulletinSalaireTablet(
                                  departementsList: departementsList,
                                  ligneBudgetaireList: ligneBudgetaireList,
                                  user: user,
                                  paiementSalaireModel: paiementSalaireModel!);
                            } else {
                              return BulletinSalaireMobile(
                                  departementsList: departementsList,
                                  ligneBudgetaireList: ligneBudgetaireList,
                                  user: user,
                                  paiementSalaireModel: paiementSalaireModel!);
                            }
                          }))
                        ],
                      );
                    } else {
                      return Center(child: loading());
                    }
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
