import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_api.dart';
import 'package:fokad_admin/src/api/comptabilite/journal_livre_api.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_livre_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/table_journal.dart';
import 'package:fokad_admin/src/utils/comptes_dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class JournalLivreDetail extends StatefulWidget {
  const JournalLivreDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<JournalLivreDetail> createState() => _JournalLivreDetailState();
}

class _JournalLivreDetailState extends State<JournalLivreDetail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future<List<JournalModel>> dataFuture;
  String? comptesAllSelect;
  String? comptes;
  String? type;
  TextEditingController numeroOperationController = TextEditingController();
  TextEditingController libeleController = TextEditingController();
  TextEditingController montantDebitController = TextEditingController();
  TextEditingController montantCreditController = TextEditingController();
  TextEditingController tvaController = TextEditingController();
  TextEditingController remarqueController = TextEditingController();

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();
    super.initState();
  }

  JournalLivreModel journalLivre = JournalLivreModel(
      intitule: '-',
      debut: DateTime.now(),
      fin: DateTime.now(),
      signature: '-',
      created: DateTime.now(),
      approbationDG: 'Approved',
      motifDG: '-',
      signatureDG: '-',
      approbationDD: 'Approved',
      motifDD: '-',
      signatureDD: '-');
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
    var livre = await JournalLivreApi().getOneData(widget.id);
    setState(() {
      user = userModel;
      journalLivre = livre;
    });
  }

  @override
  void dispose() {
    numeroOperationController.dispose();
    libeleController.dispose();
    montantDebitController.dispose();
    montantCreditController.dispose();
    tvaController.dispose();
    remarqueController.dispose();

    super.dispose();
  }

  Future<List<JournalModel>> getDataFuture() async {
    var dataF = await JournalApi().getAllData();
    return dataF;
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton.extended(
            tooltip: "Nouvel écriture",
            label: Row(
              children: const [
                Icon(Icons.add),
                Text("Add écriture"),
              ],
            ),
            onPressed: () {
              newEcritureDialog();
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
                  child: Column(
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
                          if (!Responsive.isMobile(context))
                            const SizedBox(width: p10),
                          Expanded(
                            child: CustomAppbar(
                                title: 'Comptabilités',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                          child: ListView(
                        padding: const EdgeInsets.all(p20),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: "Journals"),
                              Row(
                                children: [
                                  IconButton(
                                      color: Colors.green,
                                      tooltip: "Actualiser la page",
                                      onPressed: () {
                                        setState(() {
                                          dataFuture = getDataFuture();
                                        });
                                      },
                                      icon: const Icon(Icons.refresh)),
                                  const SizedBox(width: p10),
                                  SelectableText(
                                      DateFormat("dd-MM-yyyy HH:mm")
                                          .format(journalLivre.created),
                                      textAlign: TextAlign.end,
                                      style: bodyMedium)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: p20),
                          Responsive.isMobile(context)
                              ? Column(
                                  children: [
                                    Text('Intitule :',
                                        textAlign: TextAlign.start,
                                        style: bodyMedium!.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    SelectableText(journalLivre.intitule,
                                        textAlign: TextAlign.justify,
                                        style: bodyMedium),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text('Intitule :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SelectableText(
                                          journalLivre.intitule,
                                          textAlign: TextAlign.justify,
                                          style: bodyMedium),
                                    )
                                  ],
                                ),
                          Divider(color: mainColor),
                          Responsive.isMobile(context)
                              ? Column(
                                  children: [
                                    Text('Date de début :',
                                        textAlign: TextAlign.start,
                                        style: bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    SelectableText(
                                        DateFormat("dd-MM-yyyy")
                                            .format(journalLivre.debut),
                                        textAlign: TextAlign.justify,
                                        style: bodyMedium),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text('Date de début :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SelectableText(
                                          DateFormat("dd-MM-yyyy")
                                              .format(journalLivre.debut),
                                          textAlign: TextAlign.justify,
                                          style: bodyMedium),
                                    )
                                  ],
                                ),
                          Divider(color: mainColor),
                          Responsive.isMobile(context)
                              ? Column(
                                  children: [
                                    Text('Date de fin :',
                                        textAlign: TextAlign.start,
                                        style: bodyMedium.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    SelectableText(
                                        DateFormat("dd-MM-yyyy")
                                            .format(journalLivre.fin),
                                        textAlign: TextAlign.justify,
                                        style: bodyMedium),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text('Date de fin :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SelectableText(
                                          DateFormat("dd-MM-yyyy")
                                              .format(journalLivre.fin),
                                          textAlign: TextAlign.justify,
                                          style: bodyMedium),
                                    )
                                  ],
                                ),
                          Divider(color: mainColor),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text('Signature :',
                                    textAlign: TextAlign.start,
                                    style: bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                flex: 3,
                                child: SelectableText(journalLivre.signature,
                                    textAlign: TextAlign.justify,
                                    style: bodyMedium),
                              )
                            ],
                          ),
                          Divider(color: mainColor),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: FutureBuilder<List<JournalModel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<JournalModel>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    List<JournalModel>? itemList =
                                        snapshot.data;
                                    return Column(
                                      children: [
                                        Expanded(
                                            child: TableJournal(
                                                itemList: itemList!)),
                                        totalWidget(itemList)
                                      ],
                                    );
                                  } else {
                                    return Center(child: loadingMega());
                                  }
                                }),
                          ),
                          const SizedBox(height: p20),
                          // LayoutBuilder(builder: (context, constraints) {
                          //   if (constraints.maxWidth >= 1100) {
                          //     return JournalApprobationDesktop(
                          //         user: user, journalLivreModel: journalLivre);
                          //   } else if (constraints.maxWidth < 1100 &&
                          //       constraints.maxWidth >= 650) {
                          //     return JournalApprobationTablet(
                          //         user: user, journalLivreModel: journalLivre);
                          //   } else {
                          //     return JournalApprobationMobile(
                          //         user: user, journalLivreModel: journalLivre);
                          //   }
                          // })
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget totalWidget(List<JournalModel> itemList) {
    final headlineMedium = Theme.of(context).textTheme.headlineMedium;
    double totalDebit = 0.0;
    double totalCredit = 0.0;
    for (var element in itemList) {
      totalDebit += double.parse(element.montantDebit);
    }
    for (var element in itemList) {
      totalCredit += double.parse(element.montantCredit);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text("Total débit :",
                        style: headlineMedium!.copyWith(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                        style: headlineMedium.copyWith(color: Colors.red))
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("Total débit :",
                            style: headlineMedium!.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text(
                            "${NumberFormat.decimalPattern('fr').format(totalDebit)} \$",
                            style: headlineMedium.copyWith(color: Colors.red))),
                  ],
                ),
        ),
        Expanded(
          child: Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text("Total crédit :",
                        style: headlineMedium.copyWith(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                    Text(
                        "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                        style: headlineMedium.copyWith(color: Colors.orange))
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text("Total crédit :",
                            style: headlineMedium.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text(
                            "${NumberFormat.decimalPattern('fr').format(totalCredit)} \$",
                            style:
                                headlineMedium.copyWith(color: Colors.orange))),
                  ],
                ),
        ),
      ],
    );
  }

  newEcritureDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final formKey = GlobalKey<FormState>();
          bool isLoading = false;
          List<String> typaList = ["Debit", "Credit"];

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
                  height: Responsive.isMobile(context) ? 600 : 500,
                  width: Responsive.isMobile(context) ? 300 : 500,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: p20),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Type d\'entrer',
                                    labelStyle: const TextStyle(),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    contentPadding:
                                        const EdgeInsets.only(left: 5.0),
                                  ),
                                  value: type,
                                  isExpanded: true,
                                  items: typaList.map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value!),
                                    );
                                  }).toList(),
                                  validator: (value) =>
                                      value == null ? "Select compte" : null,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value!;
                                    });
                                  },
                                ),
                              ),
                              Responsive.isMobile(context)
                                  ? Column(
                                      children: [
                                        numeroOperationWidget(),
                                        libeleWidget()
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: numeroOperationWidget()),
                                        const SizedBox(width: p10),
                                        Expanded(flex: 3, child: libeleWidget())
                                      ],
                                    ),
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
                              Column(
                                children: [
                                  if (type == "Debit") debit(),
                                  if (type == "Credit") credit()
                                ],
                              ),
                              tvaWidget()
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
                      submit().then((value) => isLoading = false);
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

  Widget numeroOperationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroOperationController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N°',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget libeleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: libeleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libelé',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget debit() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: montantDebitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Débit',
                ),
              ),
            ),
            const SizedBox(width: p8),
            Expanded(
                flex: 1,
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  Widget credit() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: montantCreditController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Crédit',
                ),
              ),
            ),
            const SizedBox(width: p8),
            Expanded(
                flex: 1,
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  Widget tvaWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: tvaController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'TVA en %',
                ),
                style: const TextStyle(),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(width: p8),
            Expanded(
                flex: 1,
                child: Text("%", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  Future<void> submit() async {
    final journalModel = JournalModel(
        reference: journalLivre.id!,
        numeroOperation: numeroOperationController.text,
        libele: libeleController.text,
        compte: comptes.toString(),
        montantDebit: (montantDebitController.text == "")
            ? "0"
            : montantDebitController.text,
        montantCredit: (montantCreditController.text == "")
            ? "0"
            : montantCreditController.text,
        tva: tvaController.text,
        type: type.toString(),
        created: DateTime.now());
    await JournalApi().insertData(journalModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
