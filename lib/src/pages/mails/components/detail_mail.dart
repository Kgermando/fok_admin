import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/mails/mail_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/mail/mail_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailMail extends StatefulWidget {
  const DetailMail({Key? key}) : super(key: key);

  @override
  State<DetailMail> createState() => _DetailMailState();
}

class _DetailMailState extends State<DetailMail> {
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
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    MailColor mailColor =
        ModalRoute.of(context)!.settings.arguments as MailColor;
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
                        future: MailApi().getOneData(mailColor.mail.id!),
                        builder: (BuildContext context,
                            AsyncSnapshot<MailModel> snapshot) {
                          if (snapshot.hasData) {
                            MailModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!Responsive.isMobile(context))
                                      SizedBox(
                                        width: p20,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.arrow_back)),
                                      ),
                                    const SizedBox(width: p10),
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
                                        child:
                                            pageDetail(data!, mailColor.color)))
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

  Widget pageDetail(MailModel data, color) {
    // double width = MediaQuery.of(context).size.width;
    // if (MediaQuery.of(context).size.width >= 1100) {
    //   width = MediaQuery.of(context).size.width / 2;
    // } else if (MediaQuery.of(context).size.width < 1100 &&
    //     MediaQuery.of(context).size.width >= 650) {
    //   width = MediaQuery.of(context).size.width / 1.3;
    // } else if (MediaQuery.of(context).size.width < 650) {
    //   width = MediaQuery.of(context).size.width / 1.2;
    // }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        // elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 1.5
              : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: p20),
              Padding(
                padding: const EdgeInsets.all(p8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SelectableText(
                        timeago.format(data.dateSend, locale: 'fr_short'),
                        textAlign: TextAlign.start),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, MailRoutes.mailRepondre,
                              arguments: data);
                        },
                        tooltip: 'Repondre',
                        icon: const Icon(Icons.reply)),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, MailRoutes.mailTransfert,
                              arguments: data);
                        },
                        tooltip: 'Transferer',
                        icon: const Icon(Icons.redo)),
                    IconButton(
                        onPressed: () {
                          deleteData(data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Mail supprimer avec succès!"),
                            backgroundColor: Colors.red[700],
                          ));
                        },
                        tooltip: 'Suypprimer',
                        icon: const Icon(Icons.delete)),
                    PrintWidget(onPressed: () {})
                  ],
                ),
              ),
              dataWidget(data, color)
            ],
          ),
        ),
      ),
    ]);
  }

  void deleteData(MailModel data) async {
    await MailApi().deleteData(data.id!);
  }

  Widget dataWidget(MailModel data, color) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final String firstLettter = data.fullNameDest[0];
    // var ccList = jsonDecode(data.cc);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundColor: color,
                child: AutoSizeText(
                  firstLettter.toUpperCase(),
                  style: headlineSmall!.copyWith(color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ),
            title: AutoSizeText(data.objet,
                style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data.email == user.email)
                  Row(children: [
                    AutoSizeText("à".toUpperCase()),
                    const SizedBox(height: p8),
                    const AutoSizeText("moi."),
                  ]),
                SizedBox(
                  width: 500,
                  child: ExpansionTile(
                    title: const Text("Voir plus", textAlign: TextAlign.end),
                    children: [
                      Row(
                        children: [
                          const AutoSizeText("De:"),
                          const SizedBox(width: p10),
                          AutoSizeText(data.emailDest, style: bodySmall),
                          const SizedBox(width: p10),
                          AutoSizeText(data.fullNameDest,
                              style: bodySmall!
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        children: [
                          AutoSizeText("à:".toUpperCase()),
                          const SizedBox(width: p10),
                          AutoSizeText(data.email, style: bodySmall),
                          const SizedBox(width: p10),
                          AutoSizeText(data.fullName,
                              style: bodySmall.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(width: p10),
                      Row(
                        children: [
                          const Text("Date:"),
                          const SizedBox(width: p10),
                          SelectableText(
                              DateFormat("dd-MM-yyyy HH:mm")
                                  .format(data.dateSend),
                              style: bodySmall,
                              textAlign: TextAlign.start),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.lock,
                              size: 15.0, color: Colors.green.shade700),
                          const SizedBox(width: p10),
                          Text("Chiffrement Standard (TLS).",
                              style: bodySmall.copyWith(
                                  color: Colors.green.shade700))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(color: mainColor),
          const SizedBox(height: p20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(data.message,
                    textAlign: TextAlign.start, style: bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: p20)
        ],
      ),
    );
  }
}
