import 'dart:io';

import 'package:fokad_admin/src/widgets/file_uploader.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/agent_count_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:dospace/dospace.dart' as dospace;

class UpdateAgentTablet extends StatefulWidget {
  const UpdateAgentTablet(
      {Key? key,
      required this.departementList,
      required this.typeContratList,
      required this.sexeList,
      required this.world,
      required this.fonctionAdminList,
      required this.fonctionrhList,
      required this.fonctionfinList,
      required this.fonctionbudList,
      required this.fonctioncompteList,
      required this.fonctionexpList,
      required this.fonctioncommList,
      required this.fonctionlogList,
      required this.serviceAffectationAdmin,
      required this.serviceAffectationRH,
      required this.serviceAffectationFin,
      required this.serviceAffectationBud,
      required this.serviceAffectationCompt,
      required this.serviceAffectationEXp,
      required this.serviceAffectationComm,
      required this.serviceAffectationLog,
      required this.agentModel, required this.fonctionActionnaireList, required this.serviceAffectationActionnaire})
      : super(key: key);
  final List<String> departementList;
  final List<String> typeContratList;
  final List<String> sexeList;
  final List<String> world;
  final List<String> fonctionActionnaireList;
  final List<String> fonctionAdminList;
  final List<String> fonctionrhList;
  final List<String> fonctionfinList;
  final List<String> fonctionbudList;
  final List<String> fonctioncompteList;
  final List<String> fonctionexpList;
  final List<String> fonctioncommList;
  final List<String> fonctionlogList;
  final List<String> serviceAffectationActionnaire;
  final List<String> serviceAffectationAdmin;
  final List<String> serviceAffectationRH;
  final List<String> serviceAffectationFin;
  final List<String> serviceAffectationBud;
  final List<String> serviceAffectationCompt;
  final List<String> serviceAffectationEXp;
  final List<String> serviceAffectationComm;
  final List<String> serviceAffectationLog;
  final AgentModel agentModel;

  @override
  State<UpdateAgentTablet> createState() => _UpdateAgentTabletState();
}

class _UpdateAgentTabletState extends State<UpdateAgentTablet> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController nomController = TextEditingController();
  TextEditingController postNomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController numeroSecuriteSocialeController =
      TextEditingController();
  TextEditingController dateNaissanceController = TextEditingController();
  TextEditingController lieuNaissanceController = TextEditingController();

  TextEditingController dateDebutContratController = TextEditingController();
  TextEditingController dateFinContratController = TextEditingController();
  TextEditingController competanceController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController salaireController = TextEditingController();

  String matricule = "";
  String sexe = "";
  String role = "";
  String nationalite = "";
  String departement = "";
  String typeContrat = "";
  String servicesAffectation = "";
  String fonctionOccupe = "";
  DateTime createdAt = DateTime.now();
  String statutAgent = "";
  String photo = "";

  UserModel? user;
  List<String> servAffectList = [];
  List<String> fonctionList = [];

  @override
  void initState() {
    photo = widget.agentModel.photo!;
    matricule = widget.agentModel.matricule;
    sexe = widget.agentModel.sexe;
    role = widget.agentModel.role;
    nationalite = widget.agentModel.nationalite;
    departement = widget.agentModel.departement;
    typeContrat = widget.agentModel.typeContrat;
    servicesAffectation = widget.agentModel.servicesAffectation;
    fonctionOccupe = widget.agentModel.fonctionOccupe;
    createdAt = widget.agentModel.createdAt;
    statutAgent = widget.agentModel.statutAgent;
    // photo = agentModel.photo!;
    nomController = TextEditingController(text: widget.agentModel.nom);
    postNomController = TextEditingController(text: widget.agentModel.postNom);
    prenomController = TextEditingController(text: widget.agentModel.prenom);
    emailController = TextEditingController(text: widget.agentModel.email);
    telephoneController =
        TextEditingController(text: widget.agentModel.telephone);
    adresseController = TextEditingController(text: widget.agentModel.adresse);
    numeroSecuriteSocialeController =
        TextEditingController(text: widget.agentModel.numeroSecuriteSociale);
    dateNaissanceController =
        TextEditingController(text: widget.agentModel.dateNaissance.toString());
    dateNaissanceController =
        TextEditingController(text: widget.agentModel.dateNaissance.toString());
    lieuNaissanceController =
        TextEditingController(text: widget.agentModel.lieuNaissance);
    dateDebutContratController = TextEditingController(
        text: widget.agentModel.dateDebutContrat.toString());
    dateFinContratController = TextEditingController(
        text: widget.agentModel.dateFinContrat.toString());
    competanceController =
        TextEditingController(text: widget.agentModel.competance);
    experienceController =
        TextEditingController(text: widget.agentModel.experience);
    salaireController = TextEditingController(text: widget.agentModel.salaire);
 
    super.initState();
  }

  @override
  void dispose() {
    nomController.dispose();
    postNomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    numeroSecuriteSocialeController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    dateDebutContratController.dispose();
    dateFinContratController.dispose();
    competanceController.dispose();
    experienceController.dispose();
    salaireController.dispose();

    super.dispose();
  }

  bool isUploading = false;
  bool isUploadingDone = false;
  String? uploadedFileUrl;

  void _photeUpload(File pdfFile) async {
    String projectName = "fokad-spaces";
    String region = "sfo3";
    String folderName = "profile";
    String? photoFileName;

    String extension = 'png';
    photoFileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

    uploadedFileUrl =
        "https://$projectName.$region.digitaloceanspaces.com/$folderName/$photoFileName";

    setState(() {
      isUploading = true;
    });
    dospace.Bucket bucketphoto = FileUploader().spaces.bucket('fokad-spaces');
    String? profile = await bucketphoto.uploadFile('$folderName/$photoFileName',
        pdfFile, 'application/png', dospace.Permissions.public);
    setState(() {
      isUploading = false;
      isUploadingDone = true;
    });
    if (kDebugMode) {
      print('upload: $profile');
      print('done');
    }
  }

  @override
  Widget build(BuildContext context) {
    return updateAgentWidget();
  }

  Widget updateAgentWidget() {
    return FutureBuilder<AgentCountModel>(
        future: AgentsApi().getCount(),
        builder:
            (BuildContext context, AsyncSnapshot<AgentCountModel> snapshot) {
          if (snapshot.hasData) {
            AgentCountModel? agentCount = snapshot.data;

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
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                TitleWidget(title: 'Mettre à jour'),
                              ],
                            ),
                            const SizedBox(
                              height: p20,
                            ),
                            fichierWidget(),
                            Row(
                              children: [
                                Expanded(child: nomWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: postNomWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: prenomWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: sexeWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: dateNaissanceWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: lieuNaissanceWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: nationaliteWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: adresseWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: emailWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: telephoneWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: departmentWidget(agentCount!)),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: servicesAffectationWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: matriculeWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: numeroSecuriteSocialeWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: fonctionOccupeWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: roleWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: typeContratWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                Expanded(child: salaireWidget())
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(child: dateDebutContratWidget()),
                                const SizedBox(
                                  width: p10,
                                ),
                                if (typeContrat == 'CDD')
                                  Expanded(child: dateFinContratWidget())
                              ],
                            ),
                            competanceWidget(),
                            const SizedBox(
                              width: p10,
                            ),
                            experienceWidget(),
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
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        "Enregistrer agent avec succès!"),
                                    backgroundColor: Colors.green[700],
                                  ));
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: loadingMega());
          }
        });
  }

  Widget fichierWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: isUploading
            ? SizedBox(height: 50.0, width: 50.0, child: loadingMini())
            : TextButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg'],
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    _photeUpload(file);
                  } else {
                    const Text("Le fichier n'existe pas");
                  }
                },
                icon: isUploadingDone
                    ? Icon(Icons.check_circle_outline,
                        color: Colors.green.shade700)
                    : const Icon(Icons.person),
                label: isUploadingDone
                    ? Text("Téléchargement terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Photo profile",
                        style: Theme.of(context).textTheme.bodyLarge)));
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

  Widget postNomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: postNomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Post-Nom',
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

  Widget prenomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: prenomController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Prénom',
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

  Widget emailWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Email',
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(),
          validator: (value) => RegExpIsValide().validateEmail(value),
        ));
  }

  Widget telephoneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: telephoneController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
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

  Widget adresseWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: adresseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
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

  Widget sexeWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Sexe',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: sexe,
        isExpanded: true,
        items: widget.sexeList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Sexe" : null,
        onChanged: (value) {
          setState(() {
            sexe = value!;
          });
        },
      ),
    );
  }

  Widget roleWidget() {
    List<String> roleList = [];

    return FutureBuilder<UserModel>(
        future: AuthApi().getUserId(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            if (int.parse(user!.role) == 0) {
              roleList = Dropdown().roleAdmin;
            } else if (int.parse(user!.role) <= 3) {
              roleList = Dropdown().roleSuperieur;
            } else if (int.parse(user!.role) > 3) {
              roleList = Dropdown().roleAgent;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: p20),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Niveau d\'accréditation',
                        labelStyle: const TextStyle(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 5.0),
                      ),
                      value: role,
                      isExpanded: true,
                      items: roleList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? "Select accréditation" : null,
                      onChanged: (value) {
                        setState(() {
                          role = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          tooltip: "Besoin d'aide ?",
                          color: Colors.red.shade700,
                          onPressed: () {
                            helpDialog();
                          },
                          icon: const Icon(Icons.help)))
                ],
              ),
            );
          } else {
            return const LinearProgressIndicator();
          }
        });
  }

  Widget matriculeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          readOnly: true,
          initialValue: matricule,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: matricule,
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
        ));
  }

  Widget numeroSecuriteSocialeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: numeroSecuriteSocialeController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Numero Sécurité Sociale',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget dateNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de naissance',
          ),
          controller: dateNaissanceController,
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

  Widget lieuNaissanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: lieuNaissanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Lieu de naissance',
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

  Widget nationaliteWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Nationalite',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: nationalite,
        isExpanded: true,
        items: widget.world.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select Nationalite" : null,
        onChanged: (value) {
          setState(() {
            nationalite = value!;
          });
        },
      ),
    );
  }

  Widget typeContratWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Type de contrat',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: typeContrat,
        isExpanded: true,
        items: widget.typeContratList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select contrat" : null,
        onChanged: (value) {
          setState(() {
            typeContrat = value!;
          });
        },
      ),
    );
  }

  Widget departmentWidget(AgentCountModel agentCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Département',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: departement,
        isExpanded: true,
        items: widget.departementList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) => value == null ? "Select departement" : null,
        onChanged: (value) {
          setState(() {
            departement = value!;
            fonctionList.clear();
            servAffectList.clear(); 
            if (departement == 'Actionnaire') {
              fonctionList = widget.fonctionActionnaireList;
              servAffectList = widget.serviceAffectationActionnaire;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationActionnaire.first;
            } else if (departement == 'Administration') {
              fonctionList = widget.fonctionAdminList;
              servAffectList = widget.serviceAffectationAdmin;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationAdmin.first;
            } else if (departement == 'Finances') {
              // matricule = "${fokad}FIN$date-${agentCount.count + 1}";
              fonctionList = widget.fonctionfinList;
              servAffectList = widget.serviceAffectationFin;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationFin.first;
            } else if (departement == 'Comptabilites') {
              // matricule = "${fokad}CPT$date-${agentCount.count + 1}";
              fonctionList = widget.fonctioncompteList;
              servAffectList = widget.serviceAffectationCompt;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationCompt.first;
            } else if (departement == 'Budgets') {
              // matricule = "${fokad}BUD$date-${agentCount.count + 1}";
              fonctionList = widget.fonctionbudList;
              servAffectList = widget.serviceAffectationBud;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationBud.first;
            } else if (departement == 'Ressources Humaines') {
              // matricule = "${fokad}RH$date-${agentCount.count + 1}";
              fonctionList = widget.fonctionrhList;
              servAffectList = widget.serviceAffectationRH;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationRH.first;
            } else if (departement == 'Exploitations') {
              // matricule = "${fokad}EXP$date-${agentCount.count + 1}";
              fonctionList = widget.fonctionexpList;
              servAffectList = widget.serviceAffectationEXp;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationEXp.first;
            } else if (departement == 'Commercial et Marketing') {
              // matricule = "${fokad}COM$date-${agentCount.count + 1}";
              fonctionList = widget.fonctioncommList;
              servAffectList = widget.serviceAffectationComm;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationComm.first;
            } else if (departement == 'Logistique') {
              // matricule = "${fokad}LOG$date-${agentCount.count + 1}";
              fonctionList = widget.fonctionlogList;
              servAffectList = widget.serviceAffectationLog;
              fonctionOccupe = fonctionList.first;
              servicesAffectation = widget.serviceAffectationLog.first;
            } else {
              setState(() {
                fonctionList = [];
                servAffectList = [];
              });
            }
          });
        },
      ),
    );
  }

  Widget servicesAffectationWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Service d\'affectation',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: servicesAffectation,
          isExpanded: true,
          items: servAffectList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select Service" : null,
          onChanged: (value) {
            setState(() {
              servicesAffectation = value!;
            });
          },
        ));
  }

  Widget dateDebutContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de début du Contrat',
          ),
          controller: dateDebutContratController,
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

  Widget dateFinContratWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Date de Fin du Contrat',
          ),
          controller: dateFinContratController,
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

  Widget fonctionOccupeWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Fonction occupée',
            labelStyle: const TextStyle(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding: const EdgeInsets.only(left: 5.0),
          ),
          value: fonctionOccupe,
          isExpanded: true,
          items: fonctionList
              .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toSet()
              .toList(),
          validator: (value) => value == null ? "Select Fonction" : null,
          onChanged: (value) {
            setState(() {
              fonctionOccupe = value!;
            });
          },
        ));
  }

  Widget competanceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 100,
          controller: competanceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Formation',
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

  Widget experienceWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 100,
          controller: experienceController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Experience',
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

  Widget salaireWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: salaireController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Salaire',
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
              ),
            ),
            const SizedBox(width: p20),
            Expanded(
                flex: 1,
                child: Text("\$", style: Theme.of(context).textTheme.headline6))
          ],
        ));
  }

  helpDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Accreditation'),
              content: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Niveau 1: Directeur général, PCA, Président ...",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 2: Directeur département",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 3: Chef de service",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 4: Personnel travailleur (Agent)",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: p8),
                      Text("Niveau 5: Stagiaire, Expert, Consultant, ...",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Future submit() async {
    final agentModel = AgentModel(
        id: widget.agentModel.id,
        nom: (nomController.text == '')
            ? widget.agentModel.nom
            : nomController.text,
        postNom: (postNomController.text == '')
            ? widget.agentModel.postNom
            : postNomController.text,
        prenom: (prenomController.text == '')
            ? widget.agentModel.prenom
            : prenomController.text,
        email: (emailController.text == '')
            ? widget.agentModel.email
            : emailController.text,
        telephone: (telephoneController.text == '')
            ? widget.agentModel.telephone
            : telephoneController.text,
        adresse: (adresseController.text == '')
            ? widget.agentModel.adresse
            : adresseController.text,
        sexe:
            (sexe.toString() == '') ? widget.agentModel.sexe : sexe.toString(),
        role:
            (role.toString() == '') ? widget.agentModel.role : role.toString(),
        matricule: widget.agentModel.matricule,
        numeroSecuriteSociale: (numeroSecuriteSocialeController.text == "")
            ? widget.agentModel.numeroSecuriteSociale
            : numeroSecuriteSocialeController.text,
        dateNaissance: (dateNaissanceController.text == '')
            ? widget.agentModel.dateNaissance
            : DateTime.parse(dateNaissanceController.text),
        lieuNaissance: (lieuNaissanceController.text == '')
            ? widget.agentModel.lieuNaissance
            : lieuNaissanceController.text,
        nationalite: (nationalite.toString() == '')
            ? widget.agentModel.nationalite
            : nationalite.toString(),
        typeContrat: (typeContrat.toString() == '')
            ? widget.agentModel.typeContrat
            : typeContrat.toString(),
        departement: (departement.toString() == '')
            ? widget.agentModel.departement
            : departement.toString(),
        servicesAffectation: (servicesAffectation.toString() == '')
            ? widget.agentModel.servicesAffectation
            : servicesAffectation.toString(),
        dateDebutContrat: (dateDebutContratController.text == '')
            ? widget.agentModel.dateDebutContrat
            : DateTime.parse(dateDebutContratController.text),
        dateFinContrat: (dateFinContratController.text == '')
            ? widget.agentModel.dateFinContrat
            : DateTime.parse(dateFinContratController.text),
        fonctionOccupe: (fonctionOccupe.toString() == '')
            ? widget.agentModel.fonctionOccupe
            : fonctionOccupe.toString(),
        competance: (competanceController.text == '')
            ? widget.agentModel.competance
            : competanceController.text,
        experience: (experienceController.text == '')
            ? widget.agentModel.experience
            : experienceController.text,
        statutAgent: widget.agentModel.statutAgent,
        createdAt: DateTime.now(),
        photo: (uploadedFileUrl == '')
            ? widget.agentModel.photo
            : uploadedFileUrl.toString(),
        salaire: (salaireController.text == '')
            ? widget.agentModel.salaire
            : salaireController.text,
        signature: user!.matricule.toString(),
        created: DateTime.now(),
        approbationDG: '-',
        motifDG: '-',
        signatureDG: '-',
        approbationDD: '-',
        motifDD: '-',
        signatureDD: '-');

    await AgentsApi().updateData(agentModel);
  }
}
