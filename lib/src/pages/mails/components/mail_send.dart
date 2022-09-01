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

class MailSend extends StatefulWidget {
  const MailSend({Key? key}) : super(key: key);

  @override
  State<MailSend> createState() => _MailSendState();
}

class _MailSendState extends State<MailSend> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
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
    if (mounted) {
      setState(() {
        user = userModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const MailsNAv(),
        floatingActionButton: FloatingActionButton.extended(
            label: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: p20),
                Text("Nouveau mail")
              ],
            ),
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
                          child: FutureBuilder<List<MailModel>>(
                              future: MailApi().getAllData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<MailModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<MailModel>? data = snapshot.data!
                                      .where((element) =>
                                          element.emailDest == user.email)
                                      .toList();

                                  return (data.isEmpty)
                                      ? const Center(
                                          child: Text("Vos mails 📩"))
                                      : ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            final mail = data[index];
                                            final color = _lightColors[index];
                                            return pageWidget(mail, color);
                                          });
                                } else {
                                  return Center(child: loading());
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

  Widget pageWidget(MailModel mail, Color color) {
    // var ccList = jsonDecode(mail.cc);

    return InkWell(
      onTap: () async {
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
}
