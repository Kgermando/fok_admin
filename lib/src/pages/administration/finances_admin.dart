import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/finances/creance_notify_api.dart';
import 'package:fokad_admin/src/api/notifications/finances/dette_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/finances/transactions/table_creance_admin.dart';
import 'package:fokad_admin/src/pages/administration/components/finances/transactions/table_dette_admin.dart';

class FinancesAdmin extends StatefulWidget {
  const FinancesAdmin({Key? key}) : super(key: key);

  @override
  State<FinancesAdmin> createState() => _FinancesAdminState();
}

class _FinancesAdminState extends State<FinancesAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ScrollController _controllerScroll = ScrollController();

  bool isOpenFin1 = false;
  bool isOpenFin2 = false;

  int nbrCreance = 0;
  int nbrDette = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var creances = await CreanceNotifyApi().getCountDG();
    var dettes = await DetteNotifyApi().getCountDG();

    setState(() {
      nbrCreance = creances.count;
      nbrDette = dettes.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
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
                          title: 'Finances',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                              color: Colors.red.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Créances',
                                    style: (Responsive.isDesktop(context))
                                        ? headline6!
                                            .copyWith(color: Colors.white)
                                        : bodyLarge!
                                            .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $nbrCreance dossiers necessitent votre approbation",
                                    style: bodyMedium!
                                        .copyWith(color: Colors.white70)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenFin1 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableCreanceAdmin()],
                              ),
                            ),
                            Card(
                              color: Colors.pink.shade700,
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder,
                                    color: Colors.white),
                                title: Text('Dossier Dettes',
                                    style: headline6!
                                        .copyWith(color: Colors.white)),
                                subtitle: Text(
                                    "Vous avez $nbrDette dossiers necessitent votre approbation",
                                    style: bodyMedium.copyWith(
                                        color: Colors.white)),
                                initiallyExpanded: false,
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isOpenFin2 = !val;
                                  });
                                },
                                trailing: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                children: const [TableDetteAdmin()],
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
          ),
        ));
  }
}
