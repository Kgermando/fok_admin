import 'package:flutter/material.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/table_banque.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class BanqueTransactions extends StatefulWidget {
  const BanqueTransactions({Key? key}) : super(key: key);

  @override
  State<BanqueTransactions> createState() => _BanqueTransactionsState();
}

class _BanqueTransactionsState extends State<BanqueTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        floatingActionButton: speedialWidget(),
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
                      const Expanded(child: TableBanque())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  SpeedDial speedialWidget() {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.upload),
          foregroundColor: Colors.white,
          backgroundColor: Colors.yellow.shade700,
          label: 'Retrait',
          onPressed: () {
            Navigator.pushNamed(
                context, FinanceRoutes.transactionsBanqueRetrait);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.file_download),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          label: 'Dépôt',
          onPressed: () {
            Navigator.pushNamed(context, FinanceRoutes.transactionsBanqueDepot);
          },
        ),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
