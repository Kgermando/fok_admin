import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/carburant_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/carburant_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/carburant_dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';

class AddCarburantAuto extends StatefulWidget {
  const AddCarburantAuto({Key? key}) : super(key: key);

  @override
  State<AddCarburantAuto> createState() => _AddCarburantAutoState();
}

class _AddCarburantAutoState extends State<AddCarburantAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<String> carburantDropList = CarburantDropdown().carburantDrop;

  String? operationEntreSortie;
  String? typeCaburant;
  String? fournisseur;
  TextEditingController nomeroFactureAchatController = TextEditingController();
  TextEditingController prixAchatParLitreController = TextEditingController();
  TextEditingController nomReceptionisteController = TextEditingController();
  String? numeroPlaque;
  TextEditingController qtyAchatController = TextEditingController();
  TextEditingController dateHeureSortieAnguinController =
      TextEditingController();

  @override
  initState() {
    date();
    super.initState();
  }

  List<AnguinModel> enginList = [];
  List<AnnuaireModel> annuaireList = [];
  String signature = '-';
  Future<void> date() async {
    UserModel userModel = await AuthApi().getUserId();
    var engins = await AnguinApi().getAllData();
    var annuaires = await AnnuaireApi().getAllData();
    if (mounted) {
      setState(() {
        signature = userModel.matricule;
        enginList = engins
            .where((element) =>
                element.approbationDG == "Approved" &&
                element.approbationDD == "Approved")
            .toList();
        annuaireList = annuaires
            .where((element) => element.categorie == 'Fournisseur')
            .toList();
      });
    }
  }

  @override
  void dispose() {
    nomeroFactureAchatController.dispose();
    prixAchatParLitreController.dispose();
    nomReceptionisteController.dispose();
    qtyAchatController.dispose();
    dateHeureSortieAnguinController.dispose();

    super.dispose();
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
                                  title: 'Logistique',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: addAgentWidget(),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget() {
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
                child: ListView(
                  controller: _controllerScroll,
                  children: [
                    const TitleWidget(title: "Ajout Carburant"),
                    const SizedBox(
                      height: p20,
                    ),
                    Row(
                      children: [
                        Expanded(child: operationEntreSortieWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: typeCaburantWidget())
                      ],
                    ),
                    if (operationEntreSortie == 'Entrer')
                      Row(
                        children: [
                          Expanded(child: fournisseurWidget()),
                          const SizedBox(
                            width: p10,
                          ),
                          Expanded(child: nomeroFactureAchatWidget())
                        ],
                      ),
                    Row(
                      children: [
                        if (operationEntreSortie == 'Entrer')
                          Expanded(child: prixAchatParLitreWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        if (operationEntreSortie == 'Sortie')
                          Expanded(child: nomReceptionisteWidget())
                      ],
                    ),
                    if (operationEntreSortie == 'Sortie')
                      Row(
                        children: [
                          Expanded(child: numeroPlaqueWidget()),
                          const SizedBox(
                            width: p10,
                          ),
                          Expanded(child: dateDebutEtFinWidget())
                        ],
                      ),
                    qtyAchatControllerWidget(),
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

  Widget operationEntreSortieWidget() {
    List<String> typeList = ['Entrer', 'Sortie'];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type d\'operation',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: operationEntreSortie,
        isExpanded: true,
        items: typeList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            operationEntreSortie = value!;
          });
        },
      ),
    );
  }

  Widget typeCaburantWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de carburant',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeCaburant,
        isExpanded: true,
        items: carburantDropList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            typeCaburant = value!;
          });
        },
      ),
    );
  }

  Widget fournisseurWidget() {
    List<String> dataList = [];
    dataList = annuaireList.map((e) => e.nomPostnomPrenom).toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Fournisseur',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: fournisseur,
          isExpanded: true,
          items: dataList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select fournisseur" : null,
          onChanged: (value) {
            setState(() {
              fournisseur = value;
            });
          },
        ));
  }

  Widget nomeroFactureAchatWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomeroFactureAchatController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numero Facture',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (operationEntreSortie == 'Entrer') {
              if (value != null && value.isEmpty) {
                return 'Ce champs est obligatoire';
              } else {
                return null;
              }
            }
            return null;
          },
        ));
  }

  Widget prixAchatParLitreWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prixAchatParLitreController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prix Achat Par Litre',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          style: const TextStyle(),
          validator: (value) {
            if (operationEntreSortie == 'Entrer') {
              if (value != null && value.isEmpty) {
                return 'Ce champs est obligatoire';
              } else {
                return null;
              }
            }
            return null;
          },
        ));
  }

  Widget nomReceptionisteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomReceptionisteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom receptioniste',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (operationEntreSortie == 'Sortie') {
              if (value != null && value.isEmpty) {
                return 'Ce champs est obligatoire';
              } else {
                return null;
              }
            }
            return null;
          },
        ));
  }

  Widget numeroPlaqueWidget() {
    List<String> numPlaque = enginList.map((e) => e.nomeroPLaque).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Numero plaque entreprise',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: numeroPlaque,
        isExpanded: true,
        items: numPlaque.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            numeroPlaque = value!;
          });
        },
      ),
    );
  }

  Widget qtyAchatControllerWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: qtyAchatController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Quantités',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
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

  Widget dateDebutEtFinWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date Heure Sortie',
          ),
          controller: dateHeureSortieAnguinController,
          timePickerEntryModeInput: true,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Future<void> submit() async {
    final carburantModel = CarburantModel(
        operationEntreSortie: operationEntreSortie.toString(),
        typeCaburant: typeCaburant.toString(),
        fournisseur: (fournisseur == '') ? '-' : fournisseur.toString(),
        nomeroFactureAchat: (nomeroFactureAchatController.text == '')
            ? '-'
            : nomeroFactureAchatController.text,
        prixAchatParLitre: (prixAchatParLitreController.text == '')
            ? '-'
            : prixAchatParLitreController.text,
        nomReceptioniste: (nomReceptionisteController.text == '')
            ? '-'
            : nomReceptionisteController.text,
        numeroPlaque: (numeroPlaque == '') ? '-' : numeroPlaque.toString(),
        dateHeureSortieAnguin: DateTime.parse(
            (dateHeureSortieAnguinController.text == '')
                ? "2099-12-31 00:00:00"
                : dateHeureSortieAnguinController.text),
        qtyAchat: qtyAchatController.text,
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');
    await CarburantApi().insertData(carburantModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
