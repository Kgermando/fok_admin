import 'dart:async';

import 'package:fokad_admin/src/pages/devis/plateforms/desktop/devis_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/devis/plateforms/mobile/devis_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/devis/plateforms/tablet/devis_approbation_tablet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/devis/devis_api.dart';
import 'package:fokad_admin/src/api/devis/devis_list_objets_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/devis/devis_list_objets_model.dart';
import 'package:fokad_admin/src/models/devis/devis_models.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailDevis extends StatefulWidget {
  const DetailDevis({Key? key}) : super(key: key);

  @override
  State<DetailDevis> createState() => _DetailDevisState();
}

class _DetailDevisState extends State<DetailDevis> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();
  bool isLoadingBtn = false;

  double quantity = 0.0;
  final TextEditingController designationController = TextEditingController();
  double montantUnitaire = 0.0;
  double montantGlobal = 0.0;

  // Approbations
  String approbationDG = '-';
  String approbationBudget = '-';
  String approbationFin = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifBudgetController = TextEditingController();
  TextEditingController motifFinController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();
  String? ligneBudgtaire;
  String? ressource;

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    motifDGController.dispose();
    motifBudgetController.dispose();
    motifFinController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  List<DevisListObjetsModel> devisObjetList = [];
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
    var devisObjetLists = await DevisListObjetsApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        departementsList = departements;
        ligneBudgetaireList = budgets;
        devisObjetList = devisObjetLists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<DevisModel>(
            future: DevisAPi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<DevisModel> snapshot) {
              if (snapshot.hasData) {
                DevisModel? data = snapshot.data;
                return addObjetDevisButton(data!);
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
                    child: FutureBuilder<DevisModel>(
                        future: DevisAPi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DevisModel> snapshot) {
                          if (snapshot.hasData) {
                            DevisModel? data = snapshot.data;
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
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Logistique",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data!),
                                    const SizedBox(height: p10),
                                    // LayoutBuilder(
                                    //     builder: (context, constraints) {
                                    //   if (constraints.maxWidth >= 1100) {
                                    //     return DevisApprobationDesktop(
                                    //         departementsList: departementsList,
                                    //         ligneBudgetaireList:
                                    //             ligneBudgetaireList,
                                    //         user: user,
                                    //         devisModel: data);
                                    //   } else if (constraints.maxWidth < 1100 &&
                                    //       constraints.maxWidth >= 650) {
                                    //     return DevisApprobationTablet(
                                    //         departementsList: departementsList,
                                    //         ligneBudgetaireList:
                                    //             ligneBudgetaireList,
                                    //         user: user,
                                    //         devisModel: data);
                                    //   } else {
                                    //     return DevisApprobationMobile(
                                    //         departementsList: departementsList,
                                    //         ligneBudgetaireList:
                                    //             ligneBudgetaireList,
                                    //         user: user,
                                    //         devisModel: data);
                                    //   }
                                    // })
                                  ],
                                )))
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

  Widget pageDetail(DevisModel data) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        // elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: width,
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
                  TitleWidget(title: "Ticket n° ${data.id}"),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              color: Colors.green.shade700,
                              onPressed: () {
                                submitToDG(data);
                              },
                              icon: const Icon(Icons.send)),
                          deleteButton(data),
                          // PrintWidget(
                          //     tooltip: 'Imprimer le document', onPressed: () {})
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: SingleChildScrollView(child: tableDevisListObjet(data)),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(DevisModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Titre :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.title,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Titre :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.title,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Priorité :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.priority,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Priorité :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.priority,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Département :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.departement,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Département :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.departement,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(color: mainColor),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text(
                      'Observation',
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (data.observation == 'false' &&
                        user.departement == "Finances")
                      Expanded(flex: 3, child: checkboxRead(data)),
                    (data.observation == 'true')
                        ? SelectableText(
                            'Payé',
                            style: bodyMedium.copyWith(
                                color: Colors.greenAccent.shade700),
                          )
                        : SelectableText(
                            'Non payé',
                            style: bodyMedium.copyWith(
                                color: Colors.redAccent.shade700),
                          )
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Observation',
                        style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: p10,
                    ),
                    if (data.observation == 'false' &&
                        user.departement == "Finances")
                      Expanded(flex: 3, child: checkboxRead(data)),
                    Expanded(
                        flex: 3,
                        child: (data.observation == 'true')
                            ? SelectableText(
                                'Payé',
                                style: bodyMedium.copyWith(
                                    color: Colors.greenAccent.shade700),
                              )
                            : SelectableText(
                                'Non payé',
                                style: bodyMedium.copyWith(
                                    color: Colors.redAccent.shade700),
                              ))
                  ],
                ),
          Divider(color: mainColor),
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.green;
  }

  checkboxRead(DevisModel data) {
    if (data.observation == 'true') {
      isChecked = true;
    } else if (data.observation == 'false') {
      isChecked = false;
    }
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isLoading = true;
          });
          setState(() {
            isChecked = value!;
            if (isChecked) {
              submitobservation(data, 'true');
            } else {
              submitobservation(data, 'false');
            }
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de payement"),
    );
  }

  Widget deleteButton(DevisModel data) {
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
                await DevisAPi().deleteData(data.id!).then((value) {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton addObjetDevisButton(DevisModel data) {
    return FloatingActionButton(
      tooltip: "Ajout objet",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ajout votre devis'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            montantGlobal = quantity * montantUnitaire;
            return SizedBox(
              height: 200,
              width: 500,
              child: isLoadingBtn
                  ? loading()
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Quantité',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          quantity = (value == "")
                                              ? 1
                                              : double.parse(value);
                                        });
                                      },
                                    )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      controller: designationController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Désignation',
                                      ),
                                      keyboardType: TextInputType.text,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        labelText: 'Montant unitaire',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          montantUnitaire = (value == "")
                                              ? 1
                                              : double.parse(value);
                                        });
                                      },
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: p20, left: p20),
                                    child: Column(
                                      children: [
                                        Text("Montant global",
                                            style: TextStyle(
                                                color: Colors.red.shade700)),
                                        Text(
                                            "${NumberFormat.decimalPattern('fr').format(double.parse(montantGlobal.toStringAsFixed(2)))} \$",
                                            style: TextStyle(
                                                color: Colors.red.shade700)),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() => isLoadingBtn = true);
                submitObjet(data);
              },
              child: isLoadingBtn ? loadingMini() : const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Icon(Icons.add),
    );
  }

  Widget tableDevisListObjet(DevisModel data) {
    return Table(
      border: TableBorder.all(color: mainColor),
      columnWidths: const {
        0: FixedColumnWidth(50.0), // fixed to 100 width
        1: FlexColumnWidth(300.0),
        2: FixedColumnWidth(150.0), //fixed to 100 width
        3: FixedColumnWidth(150.0),
      },
      children: [
        tableDevisHeader(),
        for (var item in devisObjetList.where((element) =>
            element.referenceDate.microsecondsSinceEpoch ==
            data.createdRef.microsecondsSinceEpoch))
          tableDevisBody(item)
      ],
    );
  }

  TableRow tableDevisBody(DevisListObjetsModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            double.parse(data.quantity).toStringAsFixed(0),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            data.designation,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.montantUnitaire).toStringAsFixed(2)))} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0 * 0.75),
          // decoration:
          //     BoxDecoration(border: Border.all(color: mainColor)),
          child: AutoSizeText(
            "${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.montantGlobal).toStringAsFixed(2)))} \$",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: bodyMedium,
          ),
        ),
      ],
    );
  }

  TableRow tableDevisHeader() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: mainColor)),
        child: AutoSizeText(
          "Qty".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: mainColor)),
        child: AutoSizeText(
          "Désignation".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: mainColor)),
        child: AutoSizeText(
          "Montant unitaire".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0 * 0.75),
        // decoration:
        //     BoxDecoration(border: Border.all(color: mainColor)),
        child: AutoSizeText(
          "Montant global".toUpperCase(),
          maxLines: 1,
          textAlign: TextAlign.center,
          style: bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  Future<void> submitobservation(DevisModel data, String obs) async {
    final devisModel = DevisModel(
        id: data.id!,
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: obs,
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: data.isSubmit,
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: data.approbationFin,
        motifFin: data.motifFin,
        signatureFin: data.signatureFin,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource);
    await DevisAPi().updateData(devisModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Payement effectué avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitToDG(DevisModel data) async {
    final devisModel = DevisModel(
        title: data.title,
        priority: data.priority,
        departement: data.departement,
        observation: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        isSubmit: 'true',
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationBudget: data.approbationBudget,
        motifBudget: data.motifBudget,
        signatureBudget: data.signatureBudget,
        approbationFin: data.approbationFin,
        motifFin: data.motifFin,
        signatureFin: data.signatureFin,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD,
        ligneBudgetaire: data.ligneBudgetaire,
        ressource: data.ressource);
    await DevisAPi().updateData(devisModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis chez le DG avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitObjet(DevisModel data) async {
    montantGlobal = quantity * montantUnitaire;
    final devisListObjetsModel = DevisListObjetsModel(
      referenceDate: data.createdRef,
      title: data.title,
      quantity: quantity.toString(),
      designation: designationController.text,
      montantUnitaire: montantUnitaire.toString(),
      montantGlobal: montantGlobal.toString(),
    );
    await DevisListObjetsApi().insertData(devisListObjetsModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistré avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
