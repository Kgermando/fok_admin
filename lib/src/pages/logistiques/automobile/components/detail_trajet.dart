import 'package:fokad_admin/src/pages/logistiques/plateforms/desktop/trajet_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/mobile/trajet_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/tablet/trajet_approbation_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/trajet_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';

class DetailTrajet extends StatefulWidget {
  const DetailTrajet({Key? key}) : super(key: key);

  @override
  State<DetailTrajet> createState() => _DetailTrajetState();
}

class _DetailTrajetState extends State<DetailTrajet> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
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
                    child: FutureBuilder<TrajetModel>(
                        future: TrajetApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<TrajetModel> snapshot) {
                          if (snapshot.hasData) {
                            TrajetModel? data = snapshot.data;
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
                                    // LayoutBuilder(
                                    //     builder: (context, constraints) {
                                    //   if (constraints.maxWidth >= 1100) {
                                    //     return TrajetApprobationDesktop(
                                    //         trajetModel: data, user: user);
                                    //   } else if (constraints.maxWidth < 1100 &&
                                    //       constraints.maxWidth >= 650) {
                                    //     return TrajetApprobationTablet(
                                    //         trajetModel: data, user: user);
                                    //   } else {
                                    //     return TrajetApprobationMobile(
                                    //         trajetModel: data, user: user);
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

  Widget pageDetail(TrajetModel data) {
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
                  TitleWidget(title: data.nomUtilisateur),
                  Column(
                    children: [
                      if (int.parse(user.role) <= 3 &&
                          data.approbationDD == "-")
                        Row(
                          children: [
                            IconButton(
                                tooltip: "Mettre à jour kilometrage retour",
                                onPressed: () {
                                  Navigator.pushNamed(context,
                                      LogistiqueRoutes.logTrajetAutoUpdate,
                                      arguments: data);
                                },
                                icon: Icon(
                                  Icons.traffic_outlined,
                                  color: Colors.green.shade700,
                                )),
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
                  )
                ],
              ),
              dataWidget(data),
            ],
          ),
        ),
      ),
    ]);
  }

  alertDeleteDialog(TrajetModel data) {
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
                    await TrajetApi()
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

  Widget dataWidget(TrajetModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Numero attribué :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.nomeroEntreprise,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Numero attribué :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.nomeroEntreprise,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Nom complet(chauffeur) :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.nomUtilisateur,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Nom complet(chauffeur) :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.nomUtilisateur,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Trajet De... :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.trajetDe,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Trajet De... :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.trajetDe,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Trajet A... :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.trajetA,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Trajet A... :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.trajetA,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Mission :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.mission,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Mission :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.mission,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Kilometrage de sorite :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText("${data.kilometrageSorite} km/h",
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Kilometrage de sorite :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText("${data.kilometrageSorite} km/h",
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Kilometrage de retour :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText("${data.kilometrageRetour} km/h",
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Kilometrage de retour :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText("${data.kilometrageRetour} km/h",
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
          Divider(
            color: mainColor,
          ),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    Text('Signature :',
                        textAlign: TextAlign.start,
                        style:
                            bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    SelectableText(data.signature,
                        textAlign: TextAlign.start, style: bodyMedium),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('Signature :',
                          textAlign: TextAlign.start,
                          style:
                              bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 3,
                      child: SelectableText(data.signature,
                          textAlign: TextAlign.start, style: bodyMedium),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
