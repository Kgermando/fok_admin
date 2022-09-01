import 'package:fokad_admin/src/pages/archives/plateforms/desktop/detail_archive_desktop.dart';
import 'package:fokad_admin/src/pages/archives/plateforms/mobile/detail_archive_mobile.dart';
import 'package:fokad_admin/src/pages/archives/plateforms/tablet/detail_archive_tablet.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DetailArchive extends StatefulWidget {
  const DetailArchive({Key? key}) : super(key: key);

  @override
  State<DetailArchive> createState() => _DetailArchiveState();
}

class _DetailArchiveState extends State<DetailArchive> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

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
                    child: FutureBuilder<ArchiveModel>(
                        future: ArchiveApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<ArchiveModel> snapshot) {
                          if (snapshot.hasData) {
                            ArchiveModel? archiveModel = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Archive",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (constraints.maxWidth >= 1100) {
                                    return DetailArchiveDesktop(
                                        pdfViewerKey: pdfViewerKey,
                                        archiveModel: archiveModel!);
                                  } else if (constraints.maxWidth < 1100 &&
                                      constraints.maxWidth >= 650) {
                                    return DetailArchiveTablet(
                                        pdfViewerKey: pdfViewerKey,
                                        archiveModel: archiveModel!);
                                  } else {
                                    return DetailArchiveMobile(
                                        pdfViewerKey: pdfViewerKey,
                                        archiveModel: archiveModel!);
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
