import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddTrajetAuto extends StatefulWidget {
  const AddTrajetAuto({Key? key}) : super(key: key);

  @override
  State<AddTrajetAuto> createState() => _AddTrajetAutoState();
}

class _AddTrajetAutoState extends State<AddTrajetAuto> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nomeroEntrepriseController = TextEditingController();
  final TextEditingController nomUtilisateurController =
      TextEditingController();
  final TextEditingController trajetDeController = TextEditingController();
  final TextEditingController trajetAController = TextEditingController();
  final TextEditingController missionController = TextEditingController();
  final TextEditingController kilometrageSoriteController =
      TextEditingController();
  final TextEditingController kilometrageRetourController =
      TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    nomUtilisateurController.dispose();
    trajetDeController.dispose();
    trajetAController.dispose();
    missionController.dispose();
    kilometrageSoriteController.dispose();
    kilometrageRetourController.dispose();

    super.dispose();
  }

  String? signature;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as AnguinModel;
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
                        child: addAgentWidget(data),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addAgentWidget(AnguinModel data) {
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
                    const TitleWidget(title: "Indiquer le Trajet"),
                    const SizedBox(
                      height: p20,
                    ),
                    nomUtilisateurWidget(),
                    Responsive.isMobile(context)
                        ? Column(
                            children: [trajetDeWidget(), trajetAWidget()],
                          )
                        : Row(
                            children: [
                              Expanded(child: trajetDeWidget()),
                              const SizedBox(
                                width: p10,
                              ),
                              Expanded(child: trajetAWidget())
                            ],
                          ),
                    missionWidget(),
                    kilometrageSoriteWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit(data);
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

  // Widget nomeroEntrepriseWidget() {
  //   return Container(
  //       margin: const EdgeInsets.only(bottom: p20),
  //       child: TextFormField(
  //         controller: nomeroEntrepriseController,
  //         readOnly: true,
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  //           labelText: 'Numero de l\'anguin',
  //         ),
  //         keyboardType: TextInputType.text,
  //         style: const TextStyle(),
  //         validator: (value) {
  //           if (value != null && value.isEmpty) {
  //             return 'Ce champs est obligatoire';
  //           } else {
  //             return null;
  //           }
  //         },
  //       ));
  // }

  Widget nomUtilisateurWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomUtilisateurController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du chauffeur',
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

  Widget trajetDeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: trajetDeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'De...',
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

  Widget trajetAWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: trajetAController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'A...',
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

  Widget missionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: missionController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Mission',
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

  Widget kilometrageSoriteWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: kilometrageSoriteController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Kilometrage sorite',
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

  Widget kilometrageRetourWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: kilometrageRetourController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'kilometrage retour',
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

  Future<void> submit(AnguinModel data) async {
    final trajetModel = TrajetModel(
        nomeroEntreprise: data.nomeroEntreprise,
        nomUtilisateur: nomUtilisateurController.text,
        trajetDe: trajetDeController.text,
        trajetA: trajetAController.text,
        mission: missionController.text,
        kilometrageSorite: kilometrageSoriteController.text,
        kilometrageRetour: '-',
        signature: signature.toString(),
        createdRef: DateTime.now(),
        created: DateTime.now(),
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');
    await TrajetApi().insertData(trajetModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
