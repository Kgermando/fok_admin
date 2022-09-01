import 'package:fokad_admin/src/pages/rh/performences/plateforms/desktop/detail_performence_desktop.dart';
import 'package:fokad_admin/src/pages/rh/performences/plateforms/mobile/detail_performence_mobile.dart';
import 'package:fokad_admin/src/pages/rh/performences/plateforms/tablet/detail_performence_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/rh/performence_api.dart';
import 'package:fokad_admin/src/api/rh/performence_note_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class DetailPerformence extends StatefulWidget {
  const DetailPerformence({Key? key}) : super(key: key);

  @override
  State<DetailPerformence> createState() => _DetailPerformenceState();
}

class _DetailPerformenceState extends State<DetailPerformence> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  initState() {
    getData();
    super.initState();
  }

  String signature = '';
  List<PerformenceNoteModel> performenceNoteList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var performenceNotes = await PerformenceNoteApi().getAllData();
    setState(() {
      signature = userModel.matricule;
      performenceNoteList = performenceNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FutureBuilder<PerformenceModel>(
            future: PerformenceApi().getOneData(id),
            builder: (BuildContext context,
                AsyncSnapshot<PerformenceModel> snapshot) {
              if (snapshot.hasData) {
                PerformenceModel? data = snapshot.data;
                return FloatingActionButton(
                    tooltip: "Donnez une note",
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RhRoutes.rhPerformenceAddNote,
                          arguments: data);
                    });
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
                    child: FutureBuilder<PerformenceModel>(
                        future: PerformenceApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<PerformenceModel> snapshot) {
                          if (snapshot.hasData) {
                            PerformenceModel? performenceModel = snapshot.data;
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
                                    return DetailPerformenceDesktop(
                                        signature: signature,
                                        performenceNoteList:
                                            performenceNoteList,
                                        performenceModel: performenceModel!);
                                  } else if (constraints.maxWidth < 1100 &&
                                      constraints.maxWidth >= 650) {
                                    return DetailPerformenceTablet(
                                        signature: signature,
                                        performenceNoteList:
                                            performenceNoteList,
                                        performenceModel: performenceModel!);
                                  } else {
                                    return DetailPerformenceMobile(
                                        signature: signature,
                                        performenceNoteList:
                                            performenceNoteList,
                                        performenceModel: performenceModel!);
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
}
