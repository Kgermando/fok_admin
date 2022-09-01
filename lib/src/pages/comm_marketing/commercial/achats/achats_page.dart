import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/components/list_stock.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class AchatsPage extends StatefulWidget {
  const AchatsPage({Key? key}) : super(key: key);

  @override
  State<AchatsPage> createState() => _AchatsPageState();
}

class _AchatsPageState extends State<AchatsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController controllerScrollbar = ScrollController();
  late Future<List<AchatModel>> dataFuture;

  @override
  void initState() {
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
    setState(() {
      user = userModel;
    });
  }

  Future<List<AchatModel>> getDataFuture() async {
    var achats = await AchatApi().getAllData();
    return achats;
  }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppbar(
                          title: Responsive.isDesktop(context)
                              ? 'Commercial & Marketing'
                              : 'Comm. & Mark.',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    tooltip: "Actualiser",
                                    color: Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        dataFuture = getDataFuture();
                                      });
                                    },
                                    icon: const Icon(Icons.refresh))
                              ]),
                          Expanded(
                            child: FutureBuilder<List<AchatModel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<AchatModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<AchatModel>? achatList = snapshot.data!
                                        .where((element) =>
                                            element.succursale ==
                                            user.succursale)
                                        .toList();
                                    return achatList.isEmpty
                                        ? Center(
                                            child: Text(
                                            'Pas encore stocks.',
                                            style: Responsive.isDesktop(context)
                                                ? const TextStyle(fontSize: 24)
                                                : const TextStyle(fontSize: 16),
                                          ))
                                        : ListView.builder(
                                            itemCount: achatList.length,
                                            itemBuilder: (context, index) {
                                              final data = achatList[index];
                                              return ListStock(
                                                  achat: data, role: user.role);
                                            });
                                  } else {
                                    return Center(child: loading());
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
}
