import 'package:fokad_admin/src/pages/comptabilite/balance/plateforms/desktop/balance_desktop.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/plateforms/mobile/balance_mobile.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/plateforms/tablet/balance_tablet.dart';
import 'package:fokad_admin/src/pages/comptabilite/plateforms/desktop/balance_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/comptabilite/plateforms/mobile/balance_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/comptabilite/plateforms/tablet/balance_approbation_tablet.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_balance_ref_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:flutter/services.dart';

class DetailBalance extends StatefulWidget {
  const DetailBalance({Key? key}) : super(key: key);

  @override
  State<DetailBalance> createState() => _DetailBalanceState();
}

class _DetailBalanceState extends State<DetailBalance> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String? comptesAllSelect;
  bool isLoadingDelete = false;
  bool isLoadingSend = false;

  String? comptes;
  TextEditingController montantDebitController = TextEditingController();
  TextEditingController montantCreditController = TextEditingController();
  bool statut = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    montantDebitController.dispose();
    montantCreditController.dispose();
    super.dispose();
  }

  List<CompteBalanceRefModel> compteBalanceRefList = [];
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
    var compteBalanceRef = await CompteBalanceRefApi().getAllData();
    setState(() {
      user = userModel;
      compteBalanceRefList = compteBalanceRef;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<BalanceCompteModel>(
            future: BalanceCompteApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<BalanceCompteModel> snapshot) {
              if (snapshot.hasData) {
                BalanceCompteModel? data = snapshot.data;
                return (data!.isSubmit == 'false' && data.approbationDD == '-')
                    ? FloatingActionButton.extended(
                        tooltip: "New écriture",
                        icon: const Icon(Icons.add),
                        label: const Text("Ecriture"),
                        onPressed: () {
                          newEcritureDialog(data);
                        })
                    : Container();
              } else {
                return loadingMini();
              }
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
                    child: FutureBuilder<BalanceCompteModel>(
                        future: BalanceCompteApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<BalanceCompteModel> snapshot) {
                          if (snapshot.hasData) {
                            BalanceCompteModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!Responsive.isMobile(context))
                                      SizedBox(
                                        width: p20,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.arrow_back)),
                                      ),
                                    if (!Responsive.isMobile(context))
                                      const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Comptabilités",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      LayoutBuilder(
                                          builder: (context, constraints) {
                                        if (constraints.maxWidth >= 1100) {
                                          return BalanceDesktop(
                                              user: user,
                                              compteBalanceRefList:
                                                  compteBalanceRefList,
                                              balanceCompteModel: data!);
                                        } else if (constraints.maxWidth <
                                                1100 &&
                                            constraints.maxWidth >= 650) {
                                          return BalanceTablet(
                                              user: user,
                                              compteBalanceRefList:
                                                  compteBalanceRefList,
                                              balanceCompteModel: data!);
                                        } else {
                                          return BalanceMobile(
                                              user: user,
                                              compteBalanceRefList:
                                                  compteBalanceRefList,
                                              balanceCompteModel: data!);
                                        }
                                      }),
                                      const SizedBox(height: p10),
                                      // LayoutBuilder(
                                      //     builder: (context, constraints) {
                                      //   if (constraints.maxWidth >= 1100) {
                                      //     return BalanceApprobationDesktop(
                                      //         user: user,
                                      //         balanceCompteModel: data!);
                                      //   } else if (constraints.maxWidth <
                                      //           1100 &&
                                      //       constraints.maxWidth >= 650) {
                                      //     return BalanceApprobationTablet(
                                      //         user: user,
                                      //         balanceCompteModel: data!);
                                      //   } else {
                                      //     return BalanceApprobationMobile(
                                      //         user: user,
                                      //         balanceCompteModel: data!);
                                      //   }
                                      // })
                                    ],
                                  ),
                                ))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  newEcritureDialog(BalanceCompteModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final formKey = GlobalKey<FormState>();
          bool isLoading = false;

          List<String> comptesList = [];
          final comptesDropdown = ComptesDropdown().classCompte;
          final class1Dropdown = ComptesDropdown().classe1compte;
          final class2Dropdown = ComptesDropdown().classe2compte;
          final class3Dropdown = ComptesDropdown().classe3compte;
          final class4Dropdown = ComptesDropdown().classe4compte;
          final class5Dropdown = ComptesDropdown().classe5compte;
          final class6Dropdown = ComptesDropdown().classe6compte;
          final class7Dropdown = ComptesDropdown().classe7compte;
          final class8Dropdown = ComptesDropdown().classe8compte;
          final class9Dropdown = ComptesDropdown().classe9compte;

          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('New document', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: Responsive.isMobile(context) ? 350 : 300,
                  width: Responsive.isMobile(context) ? 300 : 400,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Classe des comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptesAllSelect,
                                            isExpanded: true,
                                            items: comptesDropdown
                                                .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                })
                                                .toSet()
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                comptesAllSelect = value;
                                                comptesList.clear();
                                                switch (comptesAllSelect) {
                                                  case "Classe_1_Comptes_de_ressources_durables":
                                                    comptesList
                                                        .addAll(class1Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_2_Comptes_Actif_immobilise":
                                                    comptesList
                                                        .addAll(class2Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_3_Comptes_de_stocks":
                                                    comptesList
                                                        .addAll(class3Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_4_Comptes_de_tiers":
                                                    comptesList
                                                        .addAll(class4Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_5_Comptes_de_tresorerie":
                                                    comptesList
                                                        .addAll(class5Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_6_Comptes_de_charges_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class6Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_7_Comptes_de_produits_des_activites_ordinaires":
                                                    comptesList
                                                        .addAll(class7Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_8_Comptes_des_autres_charges_et_des_autres_produits":
                                                    comptesList
                                                        .addAll(class8Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  case "Classe_9_Comptes_des_engagements_hors_bilan_et_comptes_de_la_comptabilite_analytique_de_gestion":
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                    comptes = comptesList.first;
                                                    break;
                                                  default:
                                                    comptesList
                                                        .addAll(class9Dropdown);
                                                }
                                              });
                                            },
                                          ),
                                        )),
                                        const SizedBox(width: p10),
                                        Expanded(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: p20),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              labelText: 'Comptes',
                                              labelStyle: const TextStyle(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                            ),
                                            value: comptes,
                                            isExpanded: true,
                                            items: comptesList
                                                .map((String? value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value!),
                                              );
                                            }).toList(),
                                            validator: (value) => value == null
                                                ? "Select compte"
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                comptes = value!;
                                              });
                                            },
                                          ),
                                        )),
                                      ],
                                    ),
                              debit(),
                              credit(),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    final form = formKey.currentState!;
                    if (form.validate()) {
                      submit(data).then((value) => isLoading = false);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget debit() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantDebitController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Débit \$',
          ),
        ));
  }

  Widget credit() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: montantCreditController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: ' Crédit \$',
          ),
        ));
  }

  Future<void> submit(BalanceCompteModel data) async {
    var solde = double.parse((montantDebitController.text == "")
            ? "0"
            : montantDebitController.text) -
        double.parse((montantCreditController.text == "")
            ? "0"
            : montantCreditController.text);

    final compteBalanceRefModel = CompteBalanceRefModel(
        id: 0,
        reference: data.id!,
        comptes: comptes.toString(),
        debit: (montantDebitController.text == "")
            ? "0"
            : montantDebitController.text,
        credit: (montantCreditController.text == "")
            ? "0"
            : montantCreditController.text,
        solde: solde.toString());
    await CompteBalanceRefApi().insertData(compteBalanceRefModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
