import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/restitution_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class RestitutionPage extends StatefulWidget {
  const RestitutionPage({Key? key}) : super(key: key);

  @override
  State<RestitutionPage> createState() => _RestitutionPageState();
}

class _RestitutionPageState extends State<RestitutionPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController controllerScrollbar = ScrollController();
  late Future<List<RestitutionModel>> dataFuture;

  @override
  initState() {
    dataFuture = getDataFuture();
    super.initState();
  }

  Future<List<RestitutionModel>> getDataFuture() async {
    var dataF = await RestitutionApi().getAllData();
    return dataF;
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
                                  tooltip: "Actualiser la page",
                                  color: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      dataFuture = getDataFuture();
                                    });
                                  },
                                  icon: const Icon(Icons.refresh)),
                            ],
                          ),
                          Expanded(
                            child: FutureBuilder<List<RestitutionModel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<RestitutionModel>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    List<RestitutionModel>? dataList =
                                        snapshot.data;
                                    return dataList!.isEmpty
                                        ? Center(
                                            child: Text(
                                            'Pas encore de restitution.',
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
                                                  return restitutionItemWidget(
                                                      data);
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

  Widget restitutionItemWidget(RestitutionModel restitutionModel) {
    Color? nonRecu;
    if (restitutionModel.accuseReception == 'false') {
      nonRecu = const Color(0xFFa4adbe);
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, ComMarketingRoutes.comMarketingRestitutionDetail,
            arguments: restitutionModel);
      },
      child: Card(
        elevation: 10,
        color: nonRecu,
        child: ListTile(
          hoverColor: grey,
          dense: true,
          leading: const Icon(
            Icons.description,
            size: 40.0,
          ),
          title: Text(restitutionModel.succursale,
              overflow: TextOverflow.clip,
              style: Responsive.isDesktop(context)
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
          subtitle: Text(
            restitutionModel.idProduct,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
