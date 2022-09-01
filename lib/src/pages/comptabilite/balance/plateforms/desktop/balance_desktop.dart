import 'package:fokad_admin/src/api/comptabilite/balance_compte_api.dart';
import 'package:fokad_admin/src/api/comptabilite/compte_balance_ref_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comptabilites/balance_comptes_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/balance_pdf.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class BalanceDesktop extends StatefulWidget {
  const BalanceDesktop(
      {Key? key,
      required this.user,
      required this.compteBalanceRefList,
      required this.balanceCompteModel})
      : super(key: key);
  final UserModel user;
  final List<CompteBalanceRefModel> compteBalanceRefList;
  final BalanceCompteModel balanceCompteModel;

  @override
  State<BalanceDesktop> createState() => _BalanceDesktopState();
}

class _BalanceDesktopState extends State<BalanceDesktop> {
  late Future<List<CompteBalanceRefModel>> dataFutureRef;
  String? comptesAllSelect;
  bool isLoadingDelete = false;
  bool isLoadingSend = false;
  bool isLoadingDeleteLigne = false;

  String? comptes;
  TextEditingController montantDebitController = TextEditingController();
  TextEditingController montantCreditController = TextEditingController();
  bool statut = false;

  @override
  initState() {
    super.initState();
    dataFutureRef = getDataFuture();
  }

  Future<List<CompteBalanceRefModel>> getDataFuture() async {
    var dataF = await CompteBalanceRefApi().getAllData();
    return dataF;
  }

  @override
  Widget build(BuildContext context) {
    return pageDetail(widget.balanceCompteModel);
  }

  Widget pageDetail(BalanceCompteModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(
                      title: Responsive.isMobile(context)
                          ? "Balance"
                          : "Comptes Balance"),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: "Actualiser la page",
                              color: Colors.green,
                              onPressed: () {
                                setState(() {
                                  dataFutureRef = getDataFuture();
                                });
                              },
                              icon: const Icon(Icons.refresh)),
                          if (data.signature == widget.user.matricule &&
                              data.isSubmit ==
                                  "false") // Uniqyement celui a remplit le document
                            sendButton(data),
                          if (data.approbationDD == "-") deleteButton(data),
                          PrintWidget(
                              tooltip: 'Imprimer le document',
                              onPressed: () async {
                                var compteBalanceRefPdf = widget
                                    .compteBalanceRefList
                                    .where((element) =>
                                        element.reference == data.id)
                                    .toList();
                                await BalancePdf.generate(
                                    data, compteBalanceRefPdf);
                              }),
                        ],
                      ),
                      Text(DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              Divider(
                color: mainColor,
              ),
              totalMontant(data),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(BalanceCompteModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;

    return FutureBuilder<List<CompteBalanceRefModel>>(
        future: dataFutureRef,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBalanceRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBalanceRefModel>? dataList = snapshot.data!
                .where((element) => element.reference == data.id)
                .toList();
            double totalDebit = 0.0;
            double totalCredit = 0.0;
            double totalSolde = 0.0;

            for (var item in dataList) {
              totalDebit += double.parse(item.debit);
              totalCredit += double.parse(item.credit);
              totalSolde += double.parse(item.solde);

              // print("item.debit ${item.debit} ");
            }

            return Padding(
              padding: const EdgeInsets.all(p10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text("TOTAL :",
                            textAlign: TextAlign.start,
                            style: headline6!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: mainColor,
                              width: 2,
                            ),
                          )),
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: mainColor,
                              width: 2,
                            ),
                          )),
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: mainColor,
                              width: 2,
                            ),
                          )),
                          child: Text(
                              "${NumberFormat.decimalPattern('fr').format(totalSolde)} \$",
                              textAlign: TextAlign.center,
                              style: headline6.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return loadingMini();
          }
        });
  }

  Widget dataWidget(BalanceCompteModel data) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text("Titre:",
                      style: bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
              Expanded(flex: 3, child: Text(data.title, style: bodyLarge))
            ],
          ),
          const SizedBox(height: p20),
          Divider(color: mainColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Text("Comptes",
                      textAlign: TextAlign.start,
                      style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: mainColor,
                      width: 2,
                    ),
                  )),
                  child: Text("Débit",
                      textAlign: TextAlign.center,
                      style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: mainColor,
                      width: 2,
                    ),
                  )),
                  child: Text("Crédit",
                      textAlign: TextAlign.center,
                      style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: mainColor,
                      width: 2,
                    ),
                  )),
                  child: Text("Solde",
                      textAlign: TextAlign.center,
                      style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          Divider(color: mainColor),
          const SizedBox(height: p30),
          compteWidget(data)
        ],
      ),
    );
  }

  Widget compteWidget(BalanceCompteModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return FutureBuilder<List<CompteBalanceRefModel>>(
        future: dataFutureRef,
        builder: (BuildContext context,
            AsyncSnapshot<List<CompteBalanceRefModel>> snapshot) {
          if (snapshot.hasData) {
            List<CompteBalanceRefModel>? dataList = snapshot.data!
                .where((element) => element.reference == data.id)
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final compte = dataList[index];
                  return Column(
                    children: [
                      Slidable(
                        enabled: (data.isSubmit == "true" ||
                                data.approbationDD == "Unapproved" ||
                                data.approbationDG == "Unapproved")
                            ? false
                            : true,
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                                onPressed: (context) {
                                  editLigneButton(compte);
                                  setState(() {
                                    dataFutureRef = getDataFuture();
                                  });
                                },
                                backgroundColor: Colors.purple.shade700,
                                foregroundColor: Colors.white,
                                icon: Icons.edit),
                            SlidableAction(
                              onPressed: (context) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Etes-vous sûr de faire ceci ?',
                                        style: TextStyle(color: mainColor)),
                                    content: (isLoadingSend)
                                        ? loading()
                                        : const Text(
                                            'Cette action permet de supprimer cette ligne.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Annuler'),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            await CompteBalanceRefApi()
                                                .deleteData(compte.id)
                                                .then((value) {
                                              Navigator.pop(context);
                                              setState(() {
                                                isLoadingDeleteLigne = false;
                                              });
                                            });
                                            setState(() {
                                              dataFutureRef = getDataFuture();
                                            });
                                          },
                                          child: const Text('OK')),
                                    ],
                                  ),
                                );
                              },
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: p20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(compte.comptes,
                                    textAlign: TextAlign.start,
                                    style: bodyMedium),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                      color: mainColor,
                                      width: 2,
                                    ),
                                  )),
                                  child: Text(
                                      (compte.debit == "0")
                                          ? "-"
                                          : "${NumberFormat.decimalPattern('fr').format(double.parse(compte.debit))} \$",
                                      textAlign: TextAlign.center,
                                      style: bodyMedium),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                      color: mainColor,
                                      width: 2,
                                    ),
                                  )),
                                  child: Text(
                                      (compte.credit == "0")
                                          ? "-"
                                          : "${NumberFormat.decimalPattern('fr').format(double.parse(compte.credit))} \$",
                                      textAlign: TextAlign.center,
                                      style: bodyMedium),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                      color: mainColor,
                                      width: 2,
                                    ),
                                  )),
                                  child: Text(
                                      "${NumberFormat.decimalPattern('fr').format(double.parse(compte.solde))} \$",
                                      textAlign: TextAlign.center,
                                      style: bodyMedium),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: mainColor,
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return loadingMega();
          }
        });
  }

  Widget deleteButton(BalanceCompteModel data) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de faire cette action ?'),
          content: const Text(
              'Cette action permet de permet de mettre ce fichier en corbeille.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await BalanceCompteApi().deleteData(data.id!).then((value) {
                  setState(() {
                    isLoadingDelete = false;
                  });
                });
                // Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget sendButton(BalanceCompteModel data) {
    return IconButton(
      icon: Icon(Icons.send, color: Colors.green.shade700),
      tooltip: "Soumettre chez le directeur de departement",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous pour soumettre ce document ?',
              style: TextStyle(color: mainColor)),
          content: (isLoadingSend)
              ? loading()
              : const Text(
                  'Cette action permet de soumettre ce document chez le directeur de departement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                sendDD(data).then((value) {
                  setState(() {
                    isLoadingSend = false;
                  });
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendDD(BalanceCompteModel data) async {
    final balanceCompteModel = BalanceCompteModel(
        id: data.id!,
        title: data.title,
        statut: 'true',
        signature: data.signature,
        created: DateTime.now(),
        isSubmit: 'true',
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await BalanceCompteApi().updateData(balanceCompteModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Document envoyé avec succès!"),
        backgroundColor: Colors.red[700],
      ));
    });
  }

  editLigneButton(CompteBalanceRefModel compte) {
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
                      submitEdit(compte).then((value) => isLoading = false);
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

  Future<void> submitEdit(CompteBalanceRefModel compte) async {
    var solde = double.parse((montantDebitController.text == "")
            ? compte.debit
            : montantDebitController.text) -
        double.parse((montantCreditController.text == "")
            ? compte.credit
            : montantCreditController.text);

    final compteBalanceRefModel = CompteBalanceRefModel(
        id: compte.id,
        reference: compte.reference,
        comptes: comptes.toString(),
        debit: (montantDebitController.text == "")
            ? compte.debit
            : montantDebitController.text,
        credit: (montantCreditController.text == "")
            ? compte.credit
            : montantCreditController.text,
        solde: solde.toString());
    await CompteBalanceRefApi().updateData(compteBalanceRefModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Mise à jour avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
