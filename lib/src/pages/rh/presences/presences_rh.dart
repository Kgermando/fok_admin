import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/presence_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/presence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/table_presence.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:intl/intl.dart';

class PresenceRh extends StatefulWidget {
  const PresenceRh({Key? key}) : super(key: key);

  @override
  State<PresenceRh> createState() => _PresenceRhState();
}

class _PresenceRhState extends State<PresenceRh> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  List<PresenceModel> presenceList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var presenceModel = await PresenceApi().getAllData();
    setState(() {
      user = userModel;
      presenceList = presenceModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = presenceList
        .where((element) => element.created.day == DateTime.now().day);

    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: (p.isNotEmpty)
            ? Container()
            : FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  // Navigator.pushNamed(context, RhRoutes.rhPresenceAdd);
                  newFicheDialog();
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
                          title: (Responsive.isDesktop(context))
                              ? "Ressources Humaines"
                              : "RH",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TablePresence())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  newFicheDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Génerer la fiche de presence'),
              content: SizedBox(
                  height: 200,
                  width: 300,
                  child: isLoading
                      ? loading()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              AutoSizeText(
                                "Feuille du ${DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now())}",
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 20),
                              const Icon(Icons.co_present, size: p50)
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
                    submit();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Future<void> submit() async {
    final presenceModel = PresenceModel(
        title: "Présence du ${DateFormat("dd-MM-yyyy").format(DateTime.now())}",
        signature: user!.matricule,
        created: DateTime.now());
    await PresenceApi().insertData(presenceModel).then((value) {
      Navigator.pop(context, 'ok');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Fiche de presence generée avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
