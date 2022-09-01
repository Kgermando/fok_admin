import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/file_uploader.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';

class RepondreMail extends StatefulWidget {
  const RepondreMail({Key? key}) : super(key: key);

  @override
  State<RepondreMail> createState() => _RepondreMailState();
}

class _RepondreMailState extends State<RepondreMail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController objetController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController pieceJointeController = TextEditingController();
  bool read = false;

  bool isUploading = false;
  bool isUploadingDone = false;
  String? uploadedFileUrl;

  void _pdfUpload(File pdfFile) async {
    String projectName = "fokad-spaces";
    String region = "sfo3";
    String folderName = "emails";
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
  initState() {
    getData();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    MailModel mailModel =
        ModalRoute.of(context)!.settings.arguments as MailModel;
    emailController = TextEditingController(text: mailModel.email);
    objetController = TextEditingController(text: mailModel.objet);
    // messageController = TextEditingController(text: mailModel.message);
    // pieceJointeController = TextEditingController(text: mailModel.pieceJointe);
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
                    child: FutureBuilder<MailModel>(
                        future: MailApi().getOneData(mailModel.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<MailModel> snapshot) {
                          if (snapshot.hasData) {
                            MailModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomAppbar(
                                          title: "Mail",
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: pageDetail(data!)))
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

  Widget pageDetail(MailModel data) {
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
                      children: const [TitleWidget(title: "Repondre le mail")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    emailWidget(),
                    const SizedBox(height: p20),
                    objetWidget(),
                    messageWidget(),
                    const SizedBox(
                      height: p20,
                    ),
                    BtnWidget(
                        title: 'Envoyez',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            send(data);
                            form.reset();
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Envoyer avec succès!"),
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

  Widget emailWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Email",
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) => RegExpIsValide().validateEmail(value),
        ));
  }

  Widget objetWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: objetController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Objet",
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

  Widget messageWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: messageController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Mail ...",
            helperText: "Ecrivez mail ...",
          ),
          keyboardType: TextInputType.multiline,
          minLines: 10,
          maxLines: 20,
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
            ? SizedBox(height: 50.0, width: 50.0, child: loadingMini())
            : TextButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf',
                      'doc',
                      'docx',
                      'xlsx',
                      'pptx',
                      'jpg',
                      'png'
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
                    : const Icon(Icons.attach_email),
                label: isUploadingDone
                    ? Text("Téléchargement terminé",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green.shade700))
                    : Text("Joindre un fichier",
                        style: Theme.of(context).textTheme.bodyLarge)));
  }

  Future<void> send(MailModel data) async {
    final mailModel = MailModel(
        fullName: data.fullName,
        email: emailController.text,
        cc: '-',
        objet: objetController.text,
        message: messageController.text,
        pieceJointe: data.pieceJointe,
        read: 'false',
        fullNameDest: "${user.prenom} ${user.nom}",
        emailDest: user.email,
        dateSend: DateTime.now(),
        dateRead: DateTime.now());
    await MailApi().insertData(mailModel);
  }
}
