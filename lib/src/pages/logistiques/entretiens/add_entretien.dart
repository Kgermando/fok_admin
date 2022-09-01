import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/api/logistiques/objet_remplace_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/objet_remplace_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class AddEntretienPage extends StatefulWidget {
  const AddEntretienPage({Key? key}) : super(key: key);

  @override
  State<AddEntretienPage> createState() => _AddEntretienPageState();
}

class _AddEntretienPageState extends State<AddEntretienPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _formObjetKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingObjet = false;
  bool isDeletingItem = false;

  ScrollController controllerTable = ScrollController();

  late Future<List<ObjetRemplaceModel>> dataFuture;

  String? nom;
  String? typeObjet;
  String? typeMaintenance;
  TextEditingController dureeTravauxController = TextEditingController();

  TextEditingController nomObjetController = TextEditingController();
  TextEditingController coutController = TextEditingController();
  TextEditingController caracteristiqueController = TextEditingController();
  TextEditingController observationController = TextEditingController();

  Timer? timer;
  @override
  void initState() {
    getDate();

    dataFuture = getDataFuture();
    super.initState();
  }

  List<String> nomList = [];
  List<MobilierModel> mobilierList = [];
  List<ImmobilierModel> immobilierList = [];
  List<AnguinModel> enguinsList = [];

  @override
  void dispose() {
    dureeTravauxController.dispose();
    nomObjetController.dispose();
    coutController.dispose();
    caracteristiqueController.dispose();
    observationController.dispose();

    super.dispose();
  }

  int entretiensCount = 0;

  String? signature;
  Future<void> getDate() async {
    UserModel userModel = await AuthApi().getUserId();
    // var objetRemplace = await ObjetRemplaceApi().getAllData();
    var mobiliers = await MobilierApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    var enguins = await AnguinApi().getAllData();
    if (!mounted) return;
    setState(() {
      signature = userModel.matricule;
      // objetRemplaceFilter = objetRemplace.toList();
      mobilierList = mobiliers
          .where((element) => element.approbationDD == "Approved")
          .toList();
      immobilierList = immobiliers
          .where((element) =>
              element.approbationDG == "Approved" &&
              element.approbationDD == "Approved")
          .toList();
      enguinsList = enguins
          .where((element) =>
              element.approbationDG == "Approved" &&
              element.approbationDD == "Approved")
          .toList();
    });
  }

  Future<List<ObjetRemplaceModel>> getDataFuture() async {
    var objetRemplace = await ObjetRemplaceApi().getAllData();
    return objetRemplace;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder<List<EntretienModel>>(
                        future: EntretienApi().getAllData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<EntretienModel>> snapshot) {
                          if (snapshot.hasData) {
                            List<EntretienModel>? data = snapshot.data;
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
                                          title: 'Logistique',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    addDataWidget(data!),
                                  ],
                                )))
                              ],
                            );
                          } else {
                            return Center(child: loadingMega());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget addDataWidget(List<EntretienModel> data) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    TitleWidget(
                        title: Responsive.isDesktop(context)
                            ? "Entretiens & Maintenance"
                            : "Entretiens"),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: typeObjetWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: nomWidget())
                      ],
                    ),
                    etatObjetWidget(),
                    dureeTravauxWidget(),
                    objetRemplaceWidget(data),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget typeObjetWidget() {
    List<String> typeObjetList = ["Mobilier", "Immobilier", "Enguins"];
    var mobiliers = mobilierList.map((e) => e.nom).toList();
    var immobiliers = immobilierList.map((e) => e.numeroCertificat).toList();
    var enguins = enguinsList.map((e) => e.nom).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Objet',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeObjet,
        isExpanded: true,
        validator: (value) => value == null ? "Champs obligatoire" : null,
        items: typeObjetList
            .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toSet()
            .toList(),
        onChanged: (value) {
          setState(() {
            typeObjet = value!;
            nomList.clear();
            switch (value) {
              case 'Mobilier':
                nomList = mobiliers;
                nom = nomList.first;
                break;
              case 'Immobilier':
                nomList = immobiliers;
                nom = nomList.first;
                break;
              case 'Enguins':
                nomList = enguins;
                nom = nomList.first;
                break;
              default:
            }
          });
        },
      ),
    );
  }

  Widget nomWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Nom',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: nom,
        isExpanded: true,
        items: nomList
            .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toSet()
            .toList(),
        validator: (value) => value == null ? "Champs obligatoire" : null,
        onChanged: (value) {
          setState(() {
            nom = value!;
          });
        },
      ),
    );
  }

  Widget dureeTravauxWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: dureeTravauxController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Durée Travaux',
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

  Widget etatObjetWidget() {
    List<String> typeMaintenanceList = [
      'Maintenance curative',
      'Maintenance préventive',
      'Maintenance corrective',
      'Maintenance améliorative'
    ];
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Type de maintenance',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: typeMaintenance,
          isExpanded: true,
          items: typeMaintenanceList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select maintenance" : null,
          onChanged: (value) {
            setState(() {
              typeMaintenance = value;
            });
          },
        ));
  }

  Widget objetRemplaceWidget(List<EntretienModel> data) {
    return Container(
      padding: const EdgeInsets.all(p20),
      color: Colors.blue[100],
      child: Column(
        children: [
          tableWidget(data),
          const SizedBox(height: p20),
          Form(
            key: _formObjetKey,
            child: Column(
              children: [
                Responsive.isMobile(context)
                    ? Column(
                        children: [nomObjetWidget(), coutWidget()],
                      )
                    : Row(
                        children: [
                          Expanded(child: nomObjetWidget()),
                          const SizedBox(width: p10),
                          Expanded(child: coutWidget())
                        ],
                      ),
                Responsive.isMobile(context)
                    ? Column(
                        children: [
                          caracteristiqueWidget(),
                          observationWidget()
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: caracteristiqueWidget()),
                          const SizedBox(width: p10),
                          Expanded(child: observationWidget())
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoadingObjet = true;
                          });
                          final formObjetKey = _formObjetKey.currentState!;
                          if (formObjetKey.validate()) {
                            submitObjetRemplace().then((value) {
                              setState(() {
                                isLoadingObjet = false;
                              });
                            });
                            formObjetKey.reset();
                          }
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text("Ajout l'objet",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tableWidget(List<EntretienModel> data) {
    entretiensCount = data.length + 1;
    return FutureBuilder<List<ObjetRemplaceModel>>(
        future: dataFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<ObjetRemplaceModel>> snapshot) {
          if (snapshot.hasData) {
            List<ObjetRemplaceModel>? objetRemplace = snapshot.data!
                .where((element) => element.reference == entretiensCount)
                .toList();
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleWidget(
                          title: Responsive.isDesktop(context)
                              ? "Ajouter les objets remplacés"
                              : "Add objet"),
                      IconButton(
                          tooltip: "Actualiser les données",
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              dataFuture = getDataFuture();
                            });
                          },
                          icon: const Icon(Icons.refresh))
                    ]),
                if (!Responsive.isMobile(context))
                  tableWidgetDesktop(objetRemplace),
                if (Responsive.isMobile(context))
                  Scrollbar(
                      controller: controllerTable,
                      child: tableWidgetMobile(objetRemplace))
              ],
            );
          } else {
            return Center(child: loading());
          }
        });
  }

  Widget tableWidgetDesktop(List<ObjetRemplaceModel> objetRemplace) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: p20),
      child: Table(
        border: TableBorder.all(color: mainColor),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(4),
          3: FlexColumnWidth(4),
          4: FlexColumnWidth(1),
        },
        children: [
          TableRow(children: [
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Nom", textAlign: TextAlign.start, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child:
                  Text("Coût", textAlign: TextAlign.center, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Caracteristique",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Observation",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
            Container(
              padding: const EdgeInsets.all(p10),
              child: Text("Retirer",
                  textAlign: TextAlign.start, style: bodyMedium),
            ),
          ]),
          for (var item in objetRemplace)
            tableDataWidget(item.nom, item.cout, item.caracteristique,
                item.observation, item.id!)
        ],
      ),
    );
  }

  Widget tableWidgetMobile(List<ObjetRemplaceModel> objetRemplace) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerTable,
      child: Container(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width * 2),
        child: Table(
          border: TableBorder.all(color: mainColor),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(4),
            3: FlexColumnWidth(4),
            4: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(p10),
                child:
                    Text("Nom", textAlign: TextAlign.start, style: bodyMedium),
              ),
              Container(
                padding: const EdgeInsets.all(p10),
                child: Text("Coût",
                    textAlign: TextAlign.center, style: bodyMedium),
              ),
              Container(
                padding: const EdgeInsets.all(p10),
                child: Text("Caracteristique",
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
              Container(
                padding: const EdgeInsets.all(p10),
                child: Text("Observation",
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
              Container(
                padding: const EdgeInsets.all(p10),
                child: Text("Retirer",
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ]),
            for (var item in objetRemplace)
              tableDataWidget(item.nom, item.cout, item.caracteristique,
                  item.observation, item.id!)
          ],
        ),
      ),
    );
  }

  TableRow tableDataWidget(
      String nom, String cout, String caraterique, String observation, int id) {
    double coutProduit = (cout == '') ? double.parse('0') : double.parse(cout);
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    return TableRow(children: [
      Container(
        padding: const EdgeInsets.all(p10),
        child:
            SelectableText(nom, textAlign: TextAlign.start, style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(
            "${NumberFormat.decimalPattern('fr').format(coutProduit)} \$",
            textAlign: TextAlign.center,
            style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(caraterique,
            textAlign: TextAlign.start, style: bodyMedium),
      ),
      Container(
        padding: const EdgeInsets.all(p10),
        child: SelectableText(observation,
            textAlign: TextAlign.start, style: bodyMedium),
      ),
      Container(
          padding: const EdgeInsets.all(p10),
          child: (isDeletingItem)
              ? loadingMini()
              : IconButton(
                  tooltip: "Actualiser après suppression",
                  color: Colors.red,
                  onPressed: () async {
                    setState(() {
                      isDeletingItem = true;
                    });
                    await ObjetRemplaceApi()
                        .deleteData(id)
                        .then((value) => isDeletingItem = false);
                  },
                  icon: const Icon(Icons.delete))),
    ]);
  }

  Widget nomObjetWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomObjetController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget coutWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.only(bottom: p20),
              child: TextFormField(
                controller: coutController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Coût',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(),
              )),
        ),
        const SizedBox(width: p20),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: p8),
              child: Text("\$", style: Theme.of(context).textTheme.headline6),
            ))
      ],
    );
  }

  Widget caracteristiqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: caracteristiqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Caracteristique',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget observationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: observationController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: 'Observation',
              hintText: 'En etat de marche, pause probleme de compatibilité'),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Future<void> submit() async {
    final entretienModel = EntretienModel(
        nom: nom.toString(),
        modele: typeObjet.toString(),
        marque: '-',
        etatObjet: typeMaintenance.toString(),
        dureeTravaux: dureeTravauxController.text,
        signature: signature.toString(),
        createdRef: entretiensCount,
        created: DateTime.now(),
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await EntretienApi().insertData(entretienModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future<void> submitObjetRemplace() async {
    final objetRemplace = ObjetRemplaceModel(
        reference: entretiensCount,
        nom: nomObjetController.text,
        cout: coutController.text,
        caracteristique: caracteristiqueController.text,
        observation: observationController.text);
    await ObjetRemplaceApi().insertData(objetRemplace).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Ajouté avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
