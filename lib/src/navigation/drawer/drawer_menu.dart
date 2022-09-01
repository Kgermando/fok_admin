import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/navigation/drawer/components/actionnaire_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/update_nav.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/components/administration_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/budget_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/com_marketing_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/comptabilite_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/exploitation_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/finances_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/logistique_nav.dart';
import 'package:fokad_admin/src/navigation/drawer/components/rh_nav.dart';
import 'package:fokad_admin/src/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, this.controller}) : super(key: key);
  final PageController? controller;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final ScrollController controller = ScrollController();
  late Future<UserModel> dataFuture;
  @override
  void initState() {
    dataFuture = getData();
    super.initState();
  }

  Future<UserModel> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String? pageCurrente = ModalRoute.of(context)!.settings.name;
    if (kDebugMode) {
      print('pageCurrente $pageCurrente');
    }
    return Drawer(
      backgroundColor:
          themeProvider.isLightMode ? Colors.amber[100] : Colors.black26,
      elevation: 10.0,
      child: FutureBuilder<UserModel>(
          future: dataFuture,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.hasData) {
              UserModel? user = snapshot.data;
              int userRole = int.parse(user!.role);
              return Scrollbar(
                controller: controller,
                child: ListView(
                  controller: controller,
                  children: [
                    DrawerHeader(
                        child: Image.asset(
                      InfoSystem().logo(),
                      width: 100,
                      height: 100,
                    )),
                    if (user.departement == 'Administration')
                      if (pageCurrente != null)
                        AdministrationNav(
                            pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Ressources Humaines' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        RhNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Budgets' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        BudgetNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Finances' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        FinancesNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Comptabilites' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        ComptabiliteNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Exploitations' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        ExploitationNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Commercial et Marketing' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        ComMarketing(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Logistique' ||
                        user.departement == 'Administration')
                      if (pageCurrente != null)
                        LogistiqueNav(pageCurrente: pageCurrente, user: user),
                    if (user.departement == 'Actionnaire')
                      if (pageCurrente != null)
                        ActionnaireNav(pageCurrente: pageCurrente, user: user),
                    if (userRole <= 1)
                      UpdateNav(pageCurrente: pageCurrente!, user: user)
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: p20),
                  loading(),
                  const SizedBox(height: p20)
                ],
              );
            }
          }),
    );
  }
}
