import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/archives/archive_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/utils/dropdown.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/file_uploader.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:dospace/dospace.dart' as dospace;

class AddArchiveDesktop extends StatefulWidget {
  const AddArchiveDesktop(
      {Key? key, required this.signature, required this.archiveFolderModel})
      : super(key: key);
  final String signature;
  final ArchiveFolderModel archiveFolderModel;

  @override
  State<AddArchiveDesktop> createState() => _AddArchiveDesktopState();
}

class _AddArchiveDesktopState extends State<AddArchiveDesktop> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List<String> departementList = Dropdown().departement;

  TextEditingController nomDocumentController = TextEditingController();
  String? departement;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fichierController = TextEditingController();

  bool isUploading = false;
  bool isUploadingDone = false;
  String? uploadedFileUrl;

  void _pdfUpload(File pdfFile) async {
    String projectName = "fokad-spaces";
    String region = "sfo3";
    String folderName = "archives";
    String? pdfFileName;

    String extension = 'pdf';
    pdfFileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

    uploadedFileUrl =
        "https://$projectName.$region.digitaloceanspaces.com/$folderName/$pdfFileName";
    // print('url: $uploadedFileUrl');
    setState(() {
      isUploading = true;
    });
    dospace.Bucket bucketpdf = FileUploader().spaces.bucket('fokad-spaces');
    String? etagpdf = await bucketpdf.uploadFile('$folderName/$pdfFileName',
        pdfFile, 'application/pdf', dospace.Permissions.public);
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
    nomDocumentController.dispose();
    descriptionController.dispose();
    fichierController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return addPageWidget(widget.archiveFolderModel);
  }

  Widget addPageWidget(ArchiveFolderModel archiveFolder) {
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
                width: MediaQuery.of(context).size.width / 2,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [TitleWidget(title: "Ajout archive")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    nomDocumentWidget(),
                    Row(
                      children: [
                        Expanded(child: fichierWidget()),
                        const SizedBox(
                          width: p10,
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    descriptionWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Soumettre',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            submit(archiveFolder);
                            form.reset();
                          }
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Enregistrer avec succès!"),
                            backgroundColor: Colors.green[700],
                          ));
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

  Widget nomDocumentWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: nomDocumentController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du document',
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

  Widget descriptionWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Description',
          ),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 5,
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

  Widget fichierWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: isUploading
            ? const SizedBox(
                height: p20, width: 50.0, child: LinearProgressIndicator())
            : TextButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
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
                    : const Icon(Icons.upload_file),
                label: isUploadingDone
                    ? Text("Téléchargement terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Selectionner le fichier",
                        style: Theme.of(context).textTheme.bodyLarge)));
  }

  Future<void> submit(ArchiveFolderModel data) async {
    final archiveModel = ArchiveModel(
        departement: data.departement,
        folderName: data.folderName,
        nomDocument: nomDocumentController.text,
        description: descriptionController.text,
        fichier: (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
        signature: widget.signature,
        created: DateTime.now());
    await ArchiveApi().insertData(archiveModel);
  }
}
