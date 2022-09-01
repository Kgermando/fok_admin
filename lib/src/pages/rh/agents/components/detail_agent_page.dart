import 'package:fokad_admin/src/pages/rh/agents/plateforms/desktop/detail_agent_desktop.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/mobile/detail_agent_mobile.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/tablet/detail_agent_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/administration/actionnaire_api.dart';
import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/api/rh/paiement_salaire_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/administrations/actionnaire_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/paiement_salaire_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailAgentPage extends StatefulWidget {
  const DetailAgentPage({Key? key}) : super(key: key);

  @override
  State<DetailAgentPage> createState() => _DetailAgentPageState();
}

class _DetailAgentPageState extends State<DetailAgentPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<UserModel> userList = [];
  bool isLoading = false;
  bool isLoadingAction = false;
  bool statutAgent = false;

  String statutPersonel = 'false';

  @override
  initState() {
    getData();
    super.initState();
  }

  List<ActionnaireModel> actionnaireList = [];
  List<PaiementSalaireModel> salaireList = [];
  // AgentModel? agentModel;
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
    final data = await UserApi().getAllData();
    var actionnaires = await ActionnaireApi().getAllData();
    var salaires = await PaiementSalaireApi().getAllData();
    if (mounted) {
      setState(() {
        user = userModel;
        userList = data;
        actionnaireList = actionnaires;
        salaireList = salaires
            .where((element) =>
                element.createdAt.month == DateTime.now().month &&
                element.createdAt.year == DateTime.now().year)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton:
            // speedialWidget(agentModel!),
            FutureBuilder<AgentModel>(
                future: AgentsApi().getOneData(id),
                builder:
                    (BuildContext context, AsyncSnapshot<AgentModel> snapshot) {
                  if (snapshot.hasData) {
                    AgentModel? data = snapshot.data;
                    return
                        // speedialWidget(data!);
                        (int.parse(user.role) <= 3)
                            ? speedialWidget(data!)
                            : Container();
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
                    child: FutureBuilder<AgentModel>(
                        future: AgentsApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<AgentModel> snapshot) {
                          if (snapshot.hasData) {
                            AgentModel? agentModel = snapshot.data;
                            if (agentModel!.statutAgent == "true") {
                              statutAgent = true;
                            } else if (agentModel.statutAgent == "false") {
                              statutAgent = false;
                            }
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
                                          title: (Responsive.isDesktop(context))
                                              ? "Ressources Humaines"
                                              : "RH",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (constraints.maxWidth >= 1100) {
                                    return DetailAgentDesktop(
                                        actionnaireList: actionnaireList,
                                        salaireList: salaireList,
                                        userList: userList,
                                        user: user,
                                        agentModel: agentModel);
                                  } else if (constraints.maxWidth < 1100 &&
                                      constraints.maxWidth >= 650) {
                                    return DetailAgentTablet(
                                        actionnaireList: actionnaireList,
                                        salaireList: salaireList,
                                        userList: userList,
                                        user: user,
                                        agentModel: agentModel);
                                  } else {
                                    return DetailAgentMobile(
                                        actionnaireList: actionnaireList,
                                        salaireList: salaireList,
                                        userList: userList,
                                        user: user,
                                        agentModel: agentModel);
                                  }
                                }))
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

  SpeedDial speedialWidget(AgentModel agentModel) {
    var isActif = userList
        .where((element) => element.matricule == agentModel.matricule)
        .toList();
    var isPayE = salaireList
        .where((element) => element.matricule == agentModel.matricule)
        .toList();
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(
            Icons.content_paste_sharp,
            size: 15.0,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange.shade700,
          label: 'Modifier CV profil',
          onPressed: () {
            Navigator.pushNamed(context, RhRoutes.rhAgentUpdate,
                arguments: agentModel);
          },
        ),
        // if (int.parse(user.role) <= 2)
        SpeedDialChild(
          child: const Icon(Icons.safety_divider, size: 15.0),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red.shade700,
          label: (isActif.isEmpty) ? "Activer profil" : "Désactiver le profil",
          onPressed: () {
            agentStatutDialog(agentModel);
          },
        ),
        SpeedDialChild(
            child: const Icon(Icons.monetization_on),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade700,
            label: (isPayE.isEmpty) ? 'Bulletin de paie' : 'Déja générer',
            onPressed: () {
              if (isPayE.isEmpty) {
                Navigator.pushNamed(context, RhRoutes.rhPaiementAdd,
                    arguments: agentModel);
              }
            })
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  agentStatutDialog(AgentModel agentModel) {
    // statutAgent = agentModel.statutAgent;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            if (!isLoading) {
              return AlertDialog(
                title: const Text('Autorisation d\'accès au système'),
                content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Column(
                    children: [
                      FlutterSwitch(
                        width: 225.0,
                        height: 55.0,
                        activeColor: Colors.green,
                        inactiveColor: Colors.red,
                        valueFontSize: 25.0,
                        toggleSize: 45.0,
                        value: statutAgent,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        activeText: 'Active',
                        inactiveText: 'Inactive',
                        onToggle: (val) {
                          // isLoading == true;
                          setState(() {
                            statutAgent = val;
                            String vrai = '';
                            if (statutAgent) {
                              vrai = 'true';
                              statutPersonel = 'true';
                            } else {
                              vrai = 'false';
                              statutPersonel = 'false';
                            }
                            if (vrai == 'true') {
                              createUser(
                                      agentModel.nom,
                                      agentModel.prenom,
                                      agentModel.email,
                                      agentModel.telephone,
                                      agentModel.matricule,
                                      agentModel.departement,
                                      agentModel.servicesAffectation,
                                      agentModel.fonctionOccupe,
                                      agentModel.role)
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Activation reussie avec succès!"),
                                  backgroundColor: Colors.green[700],
                                ));
                              });
                              updateAgent(agentModel).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Mise à jour du statut succès!"),
                                  backgroundColor: Colors.blue[700],
                                ));
                                isLoading == false;
                              });
                            } else if (vrai == 'false') {
                              deleteUser(agentModel).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Suppression de l'accès succès!"),
                                  backgroundColor: Colors.red[700],
                                ));
                              });
                              updateAgent(agentModel).then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Mise à statut reussie avec succès!"),
                                  backgroundColor: Colors.blue[700],
                                ));
                                isLoading == false;
                              });
                            }
                          });

                          // setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            } else {
              return loading();
            }
          });
        });
  }

  // Update statut agent
  Future<void> updateAgent(AgentModel agentModel) async {
    final agent = AgentModel(
        id: agentModel.id,
        nom: agentModel.nom,
        postNom: agentModel.postNom,
        prenom: agentModel.prenom,
        email: agentModel.email,
        telephone: agentModel.telephone,
        adresse: agentModel.adresse,
        sexe: agentModel.sexe,
        role: agentModel.role,
        matricule: agentModel.matricule,
        numeroSecuriteSociale: agentModel.numeroSecuriteSociale,
        dateNaissance: agentModel.dateNaissance,
        lieuNaissance: agentModel.lieuNaissance,
        nationalite: agentModel.nationalite,
        typeContrat: agentModel.typeContrat,
        departement: agentModel.departement,
        servicesAffectation: agentModel.servicesAffectation,
        dateDebutContrat: agentModel.dateDebutContrat,
        dateFinContrat: agentModel.dateFinContrat,
        fonctionOccupe: agentModel.fonctionOccupe,
        statutAgent: statutPersonel,
        createdAt: agentModel.createdAt,
        photo: agentModel.photo,
        salaire: agentModel.salaire,
        signature: user.matricule,
        created: DateTime.now(),
        approbationDG: agentModel.approbationDG,
        motifDG: agentModel.motifDG,
        signatureDG: agentModel.signatureDG,
        approbationDD: agentModel.approbationDD,
        motifDD: agentModel.motifDD,
        signatureDD: agentModel.signatureDD);
    await AgentsApi().updateData(agent);
  }

  // Delete user login accès
  Future<void> deleteUser(AgentModel agentModel) async {
    final userId = userList
        .where((element) => element.matricule == agentModel.matricule)
        .map((e) => e.id)
        .first;
    await UserApi().deleteData(userId!);
  }

  // Create user login accès
  Future<void> createUser(
    String nom,
    String prenom,
    String email,
    String telephone,
    String matricule,
    String departement,
    String servicesAffectation,
    String fonctionOccupe,
    String role,
  ) async {
    final userModel = UserModel(
        photo: '-',
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        matricule: matricule,
        departement: departement,
        servicesAffectation: servicesAffectation,
        fonctionOccupe: fonctionOccupe,
        role: role,
        isOnline: 'false',
        createdAt: DateTime.now(),
        passwordHash: '12345678',
        succursale: '-');
    await UserApi().insertData(userModel);
  }
}
