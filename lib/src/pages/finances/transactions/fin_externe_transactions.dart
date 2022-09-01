import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_exterieur/table_fin_exterieur.dart';
import 'package:fokad_admin/src/routes/routes.dart';

class FinExterneTransactions extends StatefulWidget {
  const FinExterneTransactions({Key? key}) : super(key: key);

  @override
  State<FinExterneTransactions> createState() => _FinExterneTransactionsState();
}

class _FinExterneTransactionsState extends State<FinExterneTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                  context, FinanceRoutes.transactionsFinancementExterneAdd);
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
                          title: "Finance",
                          controllerMenu: () =>
                              _key.currentState!.openDrawer()),
                      const Expanded(child: TableFinExterieur())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
