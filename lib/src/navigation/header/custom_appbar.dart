import 'dart:async';
import 'dart:io';

import 'package:fokad_admin/src/api/update/update_api.dart';
import 'package:fokad_admin/src/models/update/update_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/agenda_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/comm_marketing/cart_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/exploitations/taches_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/mails/mails_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/menu_item.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/header/header_item.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/menu_items.dart';
import 'package:fokad_admin/src/utils/menu_options.dart';
import 'package:badges/badges.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar(
      {Key? key, required this.title, required this.controllerMenu})
      : super(key: key);

  final String title;
  final VoidCallback controllerMenu;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  String isUpdateVersion = "2.0.0.3";
  Timer? timer;
  int tacheCount = 0;
  int cartCount = 0;
  int mailsCount = 0;
  int agendaCount = 0;

  bool downloading = false;
  String progressString = '0';

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getData();
    });
    // getUpdate();
    super.initState();
  }

  List<UpdateModel> updateVersionList = [];
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    var cartCountNotify = await CartNotifyApi().getCount(userModel.matricule);
    var tacheCountNotify = await TacheNotifyApi().getCount(userModel.matricule);
    var mailsCountNotify = await MailsNotifyApi().getCount(userModel.email);
    var agendaCountNotify =
        await AgendaNotifyApi().getCount(userModel.matricule);
    var updateVersions = await UpdateVersionApi().getAllData();
    if (mounted) {
      setState(() {
        agendaCount = agendaCountNotify.count;
        cartCount = cartCountNotify.count;
        tacheCount = tacheCountNotify.count;
        mailsCount = mailsCountNotify.count;
        updateVersionList = updateVersions
            .where((element) => element.isActive == "true")
            .toList();
      });
    }
  }

  Future<void> downloadNetworkSoftware({required String url}) async {
    Dio dio = Dio();
    try {
      var dir = await getDownloadsDirectory();
      final name = url.split('/').last;
      final fileName = '${dir!.path}/$name';
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Téléchargement en cours. Patientez svp..."),
          backgroundColor: Colors.green[700]));
      await dio.download(url, fileName, onReceiveProgress: (received, total) {
        setState(() {
          downloading = true;
          progressString = "${((received / total) * 100).toStringAsFixed(0)}%";
        });
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Téléchargement terminé!"),
          backgroundColor: Colors.green[700],
        ));
        OpenFile.open(fileName);
      });
    } catch (exp) {
      if (kDebugMode) {
        print("exp $exp");
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Une erreur c'est produite!"),
        backgroundColor: Colors.red[700],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                onPressed: widget.controllerMenu,
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            HeaderItem(title: widget.title),
            const Spacer(),
            if (Platform.isWindows &&
                updateVersionList.isNotEmpty &&
                updateVersionList.last.version != isUpdateVersion)
              IconButton(
                  iconSize: 40,
                  tooltip: 'Téléchargement',
                  onPressed: () {
                    setState(() {
                      downloadNetworkSoftware(
                          url: updateVersionList.last.urlUpdate);
                    });
                  },
                  icon: (downloading)
                      ? (progressString == "100%")
                          ? const Icon(Icons.check)
                          : AutoSizeText(progressString,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12.0))
                      : const Icon(Icons.download)),
            FutureBuilder<UserModel>(
                future: AuthApi().getUserId(),
                builder:
                    (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasData) {
                    UserModel? userModel = snapshot.data;
                    // print('photo ${userModel!.photo}');
                    final String firstLettter = userModel!.nom[0];
                    final String firstLettter2 = userModel.prenom[0];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (userModel.departement == "Commercial et Marketing")
                          IconButton(
                              tooltip: 'Panier',
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    ComMarketingRoutes.comMarketingcart);
                              },
                              icon: Badge(
                                badgeContent: Text('$cartCount',
                                    style: const TextStyle(
                                        fontSize: 10.0, color: Colors.white)),
                                child: Icon(Icons.shopping_cart,
                                    size: (Responsive.isDesktop(context)
                                        ? 25
                                        : 20)),
                              )),
                        IconButton(
                            tooltip: 'Agenda',
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  ComMarketingRoutes.comMarketingAgenda);
                            },
                            icon: Badge(
                              showBadge: (agendaCount >= 1) ? true : false,
                              badgeContent: Text('$agendaCount',
                                  style: const TextStyle(
                                      fontSize: 10.0, color: Colors.white)),
                              child: Icon(
                                  (agendaCount >= 1)
                                      ? Icons.note_alt
                                      : Icons.note_alt_outlined,
                                  size: (Responsive.isDesktop(context)
                                      ? 25
                                      : 20)),
                            )),
                        IconButton(
                            tooltip: 'Mails',
                            onPressed: () {
                              Navigator.pushNamed(context, MailRoutes.mails);
                            },
                            icon: Badge(
                              showBadge: (mailsCount >= 1) ? true : false,
                              badgeContent: Text('$mailsCount',
                                  style: const TextStyle(
                                      fontSize: 10.0, color: Colors.white)),
                              child: Icon(
                                  (mailsCount >= 1)
                                      ? Icons.mail
                                      : Icons.mail_outline,
                                  size: (Responsive.isDesktop(context)
                                      ? 25
                                      : 20)),
                            )),
                        if (userModel.departement == "Exploitations")
                          if (tacheCount >= 1)
                            IconButton(
                                tooltip: 'Notifications',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ExploitationRoutes.expTache);
                                },
                                icon: Badge(
                                  badgeContent: Text('$tacheCount',
                                      style: const TextStyle(
                                          fontSize: 10.0, color: Colors.white)),
                                  child: Icon(Icons.notifications,
                                      size: (Responsive.isDesktop(context)
                                          ? 25
                                          : 20)),
                                )),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: CircleAvatar(
                            backgroundColor: Colors.white38,
                            child: AutoSizeText(
                              '$firstLettter2$firstLettter'.toUpperCase(),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: p8),
                        Responsive.isDesktop(context)
                            ? AutoSizeText(
                                "${userModel.prenom} ${userModel.nom}",
                                maxLines: 1,
                              )
                            : Container()
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            PopupMenuButton<MenuItemModel>(
              onSelected: (item) => MenuOptions().onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(MenuOptions().buildItem).toList(),
                const PopupMenuDivider(),
                ...MenuItems.itemsSecond.map(MenuOptions().buildItem).toList(),
              ],
            )
          ],
        ),
      ],
    );
  }
}
