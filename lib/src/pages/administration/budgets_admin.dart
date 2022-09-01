import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/notifications/budgets/budget_notify_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/administration/components/budgets/table_departement_budget_admin.dart';

class BudgetsAdmin extends StatefulWidget {
  const BudgetsAdmin({Key? key}) : super(key: key);

  @override
  State<BudgetsAdmin> createState() => _BudgetsAdminState();
}

class _BudgetsAdminState extends State<BudgetsAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _controllerScroll = ScrollController();

  bool isOpenBudget = false;

  int budgetCount = 0;

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var budgetCountNotify = await BudgetNotifyApi().getCountDG();
    setState(() {
      budgetCount = budgetCountNotify.count;
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
                          title: 'Budgets',
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      Expanded(
                          child: Scrollbar(
                        controller: _controllerScroll,
                        child: ListView(
                          controller: _controllerScroll,
                          children: [
                            Card(
                                color: Colors.blue.shade700,
                                child: ExpansionTile(
                                  leading: const Icon(Icons.folder,
                                      color: Colors.white),
                                  title: Text('Dossier Budgets',
                                      style: (Responsive.isDesktop(context))
                                          ? headline6!
                                              .copyWith(color: Colors.white)
                                          : bodyLarge!
                                              .copyWith(color: Colors.white)),
                                  subtitle: Text(
                                      "Vous avez $budgetCount dossiers necessitent votre approbation",
                                      style: bodyMedium!
                                          .copyWith(color: Colors.white70)),
                                  initiallyExpanded: false,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      isOpenBudget = !val;
                                    });
                                  },
                                  trailing: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  children: const [TableDepartementBudgetDG()],
                                )),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Widget folderWidget() {
  //   final bodyMedium = Theme.of(context).textTheme.bodyMedium;
  //   return SizedBox(
  //     width: 100,
  //     child: InkWell(
  //       onDoubleTap: () {},
  //       child: Badge(
  //         badgeContent: Text("$budgetCount"),
  //         child: Column(
  //           children: [
  //             Icon(
  //               Icons.folder,
  //               size: p50, color: Colors.blue.shade700),
  //             Text("Budgets",
  //             style: bodyMedium!.copyWith(color: Colors.blue))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
