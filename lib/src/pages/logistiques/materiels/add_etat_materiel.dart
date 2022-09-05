import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/api/logistiques/immobiler_api.dart';
import 'package:fokad_admin/src/api/logistiques/mobilier_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddEtatMateriel extends StatefulWidget {
  const AddEtatMateriel({Key? key}) : super(key: key);

  @override
  State<AddEtatMateriel> createState() => _AddEtatMaterielState();
}

class _AddEtatMaterielState extends State<AddEtatMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? nom;
  String? typeObjet;
  String? statut;

  @override
  initState() {
    getDate();
    super.initState();
  }

  List<String> nomList = [];
  List<MobilierModel> mobilierList = [];
  List<ImmobilierModel> immobilierList = [];
  List<AnguinModel> enguinsList = [];

  String? signature;
  Future<void> getDate() async {
    UserModel userModel = await AuthApi().getUserId();
    var mobiliers = await MobilierApi().getAllData();
    var immobiliers = await ImmobilierApi().getAllData();
    var enguins = await AnguinApi().getAllData();
    setState(() {
      signature = userModel.matricule;
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
                          child: SingleChildScrollView(
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
                child: Column(
                  children: [
                    const TitleWidget(title: "Statut Materiel"),
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
                    statutListWidget(),
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

  Widget statutListWidget() {
    List<String> statutList = ["Actif", "Inactif", "Déclasser"];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Statut',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: statut,
        isExpanded: true,
        items: statutList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Champs obligatoire" : null,
        onChanged: (value) {
          setState(() {
            statut = value!;
          });
        },
      ),
    );
  }

  Future<void> submit() async {
    final etatMaterielModel = EtatMaterielModel(
        nom: nom.toString(),
        modele: '-',
        marque: '-',
        typeObjet: typeObjet.toString(),
        statut: statut.toString(),
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');
    await EtatMaterielApi().insertData(etatMaterielModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
