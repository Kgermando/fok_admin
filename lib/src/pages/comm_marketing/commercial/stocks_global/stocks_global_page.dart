import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/stock_global_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/list_stock_global.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class StockGlobalPage extends StatefulWidget {
  const StockGlobalPage({Key? key}) : super(key: key);

  @override
  State<StockGlobalPage> createState() => _StockGlobalPageState();
}

class _StockGlobalPageState extends State<StockGlobalPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController controllerScrollbar = ScrollController();
  late Future<List<StocksGlobalMOdel>> dataFuture;

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

  Future<List<StocksGlobalMOdel>> getDataFuture() async {
    var stocks = await StockGlobalApi().getAllData();
    return stocks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: "Nouveau stock",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                  context, ComMarketingRoutes.comMarketingStockGlobalAdd);
            }),
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
                            child: FutureBuilder<List<StocksGlobalMOdel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<StocksGlobalMOdel>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    List<StocksGlobalMOdel>? dataList =
                                        snapshot.data;
                                    return dataList!.isEmpty
                                        ? Center(
                                            child: Text(
                                            'Ajoutez un stock.',
                                            style: Responsive.isDesktop(context)
                                                ? const TextStyle(fontSize: 24)
                                                : const TextStyle(fontSize: 16),
                                          ))
                                        : Scrollbar(
                                            controller: controllerScrollbar,
                                            child: ListView.builder(
                                                controller: controllerScrollbar,
                                                itemCount: dataList.length,
                                                itemBuilder: (context, index) {
                                                  final data = dataList[index];
                                                  return ListStockGlobal(
                                                      stocksGlobalMOdel: data,
                                                      role: user.role);
                                                }),
                                          );
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
