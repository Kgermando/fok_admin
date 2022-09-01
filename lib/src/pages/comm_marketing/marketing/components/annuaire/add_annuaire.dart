import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class AddAnnuaire extends StatefulWidget {
  const AddAnnuaire({Key? key}) : super(key: key);

  @override
  State<AddAnnuaire> createState() => _AddAnnuaireState();
}

class _AddAnnuaireState extends State<AddAnnuaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController nomPostnomPrenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobile1Controller = TextEditingController();
  TextEditingController mobile2Controller = TextEditingController();
  TextEditingController secteurActiviteController = TextEditingController();
  TextEditingController nomEntrepriseController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController adresseEntrepriseController = TextEditingController();

  int? id;
  String? categorie;

  @override
  void initState() {
    getData();
    super.initState();
  }

  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  void dispose() {
    nomPostnomPrenomController.dispose();
    emailController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    secteurActiviteController.dispose();
    nomEntrepriseController.dispose();
    gradeController.dispose();
    adresseEntrepriseController.dispose();
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
                                  title: Responsive.isDesktop(context)
                                      ? 'Commercial & Marketing'
                                      : 'Comm. & Mark.',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: addPageWidget()))
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        TitleWidget(title: "Ajout contact"),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    categorieField(),
                    (Responsive.isMobile(context))
                        ? Column(
                            children: [
                              nomPostnomPrenomField(),
                              emailField(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: nomPostnomPrenomField(),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: emailField(),
                              )
                            ],
                          ),
                    (Responsive.isMobile(context))
                        ? Column(
                            children: [mobile1Field(), mobile2Field()],
                          )
                        : Row(
                            children: [
                              Expanded(child: mobile1Field()),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(child: mobile2Field()),
                            ],
                          ),
                    (Responsive.isMobile(context))
                        ? Column(
                            children: [
                              secteurActiviteField(),
                              nomEntrepriseField()
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: secteurActiviteField()),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(child: nomEntrepriseField()),
                            ],
                          ),
                    gradeField(),
                    adresseEntrepriseField(),
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

  Widget categorieField() {
    List<String> categorieList = ['Fournisseur', 'Client', 'Partenaire'];
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contact',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: categorie,
        isExpanded: true,
        items: categorieList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            categorie = value;
          });
        },
      ),
    );
  }

  Widget nomPostnomPrenomField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: nomPostnomPrenomController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nom complet',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Ce champ est obligatoire';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget mobile1Field() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: mobile1Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Téléphone 1',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  Widget mobile2Field() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: mobile2Controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Téléphone 2',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Ce champ est obligatoire';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Widget secteurActiviteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: secteurActiviteController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Secteur d\'activité',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget nomEntrepriseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: nomEntrepriseController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Entreprise ou business',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget gradeField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: gradeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Grade ou Fonction',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        // validator: (value) {
        //   if (value != null && value.isEmpty) {
        //     return 'Ce champs est obligatoire';
        //   } else {
        //     return null;
        //   }
        // },
      ),
    );
  }

  Widget adresseEntrepriseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: adresseEntrepriseController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Adresse',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    final annuaireModel = AnnuaireModel(
        categorie: categorie.toString(),
        nomPostnomPrenom: nomPostnomPrenomController.text,
        email: emailController.text,
        mobile1: mobile1Controller.text,
        mobile2: mobile2Controller.text,
        secteurActivite: secteurActiviteController.text,
        nomEntreprise: nomEntrepriseController.text,
        grade: gradeController.text,
        adresseEntreprise: adresseEntrepriseController.text,
        succursale: user!.succursale,
        signature: user!.matricule,
        created: DateTime.now());
    await AnnuaireApi().insertData(annuaireModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
