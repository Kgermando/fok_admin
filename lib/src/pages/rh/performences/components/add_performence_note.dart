import 'package:fokad_admin/src/pages/rh/performences/plateforms/desktop/add_performence_note_desktop.dart';
import 'package:fokad_admin/src/pages/rh/performences/plateforms/mobile/add_performence_note_mobile.dart';
import 'package:fokad_admin/src/pages/rh/performences/plateforms/tablet/add_performence_note_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class AddPerformenceNote extends StatefulWidget {
  const AddPerformenceNote({Key? key, required this.performenceModel})
      : super(key: key);
  final PerformenceModel performenceModel;

  @override
  State<AddPerformenceNote> createState() => _AddPerformenceNoteState();
}

class _AddPerformenceNoteState extends State<AddPerformenceNote> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  initState() {
    getData();
    super.initState();
  }

  String signature = '';
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      signature = userModel.matricule;
    });
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
                                  title: (Responsive.isDesktop(context))
                                      ? "Ressources Humaines"
                                      : "RH",
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth >= 1100) {
                          return AddPerformenceNoteDesktop(
                              performenceModel: widget.performenceModel,
                              signature: signature);
                        } else if (constraints.maxWidth < 1100 &&
                            constraints.maxWidth >= 650) {
                          return AddPerformenceNoteTablet(
                              performenceModel: widget.performenceModel,
                              signature: signature);
                        } else {
                          return AddPerformenceNoteMobile(
                              performenceModel: widget.performenceModel,
                              signature: signature);
                        }
                      }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
