import 'dart:io';

import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailAnnuaire extends StatefulWidget {
  const DetailAnnuaire({Key? key, required this.annuaireColor})
      : super(key: key);
  final AnnuaireColor annuaireColor;

  @override
  State<DetailAnnuaire> createState() => _DetailAnnuaireState();
}

class _DetailAnnuaireState extends State<DetailAnnuaire> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool hasCallSupport = false;
  // ignore: unused_field
  Future<void>? _launched;

  String? sendDate;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // ignore: deprecated_member_use
    await launch(launchUri.toString());
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
    int userRole = int.parse(user.role);

    final headline5 = Theme.of(context).textTheme.headline5;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width >= 1100) {
      width = MediaQuery.of(context).size.width / 2;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 650) {
      width = MediaQuery.of(context).size.width / 1.3;
    } else if (MediaQuery.of(context).size.width < 650) {
      width = MediaQuery.of(context).size.width / 1.2;
    }
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: Row(
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
                            child: CustomAppbar(
                                title: Responsive.isDesktop(context)
                                    ? 'Commercial & Marketing'
                                    : 'Comm. & Mark.',
                                controllerMenu: () =>
                                    _key.currentState!.openDrawer()),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: isLoading
                              ? Center(child: loading())
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                        elevation: 10,
                                        child: Container(
                                          margin: const EdgeInsets.all(p16),
                                          width: width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(p10),
                                            border: Border.all(
                                              color: Colors.blueGrey.shade700,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    color: widget
                                                        .annuaireColor.color,
                                                    height: 200,
                                                    width: double.infinity,
                                                  ),
                                                  Positioned(
                                                    top: 130,
                                                    left: (Responsive.isDesktop(
                                                            context))
                                                        ? 50
                                                        : 10,
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .green.shade700,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 2.0,
                                                              color:
                                                                  mainColor)),
                                                      child: CircleAvatar(
                                                          radius: 50,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Image.asset(
                                                            "assets/images/avatar.jpg",
                                                            width: 80,
                                                            height: 80,
                                                          )),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 150,
                                                      left:
                                                          (Responsive.isDesktop(
                                                                  context))
                                                              ? 180
                                                              : 120,
                                                      child: (Responsive
                                                              .isMobile(
                                                                  context))
                                                          ? Container()
                                                          : AutoSizeText(
                                                              widget
                                                                  .annuaireColor
                                                                  .annuaireModel
                                                                  .nomPostnomPrenom,
                                                              maxLines: 2,
                                                              style: headline5!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white))),
                                                  Positioned(
                                                      top: 150,
                                                      right: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          IconButton(
                                                              onPressed:
                                                                  hasCallSupport
                                                                      ? () =>
                                                                          setState(
                                                                              () {
                                                                            _launched =
                                                                                _makePhoneCall(widget.annuaireColor.annuaireModel.mobile1);
                                                                          })
                                                                      : null,
                                                              icon: const Icon(
                                                                Icons.call,
                                                                size: 40.0,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                if (Platform
                                                                    .isAndroid) {}
                                                              },
                                                              icon: const Icon(
                                                                Icons.sms,
                                                                size: 40.0,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                          IconButton(
                                                            onPressed: () => {},
                                                            icon: const Icon(
                                                              Icons.email_sharp,
                                                              size: 40.0,
                                                              color:
                                                                  Colors.purple,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                              const SizedBox(height: p30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (userRole <= 3)
                                                    editButton(
                                                        widget.annuaireColor),
                                                  if (userRole <= 2)
                                                    deleteButton(
                                                        widget.annuaireColor)
                                                ],
                                              ),
                                              const SizedBox(height: p30),
                                              if (Responsive.isMobile(context))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(Icons.person,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget
                                                          .annuaireColor
                                                          .annuaireModel
                                                          .nomPostnomPrenom,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              if (!widget.annuaireColor
                                                  .annuaireModel.email
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.email_sharp,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget.annuaireColor
                                                          .annuaireModel.email,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              Card(
                                                elevation: 2,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.call,
                                                    color: widget
                                                        .annuaireColor.color,
                                                    size: 40,
                                                  ),
                                                  title: Text(
                                                    widget.annuaireColor
                                                        .annuaireModel.mobile1,
                                                    style: bodyMedium,
                                                  ),
                                                  subtitle: (!widget
                                                          .annuaireColor
                                                          .annuaireModel
                                                          .mobile2
                                                          .contains('null'))
                                                      ? Text(
                                                          widget
                                                              .annuaireColor
                                                              .annuaireModel
                                                              .mobile2,
                                                          style: bodyMedium,
                                                        )
                                                      : Container(),
                                                ),
                                              ),
                                              if (!widget.annuaireColor
                                                  .annuaireModel.secteurActivite
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.local_activity,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget
                                                          .annuaireColor
                                                          .annuaireModel
                                                          .secteurActivite,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              if (!widget.annuaireColor
                                                  .annuaireModel.nomEntreprise
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.business,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget
                                                          .annuaireColor
                                                          .annuaireModel
                                                          .nomEntreprise,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              if (!widget.annuaireColor
                                                  .annuaireModel.grade
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(Icons.grade,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget.annuaireColor
                                                          .annuaireModel.grade,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                              if (!widget
                                                  .annuaireColor
                                                  .annuaireModel
                                                  .adresseEntreprise
                                                  .contains('null'))
                                                Card(
                                                  elevation: 2,
                                                  child: ListTile(
                                                    leading: Icon(
                                                        Icons.place_sharp,
                                                        color: widget
                                                            .annuaireColor
                                                            .color),
                                                    title: Text(
                                                      widget
                                                          .annuaireColor
                                                          .annuaireModel
                                                          .adresseEntreprise,
                                                      style: bodyMedium,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  Widget editButton(AnnuaireColor annuaireColor) => IconButton(
      icon: const Icon(Icons.edit_outlined),
      color: Colors.purple,
      tooltip: "Modifiaction",
      onPressed: () {
        Navigator.of(context).pushNamed(
            ComMarketingRoutes.comMarketingAnnuaireEdit,
            arguments: AnnuaireColor(
                annuaireModel: annuaireColor.annuaireModel,
                color: annuaireColor.color));
      });

  Widget deleteButton(AnnuaireColor annuaireColor) {
    return IconButton(
      icon: const Icon(Icons.delete),
      color: Colors.red,
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?'),
          content:
              const Text('Cette action permet de supprimer définitivement.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Annuler'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await AnnuaireApi()
                    .deleteData(annuaireColor.annuaireModel.id!)
                    .then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "${annuaireColor.annuaireModel.nomPostnomPrenom} vient d'être supprimé!"),
                    backgroundColor: Colors.red[700],
                  ));
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
