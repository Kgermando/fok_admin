import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/finances/coupure_billet_api.dart';
import 'package:fokad_admin/src/api/finances/fin_exterieur_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/finances/coupure_billet_model.dart';
import 'package:fokad_admin/src/models/finances/fin_exterieur_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddAutreFin extends StatefulWidget {
  const AddAutreFin({Key? key}) : super(key: key);

  @override
  State<AddAutreFin> createState() => _AddAutreFinState();
}

class _AddAutreFinState extends State<AddAutreFin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _coupureBillertKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isCoupureBilletLoading = false;
  bool isLoadingDelete = false;

  final TextEditingController nomCompletController = TextEditingController();
  final TextEditingController pieceJustificativeController =
      TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController deperatmentController = TextEditingController();

  TextEditingController coupureBilletController = TextEditingController();
  TextEditingController nombreBilletController = TextEditingController();

  String? typeOperation;

  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    deperatmentController.dispose();
    coupureBilletController.dispose();
    nombreBilletController.dispose();
    super.dispose();
  }

  String? matricule;
  int numberItem = 0;
  List<CoupureBilletModel> coupureBilletList = [];
  Future<void> getData() async {
    final userModel = await AuthApi().getUserId();
    final data = await FinExterieurApi().getAllData();
    var coupureBillets = await CoupureBilletApi().getAllData();
    if (!mounted) return;
    setState(() {
      matricule = userModel.matricule;
      numberItem = data.length;
      coupureBilletList = coupureBillets
          .where((element) => element.reference == numberItem + 1)
          .toList();
    });
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
                          const SizedBox(width: p10),
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: "Finance",
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: addPageWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addPageWidget() {
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
                height: MediaQuery.of(context).size.height, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        TitleWidget(title: "Autre Financement"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: nomCompletWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: pieceJustificativeWidget())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: libelleWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: montantWidget())
                      ],
                    ),
                    typeOperationWidget(),
                    SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: coupureBilletWidget()),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BtnWidget(
                            title: 'Soumettre',
                            isLoading: isLoading,
                            press: () {
                              final form = _formKey.currentState!;
                              if (form.validate()) {
                                submit();
                                form.reset();
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nomCompletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomCompletController,
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
            labelText: 'N?? de la pi??ce justificative',
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
            labelText: 'Libell??',
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
                ),
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

  Widget coupureBilletWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Form(
      key: _coupureBillertKey,
      child: ListView(
        children: [
          Table(
            border: TableBorder.all(color: mainColor),
            children: [
              TableRow(children: [
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Nombre",
                      textAlign: TextAlign.center, style: headline6),
                ),
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Billet",
                      textAlign: TextAlign.center, style: headline6),
                ),
                Container(
                  padding: const EdgeInsets.all(p8),
                  child: Text("Retirer",
                      textAlign: TextAlign.center, style: headline6),
                ),
              ]),
              for (var item in coupureBilletList)
                TableRow(children: [
                  Container(
                    padding: const EdgeInsets.all(p8),
                    child: Text(item.nombreBillet,
                        textAlign: TextAlign.center, style: bodyLarge),
                  ),
                  Container(
                    padding: const EdgeInsets.all(p8),
                    child: Text("${item.coupureBillet} \$",
                        textAlign: TextAlign.center, style: bodyLarge),
                  ),
                  Container(
                      padding: const EdgeInsets.all(p8),
                      child: (isLoadingDelete)
                          ? SizedBox(
                              height: p20, width: p20, child: loadingMini())
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoadingDelete = true;
                                });
                                await CoupureBilletApi()
                                    .deleteData(item.id!)
                                    .then((value) {
                                  setState(() {
                                    isLoadingDelete = false;
                                  });
                                });
                              },
                              icon: const Icon(Icons.close, color: Colors.red)))
                ]),
              TableRow(children: [
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: TextFormField(
                      controller: nombreBilletController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Ajoutez le nombre ici',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(),
                    )),
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: TextFormField(
                      controller: coupureBilletController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Ajoutez la coupure de billet ici',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(),
                    )),
                Container(
                    padding: const EdgeInsets.all(p8),
                    child: IconButton(
                        tooltip: "Ajout billet",
                        onPressed: () {
                          setState(() {
                            isCoupureBilletLoading = true;
                          });
                          final form = _coupureBillertKey.currentState!;
                          if (form.validate()) {
                            submitCoupureBillet();
                            form.reset();
                          }
                        },
                        icon: Icon(Icons.add,
                            size: 40.0, color: Colors.red.shade700))),
              ]),
            ],
          ),
          const SizedBox(height: p20),
        ],
      ),
    );
  }

  Widget typeOperationWidget() {
    List<String> typeOperationList = ['Depot', 'Retrait'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'Operation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeOperation,
        isExpanded: true,
        items: typeOperationList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select type operation" : null,
        onChanged: (value) {
          setState(() {
            typeOperation = value!;
          });
        },
      ),
    );
  }

  Future submit() async {
    final financeExterieurModel = FinanceExterieurModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: pieceJustificativeController.text,
        libelle: libelleController.text,
        montant: montantController.text,
        typeOperation: typeOperation.toString(),
        numeroOperation: 'Transaction-Autres-Fin-${numberItem + 1}',
        signature: matricule.toString(),
        createdRef: numberItem + 1,
        created: DateTime.now());

    await FinExterieurApi().insertData(financeExterieurModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succ??s!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }

  Future submitCoupureBillet() async {
    final coupureBillet = CoupureBilletModel(
        reference: numberItem + 1,
        nombreBillet: nombreBilletController.text,
        coupureBillet: coupureBilletController.text);
    await CoupureBilletApi().insertData(coupureBillet).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Ajout??!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
