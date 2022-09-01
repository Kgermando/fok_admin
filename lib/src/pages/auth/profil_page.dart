import 'package:fokad_admin/src/utils/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:intl/intl.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                  child: FutureBuilder<UserModel>(
                    future: AuthApi().getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel? userInfo = snapshot.data;
                        if (userInfo != null) {
                          var userData = userInfo;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.arrow_back)),
                                  ),
                                  const SizedBox(
                                    width: p10,
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: CustomAppbar(
                                          title: (Responsive.isDesktop(context))
                                              ? 'Votre profil'
                                              : 'Profil',
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer())),
                                ],
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                      child: profileBody(userData))),
                            ],
                          );
                        }
                      } else {
                        return Center(child: loading());
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget profileBody(UserModel userModel) {
    final headline5 = Theme.of(context).textTheme.headline5;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    final String firstLettter2 = userModel.prenom[0];
    final String firstLettter = userModel.nom[0];

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              color: mainColor,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              top: 130,
              left: (Responsive.isDesktop(context)) ? 50 : 10,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.0, color: mainColor)),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: AutoSizeText(
                    '$firstLettter2$firstLettter'.toUpperCase(),
                    maxLines: 2,
                    style: headline5!.copyWith(color: mainColor),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 150,
                left: (Responsive.isDesktop(context)) ? 180 : 120,
                child: (Responsive.isDesktop(context))
                    ? AutoSizeText("${userModel.prenom} ${userModel.nom}",
                        style: headline5.copyWith(color: Colors.white))
                    : Column(
                        children: [
                          AutoSizeText(userModel.prenom,
                              textAlign: TextAlign.left,
                              style: bodyLarge!.copyWith(color: Colors.white)),
                          AutoSizeText(userModel.nom,
                              textAlign: TextAlign.left,
                              style: bodyLarge.copyWith(color: Colors.white))
                        ],
                      )),
            Positioned(
                top: 155,
                right: 20,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    shape: BoxShape.circle,
                  ),
                ))
          ],
        ),
        const SizedBox(height: p50),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Nom',
                        maxLines: 2,
                        style:
                            bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.nom,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Prénom',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.prenom,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Matricule',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.matricule,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Département',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.departement,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Services d\'Affectation',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.servicesAffectation,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Fonction Occupée',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.fonctionOccupe,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Accréditation',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText("Niveau ${userModel.role}",
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Succursale',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(userModel.succursale,
                        maxLines: 2, style: bodyLarge))
              ],
            ),
          ),
        ),
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(p20),
            child: Row(
              children: [
                Expanded(
                    child: AutoSizeText('Date de création',
                        maxLines: 2,
                        style:
                            bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: p20),
                Expanded(
                    child: AutoSizeText(
                        DateFormat("dd.MM.yy HH:mm")
                            .format(userModel.createdAt),
                        maxLines: 2,
                        style: bodyLarge))
              ],
            ),
          ),
        ),
        const SizedBox(height: p20),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(UserRoutes.changePassword, arguments: userModel);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ChangePassword(userModel: userModel)));
            },
            icon: const Icon(Icons.password, color: Colors.white),
            label: AutoSizeText("Modifiez votre mot de passe",
                style: Theme.of(context).textTheme.bodyLarge)),
        const SizedBox(height: p30),
      ],
    );
  }
}
