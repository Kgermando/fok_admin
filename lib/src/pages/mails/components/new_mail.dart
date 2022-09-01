import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/utils/regex.dart';
import 'package:fokad_admin/src/widgets/btn_widget.dart';
import 'package:fokad_admin/src/widgets/file_uploader.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:dospace/dospace.dart' as dospace;

class NewMail extends StatefulWidget {
  const NewMail({Key? key}) : super(key: key);

  @override
  State<NewMail> createState() => _NewMailState();
}

class _NewMailState extends State<NewMail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController controllerScrollCC = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isOpen = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController objetController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController pieceJointeController = TextEditingController();
  bool read = false;
  List<UserModel> ccList = [];

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

  List<UserModel> userList = [];
  UserModel? user;
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var users = await UserApi().getAllData();
    setState(() {
      user = userModel;
      userList = users;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    objetController.dispose();
    messageController.dispose();
    pieceJointeController.dispose();

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
                                  title: 'Mails',
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
                      children: const [TitleWidget(title: "Nouveau mail")],
                    ),
                    const SizedBox(
                      height: p20,
                    ),
                    emailWidget(),
                    // ccWidget(),
                    const SizedBox(height: p20),
                    objetWidget(),
                    messageWidget(),
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
                        title: 'Envoyez',
                        isLoading: isLoading,
                        press: () {
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            send();
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
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(),
          validator: (value) => RegExpIsValide().validateEmail(value),
        ));
  }

  Widget ccWidget() {
    return Material(
      color: Colors.amber.shade50,
      child: ExpansionTile(
        leading: const Icon(Icons.person),
        title: const Text('Cc'),
        subtitle: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 20,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ccList.length,
              itemBuilder: (BuildContext context, index) {
                final agent = ccList[index];
                return Text("${agent.email}; ");
              }),
        ),
        onExpansionChanged: (val) {
          setState(() {
            isOpen = !val;
          });
        },
        trailing: const Icon(Icons.arrow_drop_down),
        children: [
          SizedBox(
            height: 100,
            child: Scrollbar(
              controller: controllerScrollCC,
              trackVisibility: true,
              thumbVisibility: true,
              child: ListView.builder(
                  itemCount: userList.length,
                  controller: controllerScrollCC,
                  itemBuilder: (context, i) {
                    return ListTile(
                        title: Text(userList[i].email),
                        leading: Checkbox(
                          value: ccList.contains(userList[i]),
                          onChanged: (val) {
                            if (val == true) {
                              setState(() {
                                ccList.add(userList[i]);
                              });
                            } else {
                              setState(() {
                                ccList.remove(userList[i]);
                              });
                            }
                          },
                        ));
                  }),
            ),
          )
        ],
      ),
    );
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
            labelText: "Ecrivez mail ...",
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
                    : Text("Pièce jointe",
                        style: Theme.of(context).textTheme.bodyLarge)));
  }

  Future<void> send() async {
    var userSelect = userList
        .where((element) => element.email == emailController.text)
        .first;
    var ccJson = jsonEncode(ccList);
    final mailModel = MailModel(
        fullName: "${userSelect.prenom} ${userSelect.nom}",
        email: emailController.text,
        cc: ccJson,
        objet: objetController.text,
        message: messageController.text,
        pieceJointe: (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
        read: 'false',
        fullNameDest: "${user!.prenom} ${user!.nom}",
        emailDest: user!.email,
        dateSend: DateTime.now(),
        dateRead: DateTime.now());
    await MailApi().insertData(mailModel).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Envoyer avec succès!"),
        backgroundColor: Colors.green[700],
      ));
    });
  }
}
