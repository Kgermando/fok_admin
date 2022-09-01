import 'package:fokad_admin/src/api/rh/agents_api.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/presence_personnel_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/api/rh/presence_personnel_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DetailPresence extends StatefulWidget {
  const DetailPresence({Key? key}) : super(key: key);

  @override
  State<DetailPresence> createState() => _DetailPresenceState();
}

class _DetailPresenceState extends State<DetailPresence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isSortie = false;
  String sortieBoolean = 'false';

  late Future<List<PresencePersonnelModel>> dataFuture;

  TextEditingController identifiantController = TextEditingController();
  TextEditingController motifController = TextEditingController();

  @override
  initState() {
    getData();
    super.initState();
    dataFuture = getDataFuture();
  }

  @override
  void dispose() {
    identifiantController.dispose();
    motifController.dispose();
    super.dispose();
  }

  List<String> suggestionList = [];
  List<AgentModel> agentListFilter = [];
  String signature = '';
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var agents = await AgentsApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      agentListFilter = agents;
    });
  }

  Future<List<PresencePersonnelModel>> getDataFuture() async {
    var dataList = await PresencePersonnelApi().getAllData();
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<PresenceModel>(
            future: PresenceApi().getOneData(id),
            builder:
                (BuildContext context, AsyncSnapshot<PresenceModel> snapshot) {
              if (snapshot.hasData) {
                PresenceModel? data = snapshot.data;
                return speedialWidget(data!);
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
                    child: FutureBuilder<PresenceModel>(
                        future: PresenceApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<PresenceModel> snapshot) {
                          if (snapshot.hasData) {
                            PresenceModel? data = snapshot.data;
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
                                          title: "Presence",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: pageDetail(data!))
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

  Widget pageDetail(PresenceModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                children: [TitleWidget(title: data.title), deleteDialog(data)],
              ),
              Divider(color: mainColor),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(p10),
                      child: Text('Générer par :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: SelectableText(data.signature,
                        textAlign: TextAlign.start, style: bodyMedium),
                  )
                ],
              ),
              Divider(color: mainColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleWidget(title: "Personnels present"),
                  IconButton(
                      tooltip: "Rafraishir",
                      color: Colors.green,
                      onPressed: () {
                        setState(() {
                          dataFuture = getDataFuture();
                        });
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
              presencePersonnelWidget(data)
            ],
          ),
        ),
      ),
    ]);
  }

  Widget deleteDialog(PresenceModel data) {
    return IconButton(
      color: Colors.red,
      icon: const Icon(Icons.delete),
      tooltip: 'Suppression de ${data.title}',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de vouloir faire ceci ?',
              style: TextStyle(color: mainColor)),
          content: const Text(
              'Cette action permet de supprimer la liste de presence.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await PresenceApi().deleteData(data.id!).then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Liste supprimé avec succès!"),
                    backgroundColor: Colors.red.shade700,
                  ));
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget presencePersonnelWidget(PresenceModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      height: MediaQuery.of(context).size.height / 2,
      child: FutureBuilder<List<PresencePersonnelModel>>(
          future: dataFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PresencePersonnelModel>> snapshot) {
            if (snapshot.hasData) {
              List<PresencePersonnelModel>? dataList = snapshot.data!
                  .where((element) => element.reference == data.id!)
                  .toList();
              List<String> presencePersonnelList =
                  dataList.map((e) => e.identifiant).toList();
              List<String> agentsFilter =
                  agentListFilter.map((e) => e.matricule).toList();
              suggestionList = agentsFilter
                  .toSet()
                  .difference(presencePersonnelList.toSet())
                  .toList();

              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, index) {
                    final personne = dataList[index];
                    sortieBoolean = personne.sortie;
                    if (sortieBoolean == 'true') {
                      isSortie = true;
                    } else if (sortieBoolean == 'false') {
                      isSortie = false;
                    }
                    return ListTile(
                      leading: const Icon(
                        Icons.person,
                        size: 40.0,
                        // color: Colors.green.shade700,
                      ),
                      title: Text(personne.identifiant),
                      subtitle: Text("Ajouté par ${personne.signature} "),
                      trailing: IconButton(
                          onPressed: () {
                            sortiePresenceDialog(data, personne);
                          },
                          icon: Icon(Icons.logout,
                              color: (personne.sortie == 'true')
                                  ? Colors.green
                                  : Colors.red)),
                      onLongPress: () {
                        detailAgentDialog(personne);
                      },
                    );
                  });
            } else {
              return Center(child: loading());
            }
          }),
    );
  }

  detailAgentDialog(PresencePersonnelModel personne) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Infos detail', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 500,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Text("identifiant:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text(personne.identifiant)),
                        ],
                      ),
                      Divider(color: mainColor),
                      const Text("Motif:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      AutoSizeText(personne.motif,
                          textAlign: TextAlign.justify, maxLines: 4),
                      Divider(color: mainColor),
                      Row(
                        children: [
                          const Expanded(
                              flex: 1,
                              child: Text("Statut:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          if (personne.sortie == 'true')
                            const Expanded(
                                flex: 3,
                                child: Text("Déjà sortie",
                                    style: TextStyle(color: Colors.green))),
                          if (personne.sortie == 'false')
                            const Expanded(
                                flex: 3,
                                child: Text("Pas encore sortie",
                                    style: TextStyle(color: Colors.red)))
                        ],
                      ),
                      Divider(color: mainColor),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Entrer signé par: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text(personne.signature)),
                        ],
                      ),
                      Divider(color: mainColor),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Sortie signé par: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text(personne.signatureFermeture)),
                        ],
                      ),
                      Divider(color: mainColor),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Ajouté le: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              child: Text(DateFormat("dd-MM-yyyy à HH:mm")
                                  .format(personne.created))),
                        ],
                      ),
                      Divider(color: mainColor),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Sortie le: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              child: (personne.sortie == 'false')
                                  ? const Text("-")
                                  : Text(DateFormat("dd-MM-yyyy à HH:mm")
                                      .format(personne.createdSortie))),
                        ],
                      ),
                      Divider(color: mainColor),
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

  SpeedDial speedialWidget(PresenceModel data) {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.qr_code),
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey.shade700,
          label: 'QrCode',
          onPressed: () {},
        ),
        SpeedDialChild(
          child: const Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Presence',
          onPressed: () {
            newPresenceDialog(data);
          },
        )
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  newPresenceDialog(PresenceModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text('Nouvelle presence', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 250,
                  width: 300,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              identifiantWidget(),
                              const SizedBox(height: 20),
                              motifWidget(),
                            ],
                          ))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    isLoading = true;
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submit(data);
                      form.reset();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  sortiePresenceDialog(PresenceModel data, PresencePersonnelModel personne) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            bool isLoadingSortie = false;

            Color getColor(Set<MaterialState> states) {
              const Set<MaterialState> interactiveStates = <MaterialState>{
                MaterialState.pressed,
                MaterialState.hovered,
                MaterialState.focused,
              };
              if (states.any(interactiveStates.contains)) {
                return Colors.red;
              }
              return Colors.green;
            }

            checkboxRead(PresenceModel data, PresencePersonnelModel personne) {
              return isLoadingSortie
                  ? loadingMini()
                  : ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isSortie,
                        onChanged: (bool? value) {
                          setState(() {
                            isLoadingSortie = true;
                            isSortie = value!;
                          });
                          if (isSortie) {
                            sortieBoolean = 'true';
                            submitSortie(data, personne).then((value) {
                              setState(() {
                                isLoadingSortie = false;
                              });
                            });
                          } else {
                            sortieBoolean = 'false';
                            submitSortie(data, personne).then((value) {
                              setState(() {
                                isLoadingSortie = false;
                              });
                            });
                          }
                        },
                      ),
                      title: Text(
                          "Cocher pour marquer la sortie de ${personne.identifiant}"),
                    );
            }

            return AlertDialog(
              title:
                  Text('Sortie presence', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 100, width: 300, child: checkboxRead(data, personne)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget identifiantWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          controller: identifiantController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Identifiant de l'individu",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) => value == null ? "Select Service" : null,
        ));
  }

  Widget motifWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: motifController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Motif',
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

  Future<void> submit(PresenceModel data) async {
    final presence = PresencePersonnelModel(
        reference: data.id!,
        identifiant: identifiantController.text,
        motif: motifController.text,
        sortie: 'false',
        signature: signature,
        signatureFermeture: '-',
        created: DateTime.now(),
        createdSortie: DateTime.now());
    await PresencePersonnelApi().insertData(presence).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${identifiantController.text} vient d'arriver!"),
        backgroundColor: Colors.purple[700],
      ));
    });
  }

  Future<void> submitSortie(
      PresenceModel data, PresencePersonnelModel personne) async {
    final presence = PresencePersonnelModel(
        id: personne.id,
        reference: data.id!,
        identifiant: personne.identifiant,
        motif: personne.motif,
        sortie: sortieBoolean,
        signature: personne.signature,
        signatureFermeture: signature,
        created: personne.created,
        createdSortie: DateTime.now());
    await PresencePersonnelApi().updateData(presence).then((value) {
      // Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${identifiantController.text} vient de sortir!"),
        backgroundColor: Colors.purple[700],
      ));
    });
  }
}
