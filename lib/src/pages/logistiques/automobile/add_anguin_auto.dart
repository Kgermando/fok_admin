import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/logistiques/anguin_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/enguins_dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddAnguinAuto extends StatefulWidget {
  const AddAnguinAuto({Key? key}) : super(key: key);

  @override
  State<AddAnguinAuto> createState() => _AddAnguinAutoState();
}

class _AddAnguinAutoState extends State<AddAnguinAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final genreDrop = EnguinsDropdown().enginDropdown;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController modeleController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController numeroChassieController = TextEditingController();
  final TextEditingController couleurController = TextEditingController();
  String? genre;
  final TextEditingController qtyMaxReservoirController =
      TextEditingController();
  final TextEditingController dateFabricationController =
      TextEditingController();
  final TextEditingController nomeroPLaqueController = TextEditingController();
  final TextEditingController kilometrageInitialeController =
      TextEditingController();
  final TextEditingController provenanceController = TextEditingController();
  final TextEditingController typeCaburantController = TextEditingController();
  final TextEditingController typeMoteurController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  int numberPlaque = 0;
  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    if (mounted) {
      setState(() {
        signature = userModel.matricule;
      });
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    modeleController.dispose();
    marqueController.dispose();
    numeroChassieController.dispose();
    couleurController.dispose();
    qtyMaxReservoirController.dispose();
    dateFabricationController.dispose();
    nomeroPLaqueController.dispose();
    kilometrageInitialeController.dispose();
    provenanceController.dispose();
    typeCaburantController.dispose();
    typeMoteurController.dispose();

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
                    child: FutureBuilder<List<AnguinModel>>(
                        future: AnguinApi().getAllData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<AnguinModel>> snapshot) {
                          if (snapshot.hasData) {
                            List<AnguinModel>? data = snapshot.data;
                            numberPlaque = data!.length;
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
                                        child: addAgentWidget()))
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
                    const TitleWidget(title: "Ajout Engin"),
                    const SizedBox(
                      height: p20,
                    ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [nomWidget(), modeleWidget()],
                          )
                        : Row(
                            children: [
                              Expanded(child: nomWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: modeleWidget())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [marqueWidget(), numeroChassieWidget()],
                          )
                        : Row(
                            children: [
                              Expanded(child: marqueWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: numeroChassieWidget())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [couleurNomWidget(), genreWidget()],
                          )
                        : Row(
                            children: [
                              Expanded(child: couleurNomWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: genreWidget())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              qtyMaxReservoirWidget(),
                              dateFabricationWidget()
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: qtyMaxReservoirWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: dateFabricationWidget())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [
                              nomeroPLaqueWidget(),
                              nomeroEntrepriseWidget()
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: nomeroPLaqueWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: nomeroEntrepriseWidget())
                            ],
                          ),
                    Responsive.isMobile(context)
                        ? Row(
                            children: [
                              kilometrageInitialeWidget(),
                              provenanceWidget()
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: kilometrageInitialeWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: provenanceWidget())
                            ],
                          ),
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

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Nom de l'engin",
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

  Widget modeleWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: modeleController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Modèle',
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

  Widget marqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: marqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Marque',
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

  Widget numeroChassieWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroChassieController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numéro chassie',
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

  Widget couleurNomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: couleurController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Couleur',
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

  Widget genreWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: genre,
        isExpanded: true,
        validator: (value) => value == null ? "Select Type" : null,
        items: genreDrop.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            genre = value;
          });
        },
      ),
    );
  }

  Widget qtyMaxReservoirWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: qtyMaxReservoirController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Quantité max reservoir en litre',
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

  Widget dateFabricationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de fabrication',
          ),
          controller: dateFabricationController,
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

  Widget nomeroPLaqueWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomeroPLaqueController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numéro plaque',
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

  Widget nomeroEntrepriseWidget() {
    String numero = '';
    if (numberPlaque < 10) {
      numero = "00$numberPlaque";
    } else if (numberPlaque < 99) {
      numero = "0$numberPlaque";
    } else {
      numero = "$numberPlaque";
    }
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Text(
          "Identifiant N° $numero",
          style: Theme.of(context).textTheme.headline6,
        ));
  }

  Widget kilometrageInitialeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: kilometrageInitialeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Kilometrage par heure',
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

  Widget provenanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: provenanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Provenance(Pays)',
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

  Future<void> submit() async {
    String numero = '';
    if (numberPlaque < 10) {
      numero = "00$numberPlaque";
    } else if (numberPlaque < 99) {
      numero = "0$numberPlaque";
    } else {
      numero = "$numberPlaque";
    }
    final anguinModel = AnguinModel(
        nom: nomController.text,
        modele: modeleController.text,
        marque: marqueController.text,
        numeroChassie: numeroChassieController.text,
        couleur: couleurController.text,
        genre: genre.toString(),
        qtyMaxReservoir: qtyMaxReservoirController.text,
        dateFabrication: DateTime.parse(dateFabricationController.text),
        nomeroPLaque: nomeroPLaqueController.text,
        nomeroEntreprise: numero,
        kilometrageInitiale: kilometrageInitialeController.text,
        provenance: provenanceController.text,
        typeCaburant: typeCaburantController.text,
        typeMoteur: typeMoteurController.text,
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDG: 'Approved',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: 'Approved',
        motifDD: '-',
        signatureDD: '-');

    await AnguinApi().insertData(anguinModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
