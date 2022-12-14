import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/components/mails_nav.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/mails/components/list_mails.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  mainColor,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
  Colors.brown.shade700,
  Colors.grey.shade700,
  Colors.blueGrey.shade700,
];

class MailPages extends StatefulWidget {
  const MailPages({Key? key}) : super(key: key);

  @override
  State<MailPages> createState() => _MailPagesState();
}

class _MailPagesState extends State<MailPages> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Future<List<MailModel>> dataFuture;

  @override
  initState() {
    getData();
    dataFuture = getDataFuture();
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
    if (mounted) {
      setState(() {
        user = userModel;
      });
    }
  }

  Future<List<MailModel>> getDataFuture() async {
    var dataList = await MailApi().getAllData();
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const MailsNAv(),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Nouveau mail"),
            onPressed: () {
              Navigator.pushNamed(context, MailRoutes.addMail);
            }),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: MailsNAv(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: 'Mails',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    dataFuture = getDataFuture();
                                  },
                                  icon: const Icon(Icons.refresh)),
                            ],
                          ),
                          Expanded(
                            child: FutureBuilder<List<MailModel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<MailModel>> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(child: loading());
                                    // const Text("??? waiting")
                                    case ConnectionState.done:
                                    default:
                                      if (snapshot.hasError) {
                                        return Text("???? ${snapshot.error}");
                                      } else if (snapshot.hasData) {
                                        List<MailModel>? data = snapshot.data!
                                            .where((element) =>
                                                element.email == user.email ||
                                                element.email ==
                                                    "support@eventdrc.com")
                                            .toList();
                                        return ListView.builder(
                                            itemCount: data.length,
                                            itemBuilder: (context, index) {
                                              final mail = data[index];
                                              final color = _lightColors[index];
                                              return pageWidget(mail, color);
                                            });
                                      } else {
                                        return const Center(
                                            child:
                                                Text("Envoyez des mails ????"));
                                      }
                                  }
                                }),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget pageWidget(MailModel mail, Color color) {
    // var ccList = jsonDecode(mail.cc);
    return InkWell(
      onTap: () {
        readMail(mail);
        Navigator.pushNamed(context, MailRoutes.mailDetail,
            arguments: MailColor(mail: mail, color: color));
      },
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: ListMails(
            fullName: mail.fullName,
            email: mail.email,
            // cc: ccList,
            objet: mail.objet,
            read: mail.read,
            dateSend: mail.dateSend,
            color: color),
      ),
    );
  }

  Widget alertWidget() {
    final headline6 = Theme.of(context).textTheme.headline6;
    // Duration isDuration = const Duration(minutes: 1);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("En attente d'une connexion API s??curis??e ...",
              style: headline6),
          // const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Future<void> readMail(MailModel mail) async {
    final mailModel = MailModel(
        id: mail.id!,
        fullName: mail.fullName,
        email: mail.email,
        cc: mail.cc,
        objet: mail.objet,
        message: mail.message,
        pieceJointe: mail.pieceJointe,
        read: 'true',
        fullNameDest: mail.fullNameDest,
        emailDest: mail.emailDest,
        dateSend: mail.dateSend,
        dateRead: DateTime.now());
    await MailApi().updateData(mailModel);
  }
}
