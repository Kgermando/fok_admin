import 'package:fokad_admin/src/pages/archives/plateforms/desktop/add_archive_desktop.dart';
import 'package:fokad_admin/src/pages/archives/plateforms/mobile/add_archive_mobile.dart';
import 'package:fokad_admin/src/pages/archives/plateforms/tablet/add_archive_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class AddArchive extends StatefulWidget {
  const AddArchive({Key? key, required this.archiveFolderModel})
      : super(key: key);
  final ArchiveFolderModel archiveFolderModel;

  @override
  State<AddArchive> createState() => _AddArchiveState();
}

class _AddArchiveState extends State<AddArchive> {
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
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: 'Archive',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth >= 1100) {
                          return AddArchiveDesktop(
                              signature: signature,
                              archiveFolderModel: widget.archiveFolderModel);
                        } else if (constraints.maxWidth < 1100 &&
                            constraints.maxWidth >= 650) {
                          return AddArchiveTablet(
                              signature: signature,
                              archiveFolderModel: widget.archiveFolderModel);
                        } else {
                          return AddArchiveMobile(
                              signature: signature,
                              archiveFolderModel: widget.archiveFolderModel);
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
