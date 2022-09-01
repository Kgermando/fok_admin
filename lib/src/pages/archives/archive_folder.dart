import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_folderapi.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade400,
  Colors.lightBlue.shade400,
  Colors.orange.shade400,
  Colors.pinkAccent.shade400,
  Colors.tealAccent.shade400
];

class ArchiveFolder extends StatefulWidget {
  const ArchiveFolder({Key? key}) : super(key: key);

  @override
  State<ArchiveFolder> createState() => _ArchiveFolderState();
}

class _ArchiveFolderState extends State<ArchiveFolder> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future<List<ArchiveFolderModel>> dataFuture;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController folderNameController = TextEditingController();

  @override
  initState() {
    super.initState();
    getData();
    dataFuture = getDataFuture();
  }

  @override
  void dispose() {
    folderNameController.dispose();
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

  Future<List<ArchiveFolderModel>> getDataFuture() async {
    var dataList = await ArchiveFolderApi().getAllData();
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton.extended(
            label: Row(
              children: const [
                Icon(Icons.add),
                Text("Nouveau dossier"),
              ],
            ),
            onPressed: () {
              detailAgentDialog();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Archives',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(p30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      tooltip: "Rafrechissement",
                                      onPressed: () {
                                        setState(() {
                                          dataFuture = getDataFuture();
                                        });
                                      },
                                      icon: Icon(Icons.refresh,
                                          color: Colors.green.shade700)),
                                ],
                              ),
                              Expanded(
                                  child: FutureBuilder<
                                          List<ArchiveFolderModel>>(
                                      future: dataFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                                  List<ArchiveFolderModel>>
                                              snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Center(child: loading());
                                          // const Text("⏳ waiting")
                                          case ConnectionState.done:
                                          default:
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "😥 ${snapshot.error}");
                                            } else if (snapshot.hasData) {
                                              List<ArchiveFolderModel>?
                                                  archiveFolderList = snapshot
                                                      .data!
                                                      .where((element) =>
                                                          element.departement ==
                                                          user.departement)
                                                      .toList();
                                              return Wrap(
                                                  children: List.generate(
                                                      archiveFolderList.length,
                                                      (index) {
                                                final data =
                                                    archiveFolderList[index];
                                                final color = _lightColors[
                                                    index %
                                                        _lightColors.length];
                                                return cardFolder(data, color);
                                              }));
                                            } else {
                                              return const Text(
                                                  "Pas de données. 😑");
                                            }
                                        }
                                      })),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget cardFolder(ArchiveFolderModel data, Color color) {
    return GestureDetector(
        onDoubleTap: () {
          Navigator.pushNamed(context, ArchiveRoutes.archiveTable,
              arguments: data);
        },
        child: Column(
          children: [
            Icon(
              Icons.folder,
              color: color,
              size: 100.0,
            ),
            Text(data.folderName)
          ],
        ));
  }

  detailAgentDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Nouveau dossier'),
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Form(key: _formKey, child: nomWidget())),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      submit();
                      form.reset();
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Dossier créé avec succès!"),
                      backgroundColor: Colors.green[700],
                    ));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget nomWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: folderNameController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du dossier',
          ),
          keyboardType: TextInputType.text,
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
    final archiveModel = ArchiveFolderModel(
        departement: user.departement,
        folderName: folderNameController.text,
        signature: user.matricule,
        created: DateTime.now());
    await ArchiveFolderApi().insertData(archiveModel);
  }
}
