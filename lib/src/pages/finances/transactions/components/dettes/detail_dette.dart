import 'package:fokad_admin/src/pages/finances/transactions/plateforms/desktop/dette_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/desktop/total_restant_dette_creance_desktop.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/mobile/dette_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/mobile/total_restant_dette_creance_mobile.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/tablet/dette_approbation_tablet.dart';
import 'package:fokad_admin/src/pages/finances/transactions/plateforms/tablet/total_restant_dette_creance_tablet.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/creance_dette_api.dart';
import 'package:fokad_admin/src/api/finances/dette_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/creance_dette_model.dart';
import 'package:fokad_admin/src/models/finances/dette_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creance_dette/table_creance_dette.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailDette extends StatefulWidget {
  const DetailDette({Key? key}) : super(key: key);

  @override
  State<DetailDette> createState() => _DetailDetteState();
}

class _DetailDetteState extends State<DetailDette> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<UserModel> userList = [];

  bool isChecked = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  String approbationDGController = '-';
  TextEditingController signatureJustificationDGController =
      TextEditingController();

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();

  double total = 0.0;

  // Approbations
  String approbationDG = '-';
  String approbationDD = '-';
  TextEditingController motifDGController = TextEditingController();
  TextEditingController motifDDController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    motifDGController.dispose();
    motifDDController.dispose();
    super.dispose();
  }

  String signature = '';
  List<CreanceDetteModel> creanceDetteList = [];
  List<CreanceDetteModel> creanceDetteFilter = [];
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
    final dataUser = await UserApi().getAllData();
    UserModel userModel = await AuthApi().getUserId();
    var creanceDette = await CreanceDetteApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      userList = dataUser;
      user = userModel;
      creanceDetteFilter = creanceDette;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<DetteModel>(
            future: DetteApi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<DetteModel> snapshot) {
              if (snapshot.hasData) {
                DetteModel? data = snapshot.data;
                return FloatingActionButton(
                    tooltip: 'Paiement',
                    child: const Icon(Icons.add),
                    onPressed: () {
                      dialongDettePaiement(data!);
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
                    child: FutureBuilder<DetteModel>(
                        future: DetteApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DetteModel> snapshot) {
                          if (snapshot.hasData) {
                            DetteModel? data = snapshot.data;
                            creanceDetteList = creanceDetteFilter
                                .where((element) =>
                                    element.creanceDette == 'dettes' &&
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
                                          title: "Finance",
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
                                    //     return DetteApprobationDesktop(
                                    //         detteModel: data, user: user);
                                    //   } else if (constraints.maxWidth < 1100 &&
                                    //       constraints.maxWidth >= 650) {
                                    //     return DetteApprobationTablet(
                                    //         detteModel: data, user: user);
                                    //   } else {
                                    //     return DetteApprobationMobile(
                                    //         detteModel: data, user: user);
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

  Widget pageDetail(DetteModel data) {
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
        elevation: 10,
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
                  const TitleWidget(title: "Dette"),
                  Column(
                    children: [
                      SelectableText(
                          DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              totalMontant(data),
              SizedBox(
                  height: 300,
                  child: TableCreanceDette(
                      creanceDette: 'dettes', createdRef: data.createdRef)),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget totalMontant(DetteModel data) {
    double totalCreanceDette = 0.0;

    for (var item in creanceDetteList) {
      totalCreanceDette += double.parse(item.montant);
    }

    total = double.parse(data.montant) - totalCreanceDette;

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1100) {
        return TotalRestantDetteCreanceDesktop(total: total);
      } else if (constraints.maxWidth < 1100 && constraints.maxWidth >= 650) {
        return TotalRestantDetteCreanceTablet(total: total);
      } else {
        return TotalRestantDetteCreanceMobile(total: total);
      }
    });
  }

  Widget dataWidget(DetteModel detteModel) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    double totalCreanceDette = 0.0;

    for (var item in creanceDetteList) {
      totalCreanceDette += double.parse(item.montant);
    }

    total = double.parse(detteModel.montant) - totalCreanceDette;

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom Complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(detteModel.nomComplet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Pièce justificative :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(detteModel.pieceJustificative,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Libellé :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(detteModel.libelle,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Montant :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(
                    "${NumberFormat.decimalPattern('fr').format(double.parse(detteModel.montant))} \$",
                    textAlign: TextAlign.start,
                    style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Numéro d\'opération :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(detteModel.numeroOperation,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(detteModel.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(color: mainColor),
          Row(
            children: [
              Expanded(
                child: Text('Statut :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: p10,
              ),
              if (total == 0.0 &&
                  detteModel.statutPaie == 'false' &&
                  user.departement == "Finances")
                Expanded(child: checkboxRead(detteModel)),
              (detteModel.statutPaie == 'true')
                  ? Expanded(
                      child: SelectableText('Payé',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(color: Colors.blue.shade700)),
                    )
                  : Expanded(
                      child: SelectableText('Non Payé',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              color: Colors.orange.shade700)),
                    )
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

  checkboxRead(DetteModel data) {
    isChecked = data.statutPaie == 'true';
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
            submitobservation(data);
          });
          setState(() {
            isLoading = false;
          });
        },
      ),
      title: const Text("Confirmation de Paiement"),
    );
  }

  Future<void> submitobservation(DetteModel data) async {
    final detteModel = DetteModel(
        id: data.id,
        nomComplet: data.nomComplet,
        pieceJustificative: data.pieceJustificative,
        libelle: data.libelle,
        montant: data.montant,
        numeroOperation: data.numeroOperation,
        statutPaie: 'true',
        signature: data.signature,
        createdRef: data.createdRef,
        created: DateTime.now(),
        approbationDG: data.approbationDG,
        motifDG: data.motifDG,
        signatureDG: data.signatureDG,
        approbationDD: data.approbationDD,
        motifDD: data.motifDD,
        signatureDD: data.signatureDD);
    await DetteApi().updateData(detteModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  dialongDettePaiement(DetteModel data) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                content: SizedBox(
              height: (Responsive.isDesktop(context)) ? 400 : 480,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            (Responsive.isDesktop(context))
                                ? 'Ajout Paiement'
                                : 'Paiement',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    (Responsive.isDesktop(context))
                        ? Row(
                            children: [
                              Expanded(child: nomCompletWidget()),
                              const SizedBox(width: p20),
                              Expanded(child: libelleWidget()),
                            ],
                          )
                        : Column(
                            children: [
                              nomCompletWidget(),
                              const SizedBox(width: p20),
                              libelleWidget(),
                            ],
                          ),
                    (Responsive.isDesktop(context))
                        ? Row(
                            children: [
                              Expanded(child: pieceJustificativeWidget()),
                              const SizedBox(width: p20),
                              Expanded(child: montantWidget()),
                            ],
                          )
                        : Column(
                            children: [
                              pieceJustificativeWidget(),
                              const SizedBox(width: p20),
                              montantWidget(),
                            ],
                          ),
                    const SizedBox(
                      height: p20,
                    ),
                    if (data.approbationDG == "-" || data.approbationDD == "-")
                      Text('Dette Non approuvé!',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold)),
                    if (data.approbationDG == "Approved" &&
                        data.approbationDD == "Approved")
                      BtnWidget(
                          title: 'Soumettre',
                          isLoading: isLoading,
                          press: () {
                            final form = _formKey.currentState!;
                            if (form.validate()) {
                              creanceDette(data);
                              form.reset();
                            }
                          })
                  ],
                ),
              ),
            ));
          });
        });
  }

  Widget nomCompletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomCompletController,
          maxLength: 100,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom complet',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget pieceJustificativeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: pieceJustificativeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'N° de la pièce justificative',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget libelleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: libelleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Libellé',
          ),
          keyboardType: TextInputType.text,
          validator: (value) => value != null && value.isEmpty
              ? 'Ce champs est obligatoire.'
              : null,
          style: const TextStyle(),
        ));
  }

  Widget montantWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: montantController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    labelText: 'Montant',
                    hintText:
                        'Restant ${NumberFormat.decimalPattern('fr').format(total)} \$'),
                validator: (value) => value != null && value.isEmpty
                    ? 'Ce champs est obligatoire.'
                    : null,
                style: const TextStyle(),
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text(
                  "\$",
                  style: headline6!,
                ))
          ],
        ));
  }

  Future<void> creanceDette(DetteModel data) async {
    final creanceDetteModel = CreanceDetteModel(
        reference: data.createdRef,
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        creanceDette: "dettes",
        signature: user.matricule,
        created: DateTime.now());
    await CreanceDetteApi().insertData(creanceDetteModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Remboursement effectué!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
