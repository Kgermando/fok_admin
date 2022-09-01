import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ArchivePdfViewer extends StatefulWidget {
  const ArchivePdfViewer({Key? key}) : super(key: key);

  @override
  State<ArchivePdfViewer> createState() => _ArchivePdfViewerState();
}

class _ArchivePdfViewerState extends State<ArchivePdfViewer> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_up,
                          ),
                          onPressed: () {
                            _pdfViewerController.previousPage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          onPressed: () {
                            _pdfViewerController.nextPage();
                          },
                        )
                      ]),
                      Expanded(
                          child: SfPdfViewer.network(
                        url,
                        // password: 'fokad',
                        controller: _pdfViewerController,
                        enableDocumentLinkAnnotation: false,
                        key: _pdfViewerKey,
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
