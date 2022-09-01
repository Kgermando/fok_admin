import 'package:fokad_admin/src/pages/logistiques/plateforms/desktop/etat_materiel_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/mobile/etat_materiel_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/tablet/etat_materiel_approbation_tablet.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/etat_materiel_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailEtatMateriel extends StatefulWidget {
  const DetailEtatMateriel({Key? key}) : super(key: key);

  @override
  State<DetailEtatMateriel> createState() => _DetailEtatMaterielState();
}

class _DetailEtatMaterielState extends State<DetailEtatMateriel> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  // Approbations
  String approbationDD = '-';
  TextEditingController motifDDController = TextEditingController();

  String? statutObjet;
  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
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

  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
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
                    child: FutureBuilder<EtatMaterielModel>(
                        future: EtatMaterielApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<EtatMaterielModel> snapshot) {
                          if (snapshot.hasData) {
                            EtatMaterielModel? data = snapshot.data;
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
                                        child: Column(
                                  children: [
                                    pageDetail(data!),
                                    const SizedBox(height: p10),
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      if (constraints.maxWidth >= 1100) {
                                        return EtatMaterielApprobationDesktop(
                                            etatMaterielModel: data,
                                            user: user);
                                      } else if (constraints.maxWidth < 1100 &&
                                          constraints.maxWidth >= 650) {
                                        return EtatMaterielApprobationTablet(
                                            etatMaterielModel: data,
                                            user: user);
                                      } else {
                                        return EtatMaterielApprobationMobile(
                                            etatMaterielModel: data,
                                            user: user);
                                      }
                                    })
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

  Widget pageDetail(EtatMaterielModel data) {
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
                  const TitleWidget(title: "Etat Materiel"),
                  Column(
                    children: [
                      Column(
                        children: [
                          if (int.parse(user.role) <= 3 &&
                              data.approbationDD == "Approved")
                            Row(
                              children: [
                                IconButton(
                                    tooltip: 'Modifier',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context,
                                          LogistiqueRoutes
                                              .logEtatMaterielUpdate,
                                          arguments: data);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    tooltip: 'Supprimer',
                                    onPressed: () async {
                                      alertDeleteDialog(data);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red.shade700),
                              ],
                            ),
                          SelectableText(
                              DateFormat("dd-MM-yy HH:mm").format(data.created),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              dataWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  alertDeleteDialog(EtatMaterielModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Etes-vous sûr de vouloir faire ceci ?'),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("Cette action permet de supprimer le document")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    await EtatMaterielApi()
                        .deleteData(data.id!)
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget dataWidget(EtatMaterielModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Modèle :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.modele,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Marque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.marque,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Type d\'Objet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.typeObjet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          if (user.fonctionOccupe == "Directeur de departement")
            Row(
              children: [
                Expanded(
                  child: Text('Changez Statut :',
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: statutWidget(data),
                )
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Text('Statut :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              if (data.statut == 'Actif')
                Expanded(
                  child: SelectableText(data.statut,
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(color: Colors.green.shade700)),
                ),
              if (data.statut == 'Inactif')
                Expanded(
                  child: SelectableText(data.statut,
                      textAlign: TextAlign.start,
                      style:
                          bodyMedium.copyWith(color: Colors.orange.shade700)),
                ),
              if (data.statut == 'Déclasser')
                Expanded(
                  child: SelectableText(data.statut,
                      textAlign: TextAlign.start,
                      style: bodyMedium.copyWith(color: Colors.red.shade700)),
                )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget statutWidget(EtatMaterielModel data) {
    List<String> statutObjetList = ["Actif", "Inactif", "Déclasser"];
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Statut',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: statutObjet,
        isExpanded: true,
        items: statutObjetList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            statutObjet = value!;
            submitStatut(data);
          });
        },
      ),
    );
  }

  Future<void> submitStatut(EtatMaterielModel data) async {
    final etatMaterielModel = EtatMaterielModel(
      id: data.id!,
      nom: data.nom,
      modele: data.modele,
      marque: data.marque,
      typeObjet: data.typeObjet,
      statut: statutObjet.toString(),
      signature: data.signature,
      createdRef: data.createdRef,
      created: data.created,
      approbationDD: data.approbationDD,
      motifDD: data.motifDD,
      signatureDD: data.signatureDD,
    );
    await EtatMaterielApi().updateData(etatMaterielModel).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Soumis avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
