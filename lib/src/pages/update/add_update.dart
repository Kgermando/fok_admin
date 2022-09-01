import 'dart:io';

import 'package:fokad_admin/src/api/update/update_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/update/update_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/file_uploader.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dospace/dospace.dart' as dospace;

class AddUpdate extends StatefulWidget {
  const AddUpdate({Key? key}) : super(key: key);

  @override
  State<AddUpdate> createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController versionController = TextEditingController();

  bool isUploading = false;
  bool isUploadingDone = false;
  String? uploadedFileUrl;

  void _pdfUpload(File file) async {
    String projectName = "fokad-spaces";
    String region = "sfo3";
    String folderName = "update";
    String? fileName;

    String extension = 'msix';
    fileName = "${DateTime.now().microsecondsSinceEpoch}.$extension";

    uploadedFileUrl =
        "https://$projectName.$region.digitaloceanspaces.com/$folderName/$fileName";
    // print('url: $uploadedFileUrl');
    setState(() {
      isUploading = true;
    });
    dospace.Bucket bucketpdf = FileUploader().spaces.bucket('fokad-spaces');
    String? etagpdf = await bucketpdf.uploadFile('$folderName/$fileName', file,
        'application/file', dospace.Permissions.public);
    setState(() {
      isUploading = false;
      isUploadingDone = true;
    });
    if (kDebugMode) {
      print('upload: $etagpdf');
      print('done');
    }
  }

  @override
  void dispose() {
    versionController.dispose();
    super.dispose();
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
                                  title: 'Update',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: addMailWidget()))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget addMailWidget() {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [TitleWidget(title: "Nouvelle version")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    versionWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        fichierWidget(),
                      ],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Enregistrer',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit();
                            form.reset();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget versionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: versionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Version",
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

  Widget fichierWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: isUploading
            ? SizedBox(height: 50.0, width: 50.0, child: loadingMini())
            : TextButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'msix',
                    ],
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    _pdfUpload(file);
                  } else {
                    const Text("Votre fichier n'existe pas");
                  }
                },
                icon: isUploadingDone
                    ? Icon(Icons.check_circle_outline,
                        color: Colors.green.shade700)
                    : const Icon(Icons.apps),
                label: isUploadingDone
                    ? Text("Téléchargement terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Charger le logiciel",
                        style: Theme.of(context).textTheme.bodyLarge)));
  }

  Future<void> submit() async {
    final updateVersion = UpdateModel(
        version: versionController.text,
        urlUpdate: (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
        isActive: 'false',
        created: DateTime.now());
    await UpdateVersionApi().insertData(updateVersion).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enregistrer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
