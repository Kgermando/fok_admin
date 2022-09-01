import 'package:fokad_admin/src/api/comm_marketing/commerciale/succursale_api.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/desktop/detail._user_desktop.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/mobile/detail_user_mobile.dart';
import 'package:fokad_admin/src/pages/rh/agents/plateforms/tablet/detail_user_tablet.dart';
import 'package:fokad_admin/src/utils/info_system.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/user/user_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({Key? key}) : super(key: key);

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List<SuccursaleModel> succursaleList = [];
  Future<void> getData() async {
    var succursales = await SuccursaleApi().getAllData();
    setState(() {
      succursaleList = succursales;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(InfoSystem().logo()),
          fit: BoxFit.cover,
          // opacity: .4
        ),
      ),
      child: Scaffold(
          key: _key,
          // backgroundColor: Colors.transparent,
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
                          future: UserApi().getOneData(id),
                          builder: (BuildContext context,
                              AsyncSnapshot<UserModel> snapshot) {
                            if (snapshot.hasData) {
                              UserModel? user = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
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
                                            title: "Utilisateurs",
                                            controllerMenu: () => _key
                                                .currentState!
                                                .openDrawer()),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (constraints.maxWidth >= 1100) {
                                      return DetailUserDesktop(
                                          user: user!,
                                          succursaleList: succursaleList);
                                    } else if (constraints.maxWidth < 1100 &&
                                        constraints.maxWidth >= 650) {
                                      return DetailUserTablet(
                                          user: user!,
                                          succursaleList: succursaleList);
                                    } else {
                                      return DetailUserMobile(
                                          user: user!,
                                          succursaleList: succursaleList);
                                    }
                                  }))
                                ],
                              );
                            } else {
                              return Center(child: loading());
                            }
                          })),
                ),
              ],
            ),
          )),
    );
  }
}
