import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/comm_marketing/commerciale/achat_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/ventes/components/vente_items_widget.dart';
import 'package:fokad_admin/src/utils/loading.dart';

class VentesPage extends StatefulWidget {
  const VentesPage({Key? key}) : super(key: key);

  @override
  State<VentesPage> createState() => _VentesPageState();
}

class _VentesPageState extends State<VentesPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();
  bool isLoading = false;
  late Future<List<AchatModel>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getDataFuture();
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          Expanded(
                              flex: 5,
                              child: CustomAppbar(
                                  title: Responsive.isDesktop(context)
                                      ? 'Commercial & Marketing'
                                      : 'Comm. & Mark.',
                                  controllerMenu: () =>
                                      _key.currentState!.openDrawer())),
                        ],
                      ),
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
                                    icon: const Icon(Icons.refresh))
                              ]),
                          Expanded(
                            child: FutureBuilder<List<AchatModel>>(
                                future: dataFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<AchatModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<AchatModel>? achats = snapshot.data;
                                    return achats!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Ajoutez en des articles à vendre.',
                                              style:
                                                  Responsive.isDesktop(context)
                                                      ? const TextStyle(
                                                          fontSize: 24)
                                                      : const TextStyle(
                                                          fontSize: 16),
                                            ),
                                          )
                                        : Scrollbar(
                                            controller: _controllerScroll,
                                            child: ListView.builder(
                                                controller: _controllerScroll,
                                                itemCount: achats.length,
                                                itemBuilder: (context, index) {
                                                  final achat = achats[index];
                                                  return AchatItemWidget(
                                                      achat: achat);
                                                }),
                                          );
                                  } else {
                                    return Center(child: loading());
                                  }
                                }),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
