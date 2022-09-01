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
import 'package:fokad_admin/src/widgets/title_widget.dart';

class TransfertMail extends StatefulWidget {
  const TransfertMail({Key? key}) : super(key: key);

  @override
  State<TransfertMail> createState() => _TransfertMailState();
}

class _TransfertMailState extends State<TransfertMail> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController objetController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController pieceJointeController = TextEditingController();
  bool read = false;

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

  List<UserModel> userList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var users = await UserApi().getAllData();
    setState(() {
      user = userModel;
      userList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    MailModel mailModel =
        ModalRoute.of(context)!.settings.arguments as MailModel;
    // emailController = TextEditingController(text: mailModel.email);
    objetController = TextEditingController(text: mailModel.objet);
    messageController = TextEditingController(text: mailModel.message);
    pieceJointeController = TextEditingController(text: mailModel.pieceJointe);
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
                      children: const [TitleWidget(title: "Tranferer le mail")],
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
