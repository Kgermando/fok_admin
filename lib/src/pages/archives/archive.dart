import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_folderapi.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/archives/table_archive_data.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int? id;
  ArchiveFolderModel? archiveFolder;

  @override
  Widget build(BuildContext context) {
    archiveFolder =
        ModalRoute.of(context)!.settings.arguments as ArchiveFolderModel;

    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, ArchiveRoutes.addArchives,
                  arguments: archiveFolder);
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
                    child: FutureBuilder<ArchiveFolderModel>(
                        future:
                            ArchiveFolderApi().getOneData(archiveFolder!.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<ArchiveFolderModel> snapshot) {
                          if (snapshot.hasData) {
                            ArchiveFolderModel? archiveModel = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomAppbar(
                                          title: archiveModel!.folderName,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: TableArchiveData(
                                        archiveFolderModel: archiveModel))
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
