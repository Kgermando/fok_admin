import 'dart:async';

import 'package:fokad_admin/src/pages/rh/transport_restauration/plateforms/desktop/detail_trans_rest_desktop.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/plateforms/mobile/detail_trans_rest_mobile.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/plateforms/tablet/detail_trans_rest_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/budgets/departement_budget_api.dart';
import 'package:fokad_admin/src/api/budgets/ligne_budgetaire_api.dart';
import 'package:fokad_admin/src/api/rh/trans_rest_agents_api.dart';
import 'package:fokad_admin/src/api/rh/transport_restaurant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/budgets/ligne_budgetaire_model.dart';
import 'package:fokad_admin/src/models/rh/transport_restauration_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class DetailTransportRestaurant extends StatefulWidget {
  const DetailTransportRestaurant({Key? key}) : super(key: key);

  @override
  State<DetailTransportRestaurant> createState() =>
      _DetailTransportRestaurantState();
}

class _DetailTransportRestaurantState extends State<DetailTransportRestaurant> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final ScrollController controllerTable = ScrollController();

  bool isLoading = false;
  bool isChecked = false;
  bool isDeleting = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

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

  Timer? timer;

  @override
  initState() {
    getData();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getDataTransRest();
    });
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    matriculeController.dispose();
    montantController.dispose();
    motifDGController.dispose();
    motifBudgetController.dispose();
    motifFinController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

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

  List<DepartementBudgetModel> departementsList = [];
  List<LigneBudgetaireModel> ligneBudgetaireList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var departements = await DepeartementBudgetApi().getAllData();
    var budgets = await LIgneBudgetaireApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        departementsList = departements;
        ligneBudgetaireList = budgets;
      });
    }
  }

  List<TransRestAgentsModel> transRestAgentsList = [];
  List<TransRestAgentsModel> transRestAgentsFilter = [];
  Future<void> getDataTransRest() async {
    UserModel userModel = await AuthApi().getUserId();
    var transRestAgents = await TransRestAgentsApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        transRestAgentsFilter = transRestAgents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<TransportRestaurationModel>(
            future: TransportRestaurationApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<TransportRestaurationModel> snapshot) {
              if (snapshot.hasData) {
                TransportRestaurationModel? data = snapshot.data;
                return (data!.approbationDD == "Approved" ||
                        data.approbationDD == "Unapproved")
                    ? Container()
                    : FloatingActionButton(
                        tooltip: "Ajout personnels",
                        child: const Icon(Icons.add),
                        onPressed: () {
                          detailAgentDialog(data);
                        });
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
                    child: FutureBuilder<TransportRestaurationModel>(
                        future: TransportRestaurationApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<TransportRestaurationModel>
                                snapshot) {
                          if (snapshot.hasData) {
                            TransportRestaurationModel? data = snapshot.data;
                            transRestAgentsList = transRestAgentsFilter
                                .where((element) =>
                                    element.reference.microsecondsSinceEpoch ==
                                    data!.createdRef.microsecondsSinceEpoch)
                                .toList();
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
                                          title: (Responsive.isDesktop(context))
                                              ? "Ressources Humaines"
                                              : "RH",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (constraints.maxWidth >= 1100) {
                                    return DetailTransRestDesktop(
                                        transportRestaurationModel: data!,
                                        departementsList: departementsList,
                                        ligneBudgetaireList:
                                            ligneBudgetaireList,
                                        user: user,
                                        transRestAgentsList:
                                            transRestAgentsList);
                                  } else if (constraints.maxWidth < 1100 &&
                                      constraints.maxWidth >= 650) {
                                    return DetailTransRestTablet(
                                        transportRestaurationModel: data!,
                                        departementsList: departementsList,
                                        ligneBudgetaireList:
                                            ligneBudgetaireList,
                                        user: user,
                                        transRestAgentsList:
                                            transRestAgentsList);
                                  } else {
                                    return DetailTransRestMobile(
                                        transportRestaurationModel: data!,
                                        departementsList: departementsList,
                                        ligneBudgetaireList:
                                            ligneBudgetaireList,
                                        user: user,
                                        transRestAgentsList:
                                            transRestAgentsList);
                                  }
                                }))
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

  detailAgentDialog(TransportRestaurationModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Ajout personnel'),
              content: SizedBox(
                  height: 200,
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: nomWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: prenomWidget())
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: matriculeWidget()),
                            const SizedBox(
                              width: p10,
                            ),
                            Expanded(child: montantWidget())
                          ],
                        ),
                      ],
                    ),
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submitTransRestAgents(data);
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

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prenom',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: matriculeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Matricule',
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget montantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: montantController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Montant',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Ce champs est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  Future<void> submitTransRestAgents(TransportRestaurationModel data) async {
    final transRest = TransRestAgentsModel(
        reference: data.createdRef,
        nom: nomController.text,
        prenom: prenomController.text,
        matricule: matriculeController.text,
        montant: montantController.text);
    await TransRestAgentsApi().insertData(transRest).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Ajouté avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
