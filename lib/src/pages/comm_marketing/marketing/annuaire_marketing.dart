import 'dart:async';

import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/marketing/annuaire_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/annuaire_xlsx.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/print_widget.dart';
import 'package:fokad_admin/src/widgets/search_widget.dart';

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  mainColor,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class AnnuaireMarketing extends StatefulWidget {
  const AnnuaireMarketing({Key? key}) : super(key: key);

  @override
  State<AnnuaireMarketing> createState() => _AnnuaireMarketingState();
}

class _AnnuaireMarketingState extends State<AnnuaireMarketing> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String query = '';
  Timer? debouncer;
  late Future<List<AnnuaireModel>> dataFuture;

  bool connectionStatus = false;

  bool isLoading = false;

  // Search
  List<AnnuaireModel> annuaireList = [];

  @override
  void initState() {
    getData();
    dataFuture = getDataFuture();
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  List<AnnuaireModel> dataList = [];
  Future<void> getData() async {
    List<AnnuaireModel> annuaires = await AnnuaireApi().getAllData();
    setState(() {
      dataList = annuaires.toList();
    });
  }

  Future<List<AnnuaireModel>> getDataFuture() async {
    var annuaires = await AnnuaireApi().getAllData();
    return annuaires;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Ajout contact',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ComMarketingRoutes.comMarketingAnnuaireAdd);
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
                      buildSearch(),
                      Expanded(
                          child: FutureBuilder<List<AnnuaireModel>>(
                              future: dataFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AnnuaireModel>> snapshot) {
                                if (snapshot.hasData) {
                                  List<AnnuaireModel>? annuaireModels =
                                      snapshot.data;
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TitleWidget(title: "Annuaire"),
                                          Row(
                                            children: [
                                              IconButton(
                                                  tooltip: "Actualiser la page",
                                                  color: Colors.green.shade700,
                                                  onPressed: () {
                                                    setState(() {
                                                      dataFuture =
                                                          getDataFuture();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.refresh)),
                                              PrintWidget(onPressed: () {
                                                AnnuaireXlsx()
                                                    .exportToExcel(dataList);
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      "Exportation effectué!"),
                                                  backgroundColor:
                                                      Colors.green[700],
                                                ));
                                              }),
                                            ],
                                          )
                                        ],
                                      ),
                                      if (annuaireModels!.isEmpty)
                                        Center(
                                          child: Text(
                                            'Ajouter un contact.',
                                            style: Responsive.isDesktop(context)
                                                ? const TextStyle(fontSize: 24)
                                                : const TextStyle(fontSize: 16),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: annuaireModels.length,
                                              itemBuilder: (context, index) {
                                                final annuaireModel =
                                                    annuaireModels[index];

                                                return buildAnnuaire(
                                                    annuaireModel, index);
                                              }),
                                        )
                                    ],
                                  );
                                } else {
                                  return Center(child: loading());
                                }
                              })),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Recherche rapide',
        onChanged: searchAchat,
      );

  Future searchAchat(String query) async => debounce(() async {
        final list = await AnnuaireApi().getAllDataSearch(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          annuaireList = list;
        });
      });

  Widget buildAnnuaire(AnnuaireModel annuaireModel, int index) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    final color = _lightColors[index % _lightColors.length];
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                  ComMarketingRoutes.comMarketingAnnuaireDetail,
                  arguments: AnnuaireColor(
                      annuaireModel: annuaireModel, color: color));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  visualDensity: VisualDensity.comfortable,
                  dense: true,
                  leading: Icon(Icons.perm_contact_cal_sharp,
                      color: color, size: 50),
                  title: Text(
                    annuaireModel.nomPostnomPrenom,
                    style: bodyText1,
                  ),
                  subtitle: Text(
                    annuaireModel.mobile1,
                    style: bodyText2,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
